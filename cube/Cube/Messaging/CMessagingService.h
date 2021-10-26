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

#ifndef CMessagingService_h
#define CMessagingService_h

#import "CModule.h"
#import "CMessageState.h"
#import "CMessagingServiceState.h"

#ifndef CUBE_MODULE_MESSAGING
/*! @brief 模块名。 */
#define CUBE_MODULE_MESSAGING @"Messaging"
#endif

@class CContactService;
@class CMessagingService;
@class CMessagingPipelineListener;
@class CMessagingStorage;
@class CMessagingObserver;
@class CMessage;
@class CMessageDraft;
@class CContact;
@class CGroup;

/*!
 * @brief 消息模块事件的代理协议。
 */
@protocol CMessagingEventDelegate <NSObject>

@optional

/*!
 * @brief 消息正在发送。
 * @param message 消息实体。
 * @param service 消息服务。
 */
- (void)messageSending:(CMessage *)message service:(CMessagingService *)service;

/*!
 * @brief 消息已经发送。
 * @param message 消息实体。
 * @param service 消息服务。
 */
- (void)messageSent:(CMessage *)message service:(CMessagingService *)service;

/*!
 * @brief 接收到新消息。
 * @param message 消息实体。
 * @param service 消息服务。
 */
- (void)messageReceived:(CMessage *)message service:(CMessagingService *)service;

@end


/*!
 * @brief 最近的消息事件的代理协议。
 */
@protocol CMessagingRecentEventDelegate <NSObject>

@optional

/*!
 * @brief 当收到来自联系人的新消息或向指定联系人发送消息时回调该方法。
 * 当同时有多条消息时该方法仅通知该联系人的最近一条消息。
 * @param message 消息实体。
 * @param partner 该消息的联系人。
 * @param service 消息服务。
 */
- (void)newRecentMessage:(CMessage *)message partner:(CContact*)partner service:(CMessagingService *)service;

@end


/*!
 * @brief 消息模块。
 */
@interface CMessagingService : CModule {

@protected
    /*! 管道监听器。 */
    CMessagingPipelineListener * _pipelineListener;

    /*! 本地存储器。 */
    CMessagingStorage * _storage;
    
    /*! 其他模块的观察者。 */
    CMessagingObserver * _observer;
    
    /*! 服务是否就绪。 */
    BOOL _serviceReady;
    
    /*! 当前最近一条消息时间戳。 */
    UInt64 _lastMessageTime;

    NSTimer * _pullTimer;
}

/*! @brief 回溯时长，默认值：30个自然日。 */
@property (nonatomic, assign) UInt64 retrospectDuration;

/*! @brief 消息服务的事件代理。 */
@property (nonatomic, assign) id<CMessagingEventDelegate> eventDelegate;

/*! @brief 最近消息。 */
@property (nonatomic, assign) id<CMessagingRecentEventDelegate> recentEventDelegate;


/*!
 * @brief 初始化。
 */
- (instancetype)init;

/*!
 * @brief 消息是否是当前签入的联系人账号发出的。 即当前账号是否是指定消息的发件人。
 * @param message 指定消息实例。
 * @return 如果是当前签入人发出的返回 @c TRUE 。
 */
- (BOOL)isSender:(CMessage *)message;

/*!
 * @brief 向指定联系人发送消息。
 * @param conatct 指定联系人。
 * @param message 指定消息实例。
 * @return 如果消息被正确处理返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)sendToContact:(CContact *)conatct message:(CMessage *)message;

/*!
 * @brief 向指定联系人发送消息。
 * @param contactId 指定联系人 ID 。
 * @param message 指定消息实例。
 * @return 如果消息被正确处理返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)sendToContactWithId:(UInt64)contactId message:(CMessage *)message;

/*!
 * @brief 获取最近的消息清单，返回的每条消息都来自不同的会话联系人或群组。
 * @return 返回消息列表。如果返回 @c nil 值表示消息服务模块未启动。
 */
- (NSArray<__kindof CMessage *> *)getRecentMessages;

/*!
 * @brief 查询指定联系人与当前账号相关的所有消息。
 * @param contact 指定联系人。
 * @param beginning 指定查询的起始时间。
 * @param limit 指定查询的最大记录数。
 * @param completion 指定查询结果回调，数组里的消息是按照时间正序排序，即时间戳从小到大排序。
 */
- (void)queryMessagesWithContact:(CContact *)contact
                       beginning:(UInt64)beginning
                           limit:(NSInteger)limit
                      completion:(void (^)(NSArray <__kindof CMessage *> * array, BOOL hasMore))completion;

/*!
 * @brief 统计与指定消息相关的联系人的未读消息数量。
 * @return 返回未读消息数量。
 */
- (NSUInteger)countUnreadByMessage:(CMessage *)message;

/*!
 * @brief 将与指定联系人相关的消息标记为已读。
 * @param contact 指定联系人。
 * @param handleSuccess 操作成功回调，参数： @c NSArray 操作成功的消息的 ID 列表。
 * @param handleFailure 操作失败回调。
 */
- (void)markReadByContact:(CContact *)contact handleSuccess:(CSuccessBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @brief 将指定消息标记为已读。
 * @param message 指定消息。
 * @param handleSuccess 操作成功回调，参数： @c CMessage 操作的消息。
 * @param handleFailure 操作失败回调。
 */
- (void)markReadWithMessage:(CMessage *)message handleSuccess:(CSuccessBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @brief 查询指定联系人相关的所有消息，即包括该联系人发送的消息，也包含该联系人接收的消息。
 * 从起始时间向前反向查询所有消息。
 * @param contact 指定联系人。
 * @param beginning 指定查询的起始时间。
 * @param limit 指定最大查询记录数量。
 * @param completion 指定查询结果回调，消息数组里的消息是按照时间正序排序，即时间戳从小到大排序。
 */
- (void)queryMessagesByReverseWithContact:(CContact *)contact
                                beginning:(UInt64)beginning
                                    limit:(NSInteger)limit
                               completion:(void (^)(NSArray <__kindof CMessage *> * array, BOOL hasMore))completion;

/*!
 * @brief 保存消息草稿。
 * @param draft 指定草稿。
 * @return 返回是否保存成功。
 */
- (BOOL)saveDraft:(CMessageDraft *)draft;

/*!
 * @brief 加载指定联系人的草稿。
 * @param contact 指定联系人。
 * @param handleSuccess 操作成功回调。
 * @param handleFailure 操作失败回调。
 */
- (void)loadDraftWithContact:(CContact *)contact handleSuccess:(CSuccessBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @brief 加载指定群组的草稿。
 * @param group 指定群组。
 * @param handleSuccess 操作成功回调。
 * @param handleFailure 操作失败回调。
 */
- (void)loadDraftWithGroup:(CGroup *)group handleSuccess:(CSuccessBlock)handleSuccess handleFailure:(CFailureBlock)handleFailure;

/*!
 * @brief 删除指定对应联系人的草稿。
 * @param contact 指定联系人。
 */
- (void)deleteDraftWithContact:(CContact *)contact;

/*!
 * @brief 删除指定的草稿。
 * @param draft 指定草稿。
 */
- (void)deleteDraft:(CMessageDraft *)draft;


/*!
 * @private
 * @brief 进行数据加载。
 */
- (void)prepare:(CContactService *)contactService completionHandler:(void(^)(void))completionHandler;

/*!
 * @private
 * @brief 从服务器上下载指定时间段内的数据，数据将直接写入本地存储。
 * @param beginning 指定获取消息的起始时间。
 * @param ending 指定获取消息的截止时间。
 * @param completionHandler 指定本次查询回调，该回调函数仅用于通知该次查询结束，不携带任何消息数据。
 */
- (void)queryRemoteMessageWithBeginning:(UInt64)beginning toEnding:(UInt64)ending completionHandler:(void(^)(void))completionHandler;

/*!
 * @private
 * @brief 触发拉取消息完成回调句柄。
 */
- (void)firePullCompletionHandler;

/*!
 * @private
 * @brief 填充消息内的实体数据实例。
 */
- (void)fillMessage:(CMessage *)message;

@end

#endif /* CMessagingService_h */
