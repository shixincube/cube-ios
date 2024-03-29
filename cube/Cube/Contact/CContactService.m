/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Cube Team.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "CContactService.h"
#import "CAuthToken.h"
#import "CError.h"
#import "CKernel.h"
#import "CEntityInspector.h"
#import "CObservableEvent.h"
#import "CUtils.h"
#import "CContactPipelineListener.h"
#import "CContactStorage.h"
#import "CContactAction.h"
#import "CContactEvent.h"
#import "CContactServiceState.h"
#import "CSelf.h"
#import "CContact.h"
#import "CDevice.h"
#import "CGroup.h"
#import "CContactZone.h"
#import "CContactZoneParticipant.h"
#import "CContactAppendix.h"
#import "CGroupAppendix.h"

@interface CContactService () {

    CContactPipelineListener * _pipelineListener;

    CContactStorage * _storage;

    // 用于临时缓存实体的缓存器
    NSMutableDictionary<__kindof NSString *, __kindof CEntity *> * _cache;

    BOOL _signInReady;

    NSInteger _waitSignInCount;

    dispatch_queue_t _threadQueue;
}

/*!
 * @brief 通过向服务发送状态信息验证自身连接状态。
 */
- (void)comeback;

- (void)waitSignIn:(void(^)(BOOL timeout))handler;

@end


@implementation CContactService

- (instancetype)init {
    if (self = [super initWithName:CUBE_MODULE_CONTACT]) {
        _owner = nil;
        _pipelineListener = [[CContactPipelineListener alloc] initWithService:self];
        _storage = [[CContactStorage alloc] initWithService:self];
        _cache = [[NSMutableDictionary alloc] init];
        _signInReady = FALSE;

        self.retrospectDuration = 30L * 24L * 60L * 60000L;

        _threadQueue = dispatch_queue_create("CContactServiceQueue", DISPATCH_QUEUE_CONCURRENT);
    }

    return self;
}

- (BOOL)start {
    if (![super start]) {
        return FALSE;
    }

    [self.pipeline addListener:_pipelineListener withDestination:CUBE_MODULE_CONTACT];

    // 使用 Inspector 管理缓存
    [self.kernel.entityInspector depositMap:_cache];

    return TRUE;
}

- (void)stop {
    [super stop];

    [self.kernel.entityInspector withdrawMap:_cache];
    [_cache removeAllObjects];

    [self.pipeline removeListener:_pipelineListener withDestination:CUBE_MODULE_CONTACT];

    // 关闭存储
    [_storage close];

    _signInReady = FALSE;
}

- (void)suspend {
    [super suspend];
}

- (void)resume {
    [super resume];
    [self comeback];
}

- (BOOL)isReady {
    return _signInReady && (nil != self.owner);
}

- (BOOL)signIn:(CSelf *)me handleSuccess:(CSignBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure {
    // 不允许重复签入
    if (_signInReady) {
        return FALSE;
    }

    if (nil != _owner && ![_owner isEqual:me]) {
        NSLog(@"CContactService : Can NOT use different contact to sign-in");
        return FALSE;
    }

    // 检查是否已经启动模块
    if (![self hasStarted]) {
        [self start];
    }

    NSThread * thread = [[NSThread alloc] initWithBlock:^{
        [self runSignInTask:me handleSuccess:handleSuccess handleFailure:handleFailure];
    }];
    [thread start];

    return TRUE;
}

- (void)runSignInTask:(CSelf *)me handleSuccess:(CSignBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure {
    // 等待内核就绪
    int count = 500;
    NSTimeInterval time = 1.0f / 1000.0f * 10.0f;
    while (![self.kernel isReady] && count > 0) {
        --count;
        [NSThread sleepForTimeInterval:time];
    }

    if (![self.kernel isReady]) {
        // 内核未就绪
        handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:CContactServiceStateNotAllowed]);
        return;
    }

    // 开启存储
    [_storage open:me.identity domain:me.domain];

    // 设置 Owner 实例
    _owner = me;

    if (![self.pipeline isReady]) {
        // 网络未连接状态下签入
        CContact * selfContact = [_storage readContact:me.identity];
        // 激活令牌
        CAuthToken * token = [self.kernel activeToken:me.identity];

        if (nil != selfContact && nil != token) {
            // 设置附录
            _owner.appendix = selfContact.appendix;
            // 设置上下文
            if (_owner.context) {
                // 更新联系人的上下文
                UInt64 last = [_storage updateContactContext:_owner.identity context:_owner.context];
                [_owner resetLast:last];
            }
            else {
                _owner.context = selfContact.context;
            }

            dispatch_async(_threadQueue, ^ {
                CObservableEvent * event = [[CObservableEvent alloc] initWithName:CContactEventSelfReady data:self->_owner];
                [self notifyObservers:event];

                handleSuccess(self.owner);
            });
        }
        else {
            dispatch_async(_threadQueue, ^ {
                handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:CContactServiceStateNoNetwork]);
            });
        }

        return;
    }
    
    // 访问服务器进行签入

    // 10 秒
    _waitSignInCount = 100;

    // 激活令牌
    CAuthToken * token = [self.kernel activeToken:me.identity];
    if (token) {
        // 通知系统 Self 实例就绪
        dispatch_async(_threadQueue, ^{
            CObservableEvent * event = [[CObservableEvent alloc] initWithName:CContactEventSelfReady data:self->_owner];
            [self notifyObservers:event];
        });

        // 请求服务器进行签入
        NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
        [data setValue:[me toJSON] forKey:@"self"];
        [data setValue:[token toJSON] forKey:@"token"];

        CPacket * signInPacket = [[CPacket alloc] initWithName:CUBE_CONTACT_SIGNIN andData:data];
        [self.pipeline send:CUBE_MODULE_CONTACT withPacket:signInPacket handleResponse:^(CPacket *packet) {
            // 等待 Sign In 完成
            [self waitSignIn:^(BOOL timeout) {
                if (timeout) {
                    // 超时
                    handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:CContactServiceStateServerError]);
                }
                else {
                    handleSuccess(self.owner);
                }
            }];
        }];
    }
    else {
        dispatch_async(_threadQueue, ^{
            handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:CContactServiceStateInconsistentToken]);
        });
    }
}

- (BOOL)signInWith:(UInt64)identity name:(NSString *)name context:(NSDictionary *)context handleSuccess:(CSignBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure {
    CSelf * owner = [[CSelf alloc] initWithId:identity name:name context:context];
    return [self signIn:owner handleSuccess:handleSuccess handleFailure:handleFailure];
}

- (BOOL)signOut:(CSignBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure {
    if (nil == _owner) {
        return FALSE;
    }

    if (![self.pipeline isReady]) {
        // 无网络状态下签出
        _signInReady = FALSE;

        // 关闭存储
        [_storage close];

        dispatch_async(self->_threadQueue, ^{
            CObservableEvent * event = [[CObservableEvent alloc] initWithName:CContactEventSignOut data:self->_owner];
            [self notifyObservers:event];

            handleSuccess(self->_owner);
            self->_owner = nil;
        });

        return TRUE;
    }

    NSMutableDictionary * data = [self.owner toJSON];
    CPacket * signOutPacket = [[CPacket alloc] initWithName:CUBE_CONTACT_SIGNOUT andData:data];

    [self.pipeline send:CUBE_MODULE_CONTACT withPacket:signOutPacket handleResponse:^(CPacket * packet) {
        if (packet.state.code != CStateOk) {
            dispatch_async(self->_threadQueue, ^{
                handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:packet.state.code]);
            });
            return;
        }

        int stateCode = [packet extractStateCode];
        if (stateCode != CContactServiceStateOk) {
            dispatch_async(self->_threadQueue, ^{
                handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:stateCode]);
            });
            return;
        }

        self->_signInReady = FALSE;

        // 关闭存储器
        [self->_storage close];

        CSelf * owner = self->_owner;
        dispatch_async(self->_threadQueue, ^{
            handleSuccess(owner);
        });
    }];

    return TRUE;
}

- (void)comeback {
    if ([self.pipeline isReady]) {
        // 发送 comeback
        if (self.owner) {
            NSDictionary * data = [self.owner toJSON];
            CPacket * requestPacket = [[CPacket alloc] initWithName:CUBE_CONTACT_COMEBACK andData:data];
            [self.pipeline send:CUBE_MODULE_CONTACT withPacket:requestPacket handleResponse:^(CPacket *packet) {
                if (packet.state.code == CStateOk && [packet extractStateCode] == CContactServiceStateOk) {
                    NSLog(@"CContactService self comeback");
                    CObservableEvent * event = [[CObservableEvent alloc] initWithName:CContactEventComeback data:self.owner];
                    [self notifyObservers:event];
                }
            }];
        }
    }
}

- (void)getContact:(UInt64)contactId handleSuccess:(CContactBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure {
    if (nil == _owner) {
        dispatch_async(_threadQueue, ^{
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:CContactServiceStateIllegalOperation];
            handleFailure(error);
        });
        return;
    }

    if (contactId == self.owner.identity) {
        dispatch_async(_threadQueue, ^{
            handleSuccess(self.owner);
        });
        return;
    }

    // 从缓存里读取
    CEntity * entity = [_cache objectForKey:[NSString stringWithFormat:@"%llu", contactId]];
    if (entity) {
        dispatch_async(_threadQueue, ^{
            handleSuccess((CContact *)entity);
        });
        return;
    }

    // 从数据库读取
    CContact * contact = [_storage readContact:contactId];
    if (contact) {
        // 在没有连接服务器或者数据有效时返回
        if (![self.pipeline isReady] || [contact isValid]) {
            // 检查上下文
            if (nil == contact.context && self.delegate
                    && [self.delegate respondsToSelector:@selector(needContactContext:)]) {
                contact.context = [self.delegate needContactContext:contact];
                if (contact.context) {
                    UInt64 last = [_storage updateContactContext:contact.identity context:contact.context];
                    [contact resetLast:last];
                }
            }

            // 写入缓存
            [_cache setObject:contact forKey:[NSString stringWithFormat:@"%llu", contactId]];

            dispatch_async(_threadQueue, ^{
                handleSuccess(contact);
            });
            return;
        }
    }

    // 检查数据通道
    if (![self.pipeline isReady]) {
        dispatch_async(_threadQueue, ^{
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:CContactServiceStateNoNetwork];
            handleFailure(error);
        });
        return;
    }

    NSDictionary * packetData = @{
        @"id" : [NSNumber numberWithUnsignedLongLong:contactId],
        @"domain" : self.kernel.authToken.domain
    };

    CPacket * requestPacket = [[CPacket alloc] initWithName:CUBE_CONTACT_GETCONTACT andData:packetData];
    [self.pipeline send:CUBE_MODULE_CONTACT withPacket:requestPacket handleResponse:^(CPacket *packet) {
        if (packet.state.code != CStateOk) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:CContactServiceStateServerError];
            handleFailure(error);
            return;
        }

        int stateCode = [packet extractStateCode];
        if (stateCode != CContactServiceStateOk) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:stateCode];
            handleFailure(error);
            return;
        }

        CContact * contact = [[CContact alloc] initWithJSON:[packet extractData] domain:self.kernel.authToken.domain];

        // 获取上下文
        if (nil == contact.context) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(needContactContext:)]) {
                contact.context = [self.delegate needContactContext:contact];
            }
        }

        // 写入数据库
        [self->_storage writeContact:contact];

        // 获取附录
        [self getAppendixWithContact:contact handleSuccess:^(CContact * contact, CContactAppendix * appendix) {
            // 写入缓存
            [self->_cache setObject:contact forKey:[NSString stringWithFormat:@"%llu", contactId]];

            handleSuccess(contact);
        } handleFailure:^(CError * error) {
            handleFailure(error);
        }];
    }];
}

- (void)modifyContactName:(CContact *)contact newName:(NSString *)name {
    contact.name = name;
    [_storage updateContactName:contact.identity name:name];
}

- (void)getAppendixWithContact:(CContact *)contact handleSuccess:(void(^)(CContact *, CContactAppendix *))handleSuccess handleFailure:(CFailureBlock)handleFailure {
    
    NSNumber * contactId = [NSNumber numberWithUnsignedLongLong:contact.identity];
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:contactId, @"contactId", nil];
    CPacket * request = [[CPacket alloc] initWithName:CUBE_CONTACT_GETAPPENDIX andData:data];
    // 发送请求
    [self.pipeline send:CUBE_MODULE_CONTACT withPacket:request handleResponse:^(CPacket *packet) {
        if (packet.state.code != CStateOk) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:packet.state.code];
            handleFailure(error);
            return;
        }

        int stateCode = [packet extractStateCode];
        if (stateCode != CContactServiceStateOk) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:stateCode];
            handleFailure(error);
            return;
        }

        CContactAppendix * appendix = [[CContactAppendix alloc] initWithService:self contact:contact json:[packet extractData]];

        // 更新存储
        [self->_storage writeContactAppendix:appendix];

        // 赋值
        contact.appendix = appendix;

        handleSuccess(contact, appendix);
    }];
}

- (void)getAppendixWithGroup:(CGroup *)group handleSuccess:(void(^)(CGroup *, CGroupAppendix *))handleSuccess handleFailure:(CFailureBlock)handleFailure {
    // TODO
}

- (void)listGroups:(UInt64)beginning ending:(UInt64)ending handler:(void (^)(NSArray *))handler {
    // TODO
    NSMutableArray * list = [[NSMutableArray alloc] init];
    handler(list);
}

- (void)getContactZone:(NSString *)zoneName handleSuccess:(void (^)(CContactZone *))handleSuccess handleFailure:(CFailureBlock)handleFailure {
    // 从数据库里读取
    __block CContactZone * zone = [_storage readContactZone:zoneName];
    if (nil != zone) {
        if ([zone isValid]) {
            __block NSUInteger count = zone.participants.count;

            for (CContactZoneParticipant * participant in zone.participants) {
                [self getContact:participant.contactId handleSuccess:^(CContact *contact) {
                    // 匹配到参与人
                    [zone matchContact:contact];

                    --count;

                    if (count == 0) {
                        handleSuccess(zone);
                    }
                } handleFailure:^(CError * _Nullable error) {
                    --count;

                    if (count == 0) {
                        handleSuccess(zone);
                    }
                }];
            }
        }

        return;
    }

    // 数据库没有数据或已经过期，从服务器获取
    NSDictionary * data = @{
        @"name" : zoneName
    };
    CPacket * request = [[CPacket alloc] initWithName:CUBE_CONTACT_GETCONTACTZONE andData:data];
    // 发送请求
    [self.pipeline send:CUBE_MODULE_CONTACT withPacket:request handleResponse:^(CPacket *packet) {
        if (packet.state.code != CStateOk) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:packet.state.code];
            dispatch_async(self->_threadQueue, ^{
                handleFailure(error);
            });
            return;
        }

        int stateCode = [packet extractStateCode];
        if (stateCode != CContactServiceStateOk) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:stateCode];
            dispatch_async(self->_threadQueue, ^{
                handleFailure(error);
            });
            return;
        }

        zone = [[CContactZone alloc] initWithJSON:[packet extractData]];

        dispatch_queue_t queue = dispatch_queue_create("cube.contact.zone.update", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            // 写入数据库
            [self->_storage writeContactZone:zone];

            __block NSUInteger count = zone.count;

            for (CContactZoneParticipant * participant in zone.participants) {
                [self getContact:participant.contactId handleSuccess:^(CContact *contact) {
                    // 匹配到参与人
                    [zone matchContact:contact];

                    --count;

                    if (count == 0) {
                        handleSuccess(zone);
                    }
                } handleFailure:^(CError * _Nullable error) {
                    --count;

                    if (count == 0) {
                        handleSuccess(zone);
                    }
                }];
            }
        });
    }];
}

- (void)createContactZone:(NSString *)zoneName displayName:(NSString *)displayName contactIdList:(NSArray<__kindof NSNumber *> *)contactIdList handleSuccess:(void (^)(CContactZone *))handleSuccess handleFailure:(CFailureBlock)handleFailure {
    // 从数据库里读取
    CContactZone * zone = [_storage readContactZone:zoneName];
    if (nil != zone) {
        // 已经有该分区，不能创建
        dispatch_async(_threadQueue, ^{
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:CContactServiceStateNotAllowed];
            handleFailure(error);
        });
        return;
    }

    NSDictionary * data = @{
        @"name" : zoneName,
        @"contacts" : contactIdList,
        @"displayName" : (nil != displayName) ? displayName : @""
    };
    CPacket * request = [[CPacket alloc] initWithName:CUBE_CONTACT_CREATECONTACTZONE andData:data];
    // 发送请求
    [self.pipeline send:CUBE_MODULE_CONTACT withPacket:request handleResponse:^(CPacket *packet) {
        if (packet.state.code != CStateOk) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:packet.state.code];
            dispatch_async(self->_threadQueue, ^{
                handleFailure(error);
            });
            return;
        }

        int stateCode = [packet extractStateCode];
        if (stateCode != CContactServiceStateOk) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:stateCode];
            dispatch_async(self->_threadQueue, ^{
                handleFailure(error);
            });
            return;
        }

        CContactZone * zone = [[CContactZone alloc] initWithJSON:[packet extractData]];

        dispatch_queue_t queue = dispatch_queue_create("cube.contact.zone.update", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            // 写入数据库
            [self->_storage writeContactZone:zone];

            __block NSUInteger count = zone.count;

            for (CContactZoneParticipant * participant in zone.participants) {
                [self getContact:participant.contactId handleSuccess:^(CContact *contact) {
                    // 匹配到参与人
                    [zone matchContact:contact];

                    --count;

                    if (count == 0) {
                        handleSuccess(zone);
                    }
                } handleFailure:^(CError * _Nullable error) {
                    --count;

                    if (count == 0) {
                        handleSuccess(zone);
                    }
                }];
            }
        });
    }];
}

- (void)getGroup:(UInt64)groupId handleSuccess:(CGroupBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure {
    dispatch_async(_threadQueue, ^ {
        CGroup * group = [[CGroup alloc] init];
        handleSuccess(group);
    });
}

#pragma mark - Private

- (void)waitSignIn:(void (^)(BOOL timeout))handler {
    --_waitSignInCount;
    if (_waitSignInCount <= 0) {
        // 超时
        handler(TRUE);
        _waitSignInCount = 0;
        return;
    }

    if (_signInReady) {
        // 未超时
        handler(FALSE);
        _waitSignInCount = 0;
        return;
    }

    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC);
    dispatch_after(delayInNanoSeconds,
                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                ^(void) {
                    [self waitSignIn:handler];
                });
}

- (void)fireSignInCompleted {
    // 更新状态
    _signInReady = TRUE;

    // 写入数据到存储
    [_storage writeContact:self.owner];

    CObservableEvent * event = [[CObservableEvent alloc] initWithName:CContactEventSignIn data:self.owner];
    [self notifyObservers:event];
}

- (void)refreshContactZone:(CContactZone *)zone {
    // TODO XJW 需要修改流程 2021-11-05
    NSDictionary * data = @{
        @"name" : zone.name,
        @"compact": [NSNumber numberWithBool:TRUE]
    };
    CPacket * request = [[CPacket alloc] initWithName:CUBE_CONTACT_GETCONTACTZONE andData:data];
    // 发送请求
    [self.pipeline send:CUBE_MODULE_CONTACT withPacket:request handleResponse:^(CPacket *packet) {
        if (packet.state.code != CStateOk) {
            NSLog(@"CContactService#refreshContactZone error : %d", packet.state.code);
            return;
        }

        int stateCode = [packet extractStateCode];
        if (stateCode != CContactServiceStateOk) {
            NSLog(@"CContactService#refreshContactZone error : %d", stateCode);
            return;
        }

        CContactZone * newZone = [[CContactZone alloc] initWithJSON:[packet extractData]];
        if (newZone.timestamp == zone.timestamp) {
            // 时间戳没有改变，不刷新
            return;
        }

        // 重置分区
        [self resetContactZone:zone];
    }];
}

- (void)resetContactZone:(CContactZone *)zone {
    NSDictionary * data = @{
        @"name" : zone.name
    };
    CPacket * request = [[CPacket alloc] initWithName:CUBE_CONTACT_GETCONTACTZONE andData:data];
    // 发送请求
    [self.pipeline send:CUBE_MODULE_CONTACT withPacket:request handleResponse:^(CPacket *packet) {
        if (packet.state.code != CStateOk) {
            NSLog(@"CContactService#resetContactZone error : %d", packet.state.code);
            return;
        }

        int stateCode = [packet extractStateCode];
        if (stateCode != CContactServiceStateOk) {
            NSLog(@"CContactService#resetContactZone error : %d", stateCode);
            return;
        }

        CContactZone * newZone = [[CContactZone alloc] initWithJSON:[packet extractData]];
        [self->_storage writeContactZone:newZone];
    }];
}

@end
