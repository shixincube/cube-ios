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

#ifndef CMessagingStorage_h
#define CMessagingStorage_h

#import "CMessage.h"

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
 * @brief 使用消息 ID 获取消息。
 */
- (CMessage *)readMessageWithId:(UInt64)messageId;

@end

#endif /* CMessagingStorage_h */
