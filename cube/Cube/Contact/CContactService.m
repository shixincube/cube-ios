/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Shixin Cube Team.
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
#import "CContactPipelineListener.h"
#import "CContactStorage.h"
#import "CContactAction.h"
#import "CContactEvent.h"
#import "CContactServiceState.h"
#import "CError.h"
#import "CKernel.h"
#import "CUtils.h"

@interface CContactService () {
    
    CContactPipelineListener * _pipelineListener;
    
    CContactStorage * _storage;
    
    BOOL _selfReady;
    
    NSInteger _waitReadyCount;
}

- (void)waitReady:(void(^)(BOOL timeout))handler;

@end


@implementation CContactService

- (instancetype)init {
    if (self = [super initWithName:CUBE_MODULE_CONTACT]) {
        _myself = nil;
        _pipelineListener = [[CContactPipelineListener alloc] initWithService:self];
        _storage = [[CContactStorage alloc] initWithService:self];
        _selfReady = FALSE;

        self.defaultRetrospect = 30 * 24 * 60 * 60000L;
    }

    return self;
}

- (BOOL)start {
    if (![super start]) {
        return FALSE;
    }

    [self.pipeline addListener:CUBE_MODULE_CONTACT listener:_pipelineListener];

    return TRUE;
}

- (void)stop {
    [super stop];

    [self.pipeline removeListener:CUBE_MODULE_CONTACT listener:_pipelineListener];
    
    // 关闭存储
    [_storage close];
    
    _selfReady = FALSE;
}

- (void)suspend {
    [super suspend];
}

- (void)resume {
    [super resume];
}

- (BOOL)isReady {
    if (self.kernel.config.unconnected) {
        return (nil != self.myself);
    }
    else {
        return _selfReady;
    }
}

- (void)signIn:(CSelf *)mySelf handleSuccess:(sign_block_t)handleSuccess handleFailure:(cube_failure_block_t)handleFailure {
    // 检查是否已经启动模块
    if (![self hasStarted]) {
        [self start];
    }

    // 开启存储
    [_storage open:mySelf.identity domain:mySelf.domain];

    // 是否允许未连接状态下签入
    if (self.kernel.config.unconnected) {
        CContact * myselfContact = [_storage readContact:mySelf.identity];

        if (myselfContact) {
            self.myself = mySelf;
            self.myself.context = myselfContact.context;
            self.myself.appendix = myselfContact.appendix;

            handleSuccess(self.myself);

            return;
        }
    }

    // 设置 MySelf 实例
    self.myself = mySelf;

    if (![self.pipeline isReady]) {
        handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:CSC_Contact_NoNetwork]);
        return;
    }

    // 10 秒
    _waitReadyCount = 100;

    [self.kernel activeToken:mySelf.identity handler:^(CAuthToken * token) {
        if (token) {
            // 打包数据
            NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
            [data setValue:[mySelf toJSON] forKey:@"self"];
            [data setValue:[token toJSON] forKey:@"token"];

            CPacket * signInPacket = [[CPacket alloc] initWithName:CUBE_CONTACT_SIGNIN andData:data];
            [self.pipeline send:CUBE_MODULE_CONTACT withPacket:signInPacket handleResponse:^(CPacket *packet) {
                [self waitReady:^(BOOL timeout) {
                    if (timeout) {
                        // 超时
                        handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:CSC_Contact_ServerError]);
                    }
                    else {
                        handleSuccess(self.myself);
                    }
                }];
            }];
        }
        else {
            handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:CSC_Contact_InconsistentToken]);
        }
    }];
}

- (void)signInWith:(UInt64)identity name:(NSString *)name handleSuccess:(sign_block_t)handleSuccess handleFailure:(cube_failure_block_t)handleFailure {
    CSelf * mySelf = [[CSelf alloc] initWithId:identity name:name];
    [self signIn:mySelf handleSuccess:handleSuccess handleFailure:handleFailure];
}

- (BOOL)signOut:(sign_block_t)handle {
    if (!_selfReady) {
        return FALSE;
    }

    if (![self.pipeline isReady]) {
        return FALSE;
    }

    NSMutableDictionary * data = [self.myself toJSON];
    CPacket * signOutPacket = [[CPacket alloc] initWithName:CUBE_CONTACT_SIGNOUT andData:data];

    [self.pipeline send:CUBE_MODULE_CONTACT withPacket:signOutPacket handleResponse:^(CPacket * packet) {
        if (packet.state.code != CSC_Ok) {
            return;
        }

        int stateCode = [packet extractStateCode];
        if (stateCode != CSC_Contact_Ok) {
            return;
        }

        self->_selfReady = FALSE;

        handle(self.myself);
    }];

    return TRUE;
}

- (void)comeback {
    if ([self.pipeline isReady]) {
        // 发送 comeback
        if (self.myself) {
            NSDictionary * data = [self.myself toJSON];
            CPacket * requestPacket = [[CPacket alloc] initWithName:CUBE_CONTACT_COMEBACK andData:data];
            [self.pipeline send:CUBE_MODULE_CONTACT withPacket:requestPacket handleResponse:^(CPacket *packet) {
                if (packet.state.code == CSC_Ok && [packet extractStateCode] == CSC_Contact_Ok) {
                    NSLog(@"CContactService self comeback");
                    CObservableEvent * event = [[CObservableEvent alloc] initWithName:CContactEventComeback data:self.myself];
                    [self notifyObservers:event];
                }
            }];
        }
    }
}

- (void)getContact:(UInt64)contactId handleSuccess:(contact_block_t)handleSuccess handleFailure:(cube_failure_block_t)handleFailure {
    if (![self.pipeline isReady]) {
        CContact * contact = [_storage readContact:contactId];
        if (contact) {
            handleSuccess(contact);
        }
        else {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:CSC_Contact_NotFindContact];
            handleFailure(error);
        }
        return;
    }

    // 从数据库读取
    CContact * contact = [_storage readContact:contactId];
    if (contact) {
        // 判断是否过期
        UInt64 now = [CUtils currentTimeMillis];
        if (now < contact.expiry) {
            // 没有过期
            handleSuccess(contact);
            return;
        }
    }

    NSMutableDictionary * packetData = [[NSMutableDictionary alloc] init];
    [packetData setValue:[NSNumber numberWithUnsignedLongLong:contactId] forKey:@"id"];
    [packetData setValue:self.kernel.authToken.domain forKey:@"domain"];

    CPacket * requestPacket = [[CPacket alloc] initWithName:CUBE_CONTACT_GETCONTACT andData:packetData];
    [self.pipeline send:CUBE_MODULE_CONTACT withPacket:requestPacket handleResponse:^(CPacket *packet) {
        if (packet.state.code != CSC_Ok) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:CSC_Contact_ServerError];
            handleFailure(error);
            return;
        }

        int stateCode = [packet extractStateCode];
        if (stateCode != CSC_Contact_Ok) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:stateCode];
            handleFailure(error);
            return;
        }

        CContact * contact = [[CContact alloc] initWithJSON:[packet extractData] domain:self.kernel.authToken.domain];

        // 写入数据库
        [self->_storage writeContact:contact];

        // 获取附录
        [self getAppendixWithContact:contact handleSuccess:^(CContact * contact, CContactAppendix * appendix) {
            handleSuccess(contact);
        } handleFailure:^(CError * error) {
            handleFailure(error);
        }];
    }];
}

- (void)getAppendixWithContact:(CContact *)contact handleSuccess:(void(^)(CContact *, CContactAppendix *))handleSuccess handleFailure:(cube_failure_block_t)handleFailure {
    NSNumber * contactId = [NSNumber numberWithUnsignedLongLong:contact.identity];
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:contactId, @"contactId", nil];
    CPacket * request = [[CPacket alloc] initWithName:CUBE_CONTACT_GETAPPENDIX andData:data];
    // 发送请求
    [self.pipeline send:CUBE_MODULE_CONTACT withPacket:request handleResponse:^(CPacket *packet) {
        if (packet.state.code != CSC_Ok) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:packet.state.code];
            handleFailure(error);
            return;
        }

        int stateCode = [packet extractStateCode];
        if (stateCode != CSC_Contact_Ok) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:stateCode];
            handleFailure(error);
            return;
        }

        CContactAppendix * appendix = [[CContactAppendix alloc] initWithService:self contact:contact json:[packet extractData]];

        // 更新存储
        [self->_storage writeContactAppendix:appendix];

        handleSuccess(contact, appendix);
    }];
}

- (void)getAppendixWithGroup:(CGroup *)group handleSuccess:(void(^)(CGroup *, CGroupAppendix *))handleSuccess handleFailure:(cube_failure_block_t)handleFailure {
    
}

- (void)listGroups:(UInt64)beginning ending:(UInt64)ending handler:(void (^)(NSArray *))handler {
    // TODO
    NSMutableArray * list = [[NSMutableArray alloc] init];
    handler(list);
}

#pragma mark - Private

- (void)waitReady:(void (^)(BOOL timeout))handler {
    --_waitReadyCount;
    if (_waitReadyCount <= 0) {
        handler(TRUE);
        _waitReadyCount = 0;
        return;
    }

    if (_selfReady) {
        handler(FALSE);
        _waitReadyCount = 0;
        return;
    }

    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC);
    dispatch_after(delayInNanoSeconds,
                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                ^(void) {
                    [self waitReady:handler];
                });
}

- (void)fireSignInCompleted {
    // 写入数据到存储
    [_storage writeContact:self.myself];

    _selfReady = TRUE;

    CObservableEvent * event = [[CObservableEvent alloc] initWithName:CContactEventSignIn data:self.myself];
    [self notifyObservers:event];
}

@end
