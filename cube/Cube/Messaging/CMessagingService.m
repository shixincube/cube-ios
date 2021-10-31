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

#import "CMessagingService.h"
#import "CKernel.h"
#import "CUtils.h"
#import "CError.h"
#import "CObservableEvent.h"
#import "CContactService.h"
#import "CContactEvent.h"
#import "CContact.h"
#import "CGroup.h"
#import "CSelf.h"
#import "CDevice.h"
#import "CMessage.h"
#import "CMessagingPipelineListener.h"
#import "CMessagingStorage.h"
#import "CMessagingObserver.h"
#import "CMessagingEvent.h"
#import "CMessagingAction.h"
#import "CConversation.h"
#import "CPluginSystem.h"
#import "CInstantiateHook.h"
#import "CMessageTypePlugin.h"
#import "CEventJitter.h"
#import "CMessageDraft.h"


typedef void (^PullCompletionHandler)(void);

const static char * kMSQueueLabel = "CubeMessagingTQ";


@interface CMessagingService () {

    CContactService * _contactService;

    NSMutableArray<__kindof CConversation *> * _conversations;

    NSMutableDictionary * _sendingMap;

    dispatch_queue_t _threadQueue;

    // 用于抑制 Notify 事件回调时的控制线程
    NSThread * _jitterThread;
    NSMutableDictionary <__kindof NSString *, __kindof CEventJitter * > * _jitterMap;
}

@property (nonatomic, copy) PullCompletionHandler pullCompletionHandler;

- (void)assemble;

- (void)dissolve;

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

        self.retrospectDuration = 30L * 24L * 60L * 60000L;

        _pullTimer = nil;

        _eventDelegate = nil;

        _sendingMap = [[NSMutableDictionary alloc] init];
        _jitterMap = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)dealloc {
    [_jitterMap removeAllObjects];
}

- (BOOL)start {
    if (![super start]) {
        return FALSE;
    }

    // 创建线程队列
    _threadQueue = dispatch_queue_create(kMSQueueLabel, DISPATCH_QUEUE_CONCURRENT);

    // 组装插件
    [self assemble];

    [self.pipeline addListener:_pipelineListener withDestination:CUBE_MODULE_MESSAGING];

    // 监听联系人模块
    _contactService = (CContactService *) [self.kernel getModule:CUBE_MODULE_CONTACT];
    [_contactService attachWithName:CContactEventSelfReady observer:_observer];
    [_contactService attachWithName:CContactEventSignIn observer:_observer];
    [_contactService attachWithName:CContactEventSignOut observer:_observer];

    @synchronized (self) {
        if (_contactService.owner && !_serviceReady) {
            [self prepare:_contactService completionHandler:^ {
                CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventReady data:self];
                [self notifyObservers:event];
            }];
        }
    }

    return TRUE;
}

- (void)stop {
    [super stop];

    // 拆除插件
    [self dissolve];

    CContactService * contactService = (CContactService *) [self.kernel getModule:CUBE_MODULE_CONTACT];
    [contactService detachWithName:CContactEventSelfReady observer:_observer];
    [contactService detachWithName:CContactEventSignIn observer:_observer];
    [contactService detachWithName:CContactEventSignOut observer:_observer];

    [self.pipeline removeListener:_pipelineListener withDestination:CUBE_MODULE_MESSAGING];

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
    return _serviceReady && [self.pipeline isReady];
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
    // 更新 Typer
    message.selfTyper = TRUE;

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

- (NSArray<__kindof CConversation *> *)getRecentConversations {
    if (![self hasStarted]) {
        return nil;
    }

    @synchronized (self) {
        if (nil == _conversations || _conversations.count == 0) {
            NSArray<__kindof CConversation *> * list = [_storage queryRecentConversations:50];
            NSArray<__kindof CConversation *> * sortedList = [self sortConversationList:list];

            if (nil == _conversations) {
                _conversations = [[NSMutableArray alloc] initWithArray:sortedList];
            }
            else {
                [_conversations addObjectsFromArray:sortedList];
            }
        }
    }

    return _conversations;
}

- (NSArray<__kindof CMessage *> *)getRecentMessages {
    if (![self hasStarted]) {
        return nil;
    }

    NSArray<__kindof CMessage *> * list = [_storage queryRecentMessagesWithLimit:50];
    if (list.count == 0) {
        return list;
    }

    // 调用插件
    CHook * hook = [self.pluginSystem getHook:CInstantiateHookName];

    NSMutableArray<__kindof CMessage *> * result = [[NSMutableArray alloc] initWithCapacity:list.count];
    for (CMessage * message in list) {
        CMessage * compMessage = [hook apply:message];
        [result addObject:compMessage];
    }

    return result;
}

- (void)queryMessages:(CConversation *)conversation
            beginning:(UInt64)beginning
                limit:(NSInteger)limit
           completion:(void (^)(NSArray <__kindof CMessage *> * array, BOOL hasMore))completion {
    if (conversation.contact) {
        [self queryMessagesByReverseWithContact:conversation.contact beginning:beginning limit:limit completion:completion];
    }
    else if (conversation.group) {
        
    }
}

- (void)markReadByContact:(CContact *)contact handleSuccess:(CSuccessBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure {
    if (![self hasStarted]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            CError * error = [CError errorWithModule:CUBE_MODULE_MESSAGING code:CMessagingServiceStateIllegalOperation];
            handleFailure(error);
        });
        return;
    }

    [_storage updateMessageStateWithContactId:contact.identity state:CMessageStateRead completion:^(NSArray<__kindof NSNumber *> *list) {
        // 同步到服务器
        NSDictionary * payload = @{
            @"contactId": [NSNumber numberWithUnsignedLongLong:self->_contactService.owner.identity],
            @"messageIdList": list,
            @"messageFrom": [NSNumber numberWithUnsignedLongLong:contact.identity]
        };
        CPacket * packet = [[CPacket alloc] initWithName:CUBE_MESSAGING_READ andData:payload];
        [self.pipeline send:CUBE_MODULE_MESSAGING withPacket:packet handleResponse:^(CPacket *packet) {
            if (packet.state.code != CStateOk) {
                CError * error = [CError errorWithModule:CUBE_MODULE_MESSAGING code:packet.state.code];
                handleFailure(error);
                return;
            }

            int state = [packet extractStateCode];
            if (state != CMessagingServiceStateOk) {
                CError * error = [CError errorWithModule:CUBE_MODULE_MESSAGING code:state];
                handleFailure(error);
                return;
            }

            NSDictionary * data = [packet extractData];
            NSArray * messageIdList = [data valueForKey:@"messageIdList"];
            [self->_storage updateMessagesRemoteState:messageIdList state:CMessageStateRead completion:^{
                handleSuccess(list);
            }];
        }];
    }];
}

- (void)markReadWithMessage:(CMessage *)message handleSuccess:(CSuccessBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure {
    if (![self hasStarted]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            CError * error = [CError errorWithModule:CUBE_MODULE_MESSAGING code:CMessagingServiceStateIllegalOperation];
            handleFailure(error);
        });
        return;
    }

    [_storage updateMessageState:message.identity state:CMessageStateRead completion:^{
        // 同步到服务器
        NSDictionary * payload = @{
            @"contactId": [NSNumber numberWithUnsignedLongLong:self->_contactService.owner.identity],
            @"messageId": [NSNumber numberWithUnsignedLongLong:message.identity],
        };
        CPacket * packet = [[CPacket alloc] initWithName:CUBE_MESSAGING_READ andData:payload];
        [self.pipeline send:CUBE_MODULE_MESSAGING withPacket:packet handleResponse:^(CPacket *packet) {
            if (packet.state.code != CStateOk) {
                CError * error = [CError errorWithModule:CUBE_MODULE_MESSAGING code:packet.state.code];
                handleFailure(error);
                return;
            }

            int state = [packet extractStateCode];
            if (state != CMessagingServiceStateOk) {
                CError * error = [CError errorWithModule:CUBE_MODULE_MESSAGING code:state];
                handleFailure(error);
                return;
            }

            [self->_storage updateMessageRemoteState:message.identity state:CMessageStateRead completion:^{
                handleSuccess(message);
            }];
        }];
    }];
}

- (void)queryMessagesByReverseWithContact:(CContact *)contact
                                beginning:(UInt64)beginning
                                    limit:(NSInteger)limit
                               completion:(void (^)(NSArray <__kindof CMessage *> * array, BOOL hasMore))completion {
    if (![self hasStarted]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            completion(nil, FALSE);
        });
        return;
    }

    [_storage queryReverseWithContact:contact.identity beginning:beginning limit:limit completion:^(NSArray<__kindof CMessage *> *array, BOOL hasMore) {
        if (array.count == 0) {
            completion(array, hasMore);
            return;
        }

        // 调取钩子
        CHook * hook = [self.pluginSystem getHook:CInstantiateHookName];

        NSMutableArray<__kindof CMessage *> * result = [[NSMutableArray alloc] initWithCapacity:array.count];
        for (CMessage * message in array) {
            CMessage * compMessage = [hook apply:message];
            [result addObject:compMessage];
        }

        // 从数据库里查出来的是时间倒序，从大到小
        // 这里对数组进行翻转，翻转为时间正序
        completion(result.reverseObjectEnumerator.allObjects, hasMore);
    }];
}

#pragma mark - Message Draft

- (BOOL)saveDraft:(CMessageDraft *)draft {
    if (![self hasStarted]) {
        return FALSE;
    }

    [_storage writeDraft:draft];
    return TRUE;
}

- (void)loadDraftWithContact:(CContact *)contact handleSuccess:(CSuccessBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure {
    if (![self hasStarted]) {
        CError * error = [CError errorWithModule:CUBE_MODULE_MESSAGING code:CMessagingServiceStateIllegalOperation];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            handleFailure(error);
        });
        return;
    }

    [_storage readDraft:contact.identity completion:^(CMessageDraft *draft) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (nil == draft) {
                CError * error = [CError errorWithModule:CUBE_MODULE_MESSAGING code:CMessagingServiceStateStorageNoData];
                handleFailure(error);
                return;
            }

            CHook * hook = [self.pluginSystem getHook:CInstantiateHookName];
            CMessage * compMessage = [hook apply:draft.message];
            draft.message = compMessage;
            handleSuccess(draft);
        });
    }];
}

- (void)loadDraftWithGroup:(CGroup *)group handleSuccess:(CSuccessBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure {
    // TODO
}

- (void)deleteDraftWithContact:(CContact *)contact {
    if (![self hasStarted]) {
        return;
    }

    [_storage deleteDraft:contact.identity];
}

- (void)deleteDraft:(CMessageDraft *)draft {
    if (![self hasStarted]) {
        return;
    }

    [_storage deleteDraft:draft.ownerId];
}

#pragma mark - Private

- (void)assemble {
    [self.pluginSystem addHook:[[CInstantiateHook alloc] init]];

    // 注册插件
    [self.pluginSystem registerPlugin:CInstantiateHookName plugin:[[CMessageTypePlugin alloc] init]];
}

- (void)dissolve {
    [self.pluginSystem clearHooks];
    [self.pluginSystem clearPlugins];
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
    if (responsePacket.state.code != CStateOk) {
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

- (void)prepare:(CContactService *)contactService completionHandler:(void(^)(void))completionHandler {
    CSelf * owner = contactService.owner;
    // 开启存储器
    [_storage open:owner.identity domain:owner.domain];

    UInt64 now = [CUtils currentTimeMillis];

    // 查询本地最近消息时间
    UInt64 time = [_storage queryLastMessageTime];
    if (0 == time) {
        _lastMessageTime = now - self.retrospectDuration;
    }
    else {
        _lastMessageTime = time;
    }

    // 服务就绪
    _serviceReady = TRUE;

    __block BOOL gotMessages = FALSE;
    __block BOOL gotConversations = FALSE;

    // 从服务器上拉取自上一次时间戳之后的所有消息
    [self queryRemoteMessageWithBeginning:(_lastMessageTime + 1) toEnding:now completionHandler:^ {
        gotMessages = TRUE;
        if (gotConversations) {
            completionHandler();
        }
    }];

    // 获取最新的会话列表
    // 根据最近一次消息时间戳更新数量
    int limit = 50;
    if (now - _lastMessageTime > 1L * 60L * 60L * 1000L) {
        // 大于一小时
        limit = 200;
    }
    [self queryRemoteConversationsWithLimit:limit completionHandler:^{
        gotConversations = TRUE;
        if (gotMessages) {
            completionHandler();
        }
    }];
}

- (void)queryRemoteMessageWithBeginning:(UInt64)beginning toEnding:(UInt64)ending completionHandler:(void (^)(void))completionHandler {
    // 如果没有网络直接回调函数
    if (![self.pipeline isReady]) {
        completionHandler();
        return;
    }

    if (nil != _pullTimer) {
        return;
    }

    _pullTimer = [NSTimer scheduledTimerWithTimeInterval:10 repeats:NO block:^(NSTimer * _Nonnull timer) {
        self->_pullTimer = nil;
        completionHandler();
    }];

    _pullCompletionHandler = completionHandler;

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

- (void)firePullCompletionHandler {
    if (_pullCompletionHandler) {
        dispatch_async(_threadQueue, ^{
            self->_pullCompletionHandler();
            self->_pullCompletionHandler = nil;
        });
    }
}

- (void)queryRemoteConversationsWithLimit:(int)limit completionHandler:(void (^)(void))completionHandler {
    if (![self.pipeline isReady]) {
        completionHandler();
        return;
    }

    NSDictionary * payload = @{
        @"limit" : [NSNumber numberWithInt:limit]
    };
    CPacket * requestPacket = [[CPacket alloc] initWithName:CUBE_MESSAGING_GETCONVERSATIONS andData:payload];
    [self.pipeline send:CUBE_MODULE_MESSAGING withPacket:requestPacket handleResponse:^(CPacket *packet) {
        if (packet.state.code != CStateOk) {
            completionHandler();
            return;
        }

        int code = [packet extractStateCode];
        if (code != CMessagingServiceStateOk) {
            completionHandler();
            return;
        }

        NSMutableArray<__kindof CConversation *> * conversationList = [[NSMutableArray alloc] init];
        // 读取列表
        NSDictionary * data = [packet extractData];
        NSArray * list = [data valueForKey:@"list"];
        for (NSDictionary * json in list) {
            CConversation * conversation = [[CConversation alloc] initWithJSON:json];
            // 填充实体
            [self fillConversation:conversation];
            [conversationList addObject:conversation];
        }

        dispatch_queue_t queue = dispatch_queue_create("cube.messaging.conversation", DISPATCH_QUEUE_CONCURRENT);
        dispatch_async(queue, ^{
            // 更新到数据库
            [self->_storage updateConversations:conversationList];

            // 回调
            completionHandler();

            // 回调事件
            if (self->_recentEventDelegate && [self->_recentEventDelegate respondsToSelector:@selector(conversationListUpdated:service:)]) {

                @synchronized (self) {
                    if (nil != self->_conversations) {
                        [self->_conversations removeAllObjects];
                    }
                }

                [self->_recentEventDelegate conversationListUpdated:[self getRecentConversations]
                                                            service:self];
            }
        });
    }];
}

#pragma mark - Fill Message

- (void)fillMessage:(CMessage *)message {
    CSelf * owner = _contactService.owner;
    message.selfTyper = (message.from == owner.identity);

    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    __block BOOL gotFrom = FALSE;
    __block BOOL gotToOrSource = FALSE;

    void (^process)(CError * error) = ^(CError * error) {
        if (error) {
            NSLog(@"CMessageService#fillMessage '%@' : %ld", error.module, error.code);
        }

        if (gotFrom && gotToOrSource) {
            dispatch_semaphore_signal(semaphore);
        }
    };

    dispatch_async(_threadQueue, ^{
        [self->_contactService getContact:message.from handleSuccess:^(CContact *contact) {
            // 发件人赋值
            [message assignSender:contact];
            gotFrom = TRUE;
            process(nil);
        } handleFailure:^(CError * _Nonnull error) {
            gotFrom = TRUE;
            process(error);
        }];
    });

    dispatch_async(_threadQueue, ^{
        if (message.source > 0) {
            // TODO
            gotToOrSource = TRUE;
            process(nil);
        }
        else {
            [self->_contactService getContact:message.to handleSuccess:^(CContact *contact) {
                // 收件人赋值
                [message assignReceiver:contact];
                gotToOrSource = TRUE;
                process(nil);
            } handleFailure:^(CError * _Nonnull error) {
                gotToOrSource = TRUE;
                process(error);
            }];
        }
    });

    if (gotFrom && gotToOrSource) {
        return;
    }

    // 阻塞线程
    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 3000 * NSEC_PER_MSEC);
    dispatch_semaphore_wait(semaphore, timeout);
}

#pragma mark - Fill Conversation

- (void)fillConversation:(CConversation *)conversation {
    // 填充消息
    [self fillMessage:conversation.recentMessage];

    // 按类型实例化
    if (conversation.recentMessage.type == CMessageTypeUnknown) {
        CHook * hook = [self.pluginSystem getHook:CInstantiateHookName];
        CMessage * compMessage = [hook apply:conversation.recentMessage];
        [conversation resetRecentMessage:compMessage];
    }

    if (conversation.type == CConversationTypeContact) {
        __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        [_contactService getContact:conversation.pivotalId handleSuccess:^(CContact *contact) {
            [conversation setPivotalWithContact:contact];
            dispatch_semaphore_signal(semaphore);
        } handleFailure:^(CError * _Nullable error) {
            // Nothing
            dispatch_semaphore_signal(semaphore);
        }];

        dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 2000 * NSEC_PER_MSEC);
        dispatch_semaphore_wait(semaphore, timeout);
    }
    else if (conversation.type == CConversationTypeGroup) {
        __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

        [_contactService getGroup:conversation.pivotalId handleSuccess:^(CGroup *group) {
            [conversation setPivotalWithGroup:group];
            dispatch_semaphore_signal(semaphore);
        } handleFailure:^(CError * _Nullable error) {
            // Nothing
            dispatch_semaphore_signal(semaphore);
        }];

        dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 2000 * NSEC_PER_MSEC);
        dispatch_semaphore_wait(semaphore, timeout);
    }
}

- (CConversation *)findConversation:(CMessage *)message {
    if (nil == _conversations) {
        return nil;
    }

    NSInteger type = [message isFromGroup] ? CConversationTypeGroup : CConversationTypeContact;
    UInt64 pivotalId = [message isFromGroup] ? message.source : message.partner.identity;
    for (CConversation * conv in _conversations) {
        if (type == conv.type && pivotalId == conv.pivotalId) {
            return conv;
        }
    }

    return nil;
}

- (NSArray<__kindof CConversation *> *)sortConversationList:(NSArray<__kindof CConversation *> *)list {
    return [list sortedArrayUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
        CConversation * conv1 = obj1;
        CConversation * conv2 = obj2;

        // 将 Important 置顶
        if (conv1.type == CConversationStateNormal && conv2.type == CConversationStateImportant) {
            return NSOrderedDescending;
        }
        else if (conv1.type == CConversationStateImportant && conv2.type == CConversationStateNormal) {
            return NSOrderedAscending;
        }
        else {
            if (conv1.timestamp < conv2.timestamp) {
                return NSOrderedDescending;
            }
            else if (conv1.timestamp > conv2.timestamp) {
                return NSOrderedAscending;
            }

            return NSOrderedSame;
        }
    }];
}

- (void)jitterThreadTask {
    UInt64 now = [CUtils currentTimeMillis];

    while (_jitterMap.count > 0) {
        [NSThread sleepForTimeInterval:0.25];

        now += 250;

        NSArray * list = _jitterMap.allValues;
        for (CEventJitter * jitter in list) {
            if (now - jitter.timestamp >= 500) {
                NSString * key = jitter.mapKey;
                if (key) {
                    [_jitterMap removeObjectForKey:key];
                }

                CMessage * message = (CMessage *) jitter.event.data;
                CConversation * conversation = [self findConversation:message];
                if (conversation) {
                    [conversation resetRecentMessage:message];
                    [self.recentEventDelegate conversationUpdated:conversation service:self];
                }
                else {
                    // 创建新的会话
                    // TODO
                }
            }
        }
    }
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

    if (self.recentEventDelegate) {
        if ([event.name isEqualToString:CMessagingEventNotify]
            || [event.name isEqualToString:CMessagingEventSent]) {
            if ([self.recentEventDelegate respondsToSelector:@selector(conversationUpdated:service:)]) {
                CMessage * message = (CMessage *) event.data;
                CEventJitter * jitter = nil;

                if ([message isFromGroup]) {
                    // TODO
                }
                else {
                    NSString * contactId = nil;
                    if (!message.selfTyper) {
                        contactId = [NSString stringWithFormat:@"%llu", message.from];
                        jitter = [_jitterMap valueForKey:contactId];
                    }
                    else {
                        contactId = [NSString stringWithFormat:@"%llu", message.to];
                        jitter = [_jitterMap valueForKey:contactId];
                    }

                    UInt64 time = [CUtils currentTimeMillis];
                    if (nil == jitter) {
                        jitter = [[CEventJitter alloc] initWithTimestamp:time event:event];
                        jitter.contact = message.partner;
                        [_jitterMap setValue:jitter forKey:contactId];
                    }
                    else {
                        jitter.timestamp = time;
                        jitter.event = event;
                    }
                }

                if (nil == _jitterThread || [_jitterThread isFinished]) {
                    _jitterThread = [[NSThread alloc] initWithTarget:self selector:@selector(jitterThreadTask) object:nil];
                    [_jitterThread start];
                }
            }
        }
    }
}

@end
