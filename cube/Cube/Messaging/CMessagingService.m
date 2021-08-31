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

#import "CMessagingService.h"
#import "CMessagingPipelineListener.h"
#import "CMessagingStorage.h"
#import "CMessagingObserver.h"
#import "CMessagingEvent.h"
#import "CMessagingAction.h"
#import "CContactEvent.h"
#import "CPluginSystem.h"
#import "CInstantiateHook.h"
#import "CMessageTypePlugin.h"
#import "CKernel.h"
#import "CUtils.h"

typedef void (^PullCompletedHandler)(void);

@interface CMessagingService () {

    CContactService * _contactService;
}

@property (nonatomic, copy) PullCompletedHandler pullCompletedHandler;

- (void)assemble;

@end

@implementation CMessagingService

- (instancetype)init {
    if (self = [super initWithName:CUBE_MODULE_MESSAGING]) {
        _pipelineListener = [[CMessagingPipelineListener alloc] initWithService:self];
        _storage = [[CMessagingStorage alloc] initWithService:self];
        _observer = [[CMessagingObserver alloc] initWithService:self];
        _serviceReady = FALSE;

        self.defaultRetrospect = 14 * 24 * 60 * 60000L;
        
        _pullTimer = nil;

        _notifyDelegate = nil;
    }

    return self;
}

- (BOOL)start {
    if (![super start]) {
        return FALSE;
    }
    
    // 组装插件
    [self assemble];

    [self.pipeline addListener:CUBE_MODULE_MESSAGING listener:_pipelineListener];

    // 监听联系人模块
    _contactService = (CContactService *) [self.kernel getModule:CUBE_MODULE_CONTACT];
    [_contactService attachWithName:CContactEventSignIn observer:_observer];
    [_contactService attachWithName:CContactEventSignOut observer:_observer];

    @synchronized (self) {
        if (_contactService.owner && !_serviceReady) {
            [self prepare:_contactService completedHandler:^ {
                self->_serviceReady = TRUE;

                CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventReady data:self];
                [self notifyObservers:event];
            }];
        }
    }

    return TRUE;
}

- (void)stop {
    [super stop];

    CContactService * contactService = (CContactService *) [self.kernel getModule:CUBE_MODULE_CONTACT];
    [contactService detachWithName:CContactEventSignIn observer:_observer];
    [contactService detachWithName:CContactEventSignOut observer:_observer];

    [self.pipeline removeListener:CUBE_MODULE_MESSAGING listener:_pipelineListener];

    // 关闭存储
    [_storage close];

    [self.pluginSystem clearHooks];
    [self.pluginSystem clearPlugins];

    _serviceReady = FALSE;

    _notifyDelegate = nil;
}

- (void)suspend {
    [super suspend];
}

- (void)resume {
    [super resume];
}

- (BOOL)isReady {
    return _serviceReady;
}

- (BOOL)isSender:(CMessage *)message {
    CSelf * owner = _contactService.owner;
    if (nil == owner) {
        return FALSE;
    }

    return (message.from == owner.identity);
}

#pragma mark - Private

- (void)assemble {
    [self.pluginSystem addHook:[[CInstantiateHook alloc] init]];

    // 注册插件
    [self.pluginSystem registerPlugin:CInstantiateHookName plugin:[[CMessageTypePlugin alloc] init]];
}

- (void)prepare:(CContactService *)contactService completedHandler:(void(^)(void))completedHandler {
    CSelf * owner = contactService.owner;
    // 开启存储器
    [_storage open:owner.identity domain:owner.domain];

    UInt64 now = [CUtils currentTimeMillis];

    // 查询本地最近消息时间
    UInt64 time = [_storage queryLastMessageTime];
    if (0 == time) {
        _lastMessageTime = now - self.defaultRetrospect;
    }
    else {
        _lastMessageTime = time;
    }

    // 从服务器上拉取自上一次时间戳之后的所有消息
    [self queryRemoteMessage:_lastMessageTime ending:now completedHandler:^ {
        completedHandler();
    }];
}

- (void)queryRemoteMessage:(UInt64)beginning ending:(UInt64)ending completedHandler:(void (^)(void))completedHandler {
    // 如果没有网络直接回调函数
    if (![self.pipeline isReady]) {
        completedHandler();
        return;
    }

    if (nil != _pullTimer) {
        return;
    }

    _pullTimer = [NSTimer scheduledTimerWithTimeInterval:10 repeats:NO block:^(NSTimer * _Nonnull timer) {
        self->_pullTimer = nil;
        completedHandler();
    }];

    self.pullCompletedHandler = completedHandler;

    CSelf * owner = _contactService.owner;

    NSMutableDictionary * payload = [[NSMutableDictionary alloc] init];
    [payload setValue:[NSNumber numberWithUnsignedLongLong:owner.identity] forKey:@"id"];
    [payload setValue:owner.domain forKey:@"domain"];
    [payload setValue:[owner.device toJSON] forKey:@"device"];
    [payload setValue:[NSNumber numberWithUnsignedLongLong:beginning] forKey:@"beginning"];
    [payload setValue:[NSNumber numberWithUnsignedLongLong:ending] forKey:@"ending"];

    CPacket * packet = [[CPacket alloc] initWithName:CUBE_MESSAGING_PULL andData:payload];

    // 发送请求到服务器
    [self.pipeline send:CUBE_MODULE_MESSAGING withPacket:packet];
}

- (void)firePullCompletedHandler {
    _pullCompletedHandler();
}

- (void)fillMessage:(CMessage *)message {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();

    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        [self->_contactService getContact:message.from handleSuccess:^(CContact *contact) {
            // 发件人赋值
            [message assignSender:contact];
            dispatch_group_leave(group);
        } handleFailure:^(CError * _Nonnull error) {
            dispatch_group_leave(group);
        }];
    });

    dispatch_group_enter(group);
    dispatch_async(queue, ^{
        if (message.source > 0) {
            // TODO
            dispatch_group_leave(group);
        }
        else {
            [self->_contactService getContact:message.to handleSuccess:^(CContact *contact) {
                // 收件人赋值
                [message assignReceiver:contact];
                dispatch_group_leave(group);
            } handleFailure:^(CError * _Nonnull error) {
                dispatch_group_leave(group);
            }];
        }
    });

    dispatch_group_notify(group, queue, ^{
        // Nothing
    });
    
    // 阻塞线程
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}

@end
