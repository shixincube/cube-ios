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
#import "CKernel.h"
#import "CUtils.h"
#import "CError.h"
#import "CObservableEvent.h"
#import "CMessagingPipelineListener.h"
#import "CMessagingStorage.h"
#import "CMessagingObserver.h"
#import "CMessagingEvent.h"
#import "CMessagingAction.h"
#import "CContactEvent.h"
#import "CPluginSystem.h"
#import "CInstantiateHook.h"
#import "CMessageTypePlugin.h"
#import "CContact.h"
#import "CGroup.h"
#import "CSelf.h"

typedef void (^PullCompletedHandler)(void);

@interface CMessagingService () {

    CContactService * _contactService;
    
    NSMutableDictionary * _sendingMap;
}

@property (nonatomic, copy) PullCompletedHandler pullCompletedHandler;

- (void)assemble;

- (void)processSend:(CMessage *)message;

- (void)processPushResult:(CMessage *)message responsePacket:(CPacket *)responsePacket;

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

        _eventDelegate = nil;

        _sendingMap = [[NSMutableDictionary alloc] init];
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

    _eventDelegate = nil;
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

- (BOOL)sendToContact:(CContact *)conatct message:(CMessage *)message {
    return [self sendToContactWithId:conatct.identity message:message];
}

- (BOOL)sendToContactWithId:(UInt64)contactId message:(CMessage *)message {
    if (![self hasStarted]) {
        [self start];
    }

    CSelf * owner = _contactService.owner;

    // 更新消息状态
    message.state = CMessageStateSending;
    
    // 更新数据
    [message bind:owner.identity to:contactId source:0];

    UInt64 now = [CUtils currentTimeMillis];
    [message assignTS:now remoteTS:now];
    
    [self fillMessage:message];

    // 写入数据库
    [_storage updateMessage:message];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        [self processSend:message];
    });

    return TRUE;
}

#pragma mark - Private

- (void)assemble {
    [self.pluginSystem addHook:[[CInstantiateHook alloc] init]];

    // 注册插件
    [self.pluginSystem registerPlugin:CInstantiateHookName plugin:[[CMessageTypePlugin alloc] init]];
}

- (void)processSend:(CMessage *)message {
    [_sendingMap setValue:message forKey:[NSString stringWithFormat:@"%llu", message.identity]];
    
    if (![self.pipeline isReady]) {
        return;
    }

    // TODO 处理文件附件
    
    // 事件通知
    if (0 == [message getScope]) {
        CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventSending data:message];
        [self notifyObservers:event];
    }
    
    // 发送到服务器
    CPacket * packet = [[CPacket alloc] initWithName:CUBE_MESSAGING_PUSH andData:[message toJSON]];
    [self.pipeline send:CUBE_MODULE_MESSAGING withPacket:packet handleResponse:^(CPacket * responsePacket) {
        [self processPushResult:message responsePacket:responsePacket];
    }];
}

- (void)processPushResult:(CMessage *)message responsePacket:(CPacket *)responsePacket {
    if (responsePacket.state.code != CSC_Ok) {
        NSLog(@"CMessagingService pipeline error : %d", responsePacket.state.code);
        
        [_sendingMap removeObjectForKey:[NSString stringWithFormat:@"%llu", message.identity]];
        
        message.state = CMessageStateFault;
        
        // 更新消息状态
        [_storage updateMessage:message];
        
        // 事件回调
        CError * error = [CError errorWithModule:CUBE_MODULE_MESSAGING code:CMessagingServiceStateServerFault];
        CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventFault data:error];
        [self notifyObservers:event];

        return;
    }

    int stateCode = [responsePacket extractStateCode];
    NSDictionary * data = [responsePacket extractData];
    
    // 移除正在发送数据
    [_sendingMap removeObjectForKey:[NSString stringWithFormat:@"%llu", message.identity]];

    // 提取应答的数据
    UInt64 responseRTS = [[data valueForKey:@"rts"] unsignedLongLongValue];
    int responseState = [[data valueForKey:@"state"] intValue];

    // 更新时间戳
    [message assignTS:message.localTS remoteTS:responseRTS];

    // 更新状态
    message.state = responseState;

    if (message.remoteTS > _lastMessageTime) {
        _lastMessageTime = message.remoteTS;
    }

    // 更新数据库
    [_storage updateMessage:message];
    
    if (stateCode == CMessagingServiceStateOk) {
        // TODO 更新附件

        if ([message getScope] == 0) {
            CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventSent data:message];
            [self notifyObservers:event];
        }
        else {
            CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventMarkOnlyOwner data:message];
            [self notifyObservers:event];
        }
    }
    else if (stateCode == CMessagingServiceStateBeBlocked) {
        if (message.state == CMessageStateSendBlocked) {
            CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventSendBlocked data:message];
            [self notifyObservers:event];
        }
        else if (message.state == CMessageStateReceiveBlocked) {
            CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventReceiveBlocked data:message];
            [self notifyObservers:event];
        }
        else {
            CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventFault data:message];
            [self notifyObservers:event];
        }
    }
    else {
        NSLog(@"CMessagingService send failed: %d", stateCode);

        CError * error = [CError errorWithModule:CUBE_MODULE_MESSAGING code:stateCode];
        CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventFault data:error];
        [self notifyObservers:event];
    }
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
    [self queryRemoteMessage:(_lastMessageTime + 1) ending:now completedHandler:^ {
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

#pragma mark - Events

- (void)notifyObservers:(CObservableEvent *)event {
    [super notifyObservers:event];

    if (self.eventDelegate) {
        if ([event.name isEqualToString:CMessagingEventNotify]) {
            if ([self.eventDelegate respondsToSelector:@selector(messageReceived:service:)]) {
                [self.eventDelegate messageReceived:(CMessage *)event.data service:self];
            }
        }
        else if ([event.name isEqualToString:CMessagingEventSending]) {
            if ([self.eventDelegate respondsToSelector:@selector(messageSending:service:)]) {
                [self.eventDelegate messageSending:(CMessage *)event.data service:self];
            }
        }
        else if ([event.name isEqualToString:CMessagingEventSent]) {
            if ([self.eventDelegate respondsToSelector:@selector(messageSent:service:)]) {
                [self.eventDelegate messageSent:(CMessage *)event.data service:self];
            }
        }
    }
}

@end
