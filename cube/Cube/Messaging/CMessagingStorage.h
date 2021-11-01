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

#ifndef CMessagingStorage_h
#define CMessagingStorage_h

#import "CMessage.h"
#import "CConversation.h"
#import "CMessageState.h"
#import "CMessageDraft.h"

@class CMessagingService;

@interface CMessagingStorage : NSObject

/*!
 * @brief 初始化存储器。
 */
- (instancetype)initWithService:(CMessagingService *)service;

/*!
 * @brief 开启存储器。
 * @param contactId 指定联系人 ID 。
 * @param domain 指定域。
 * @return 开启成功返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)open:(UInt64)contactId domain:(NSString *)domain;

/*!
 * @brief 关闭存储器。
 */
- (void)close;

/*!
 * @brief 查询最近的会话列表。
 * @param limit 指定最大查询数量。
 * @return 返回查询结构数组。
 */
- (NSArray<__kindof CConversation *> *)queryRecentConversations:(NSInteger)limit;

/*!
 * @brief 更新列表里的所有会话。
 * @param conversations 指定会话清单。
 */
- (void)updateConversations:(NSArray<__kindof CConversation *> *)conversations;

/*!
 * @brief 查询最近一条消息的时间戳。
 * @return 返回本地最近一条消息的时间戳。
 */
- (UInt64)queryLastMessageTime;

/*!
 * @brief 更新消息。该方法将同时更新消息表和最近消息表。
 * @param message 指定消息实体。
 * @return 如果更新的消息是已存在的返回 @c TRUE ，如果消息未找到，插入新数据时返回 @c FALSE 。
 */
- (BOOL)updateMessage:(CMessage *)message;

/*!
 * @brief 查询所有联系人和群组的最近一次消息记录。
 * @param limit 指定最大查询数量。
 * @return 返回查询结构数组。
 */
- (NSArray<__kindof CMessage *> *)queryRecentMessagesWithLimit:(NSInteger)limit;

/*!
 * @brief 计算消息发件人相关的未读消息数量。
 */
- (NSUInteger)countUnreadMessagesWithFrom:(UInt64)contactId;

/*!
 * @brief 计算消息收件人相关的未读消息数量。
 */
- (NSUInteger)countUnreadMessagesWithTo:(UInt64)contactId;

/*!
 * @brief 计算消息群组源相关的未读消息数量。
 */
- (NSUInteger)countUnreadMessagesWithSource:(UInt64)groupId;

/*!
 * @brief 将指定联系人相关的而消息更新为指定状态。
 * @param contactId 指定联系人 ID 。
 * @param state 指定状态。
 * @param completion 被变更的消息的 ID 列表。
 */
- (void)updateMessageStateWithContactId:(UInt64)contactId state:(CMessageState)state completion:(void (^)(NSArray<__kindof NSNumber *> * list))completion;

/*!
 * @brief 更新消息状态。
 * @param messageId 消息 ID 。
 * @param state 消息状态。
 * @param completion 操作完成的回调。
 */
- (void)updateMessageState:(UInt64)messageId state:(CMessageState)state completion:(void (^)(void))completion;

/*!
 * @brief 更新消息在服务器上的状态。
 */
- (void)updateMessagesRemoteState:(NSArray<__kindof NSNumber *> *)messageIdList state:(CMessageState)state completion:(void (^)(void))completion;

/*!
 * @brief 更新消息在服务器上的状态。
 */
- (void)updateMessageRemoteState:(UInt64)messageId state:(CMessageState)state completion:(void (^)(void))completion;

/*!
 * @brief 使用消息 ID 获取消息。
 */
- (CMessage *)readMessageWithId:(UInt64)messageId;

/*!
 * @brief 反向查询消息。
 */
- (void)queryMessagesByReverseWithContact:(UInt64)contactId
                                beginning:(UInt64)beginning
                                    limit:(NSInteger)limit
                               completion:(void (^)(NSArray <__kindof CMessage *> * array, BOOL hasMore))completion;

/*!
 * @brief 写入草稿。
 */
- (void)writeDraft:(CMessageDraft *)draft;

/*!
 * @brief 读取草稿。
 */
- (void)readDraft:(UInt64)ownerId completion:(void(^)(CMessageDraft * draft))completion;

/*!
 * @brief 删除草稿。
 */
- (void)deleteDraft:(UInt64)ownerId;

@end

#endif /* CMessagingStorage_h */
