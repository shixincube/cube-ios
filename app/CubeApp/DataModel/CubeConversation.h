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

#ifndef CubeConversation_h
#define CubeConversation_h

#import <Foundation/Foundation.h>

/*!
 * @brief 会话描述。
 */
@interface CubeConversation : NSObject

/*!
 * @brief 主会话实例。
 */
@property (nonatomic, strong, readonly) CConversation * conversation;

/*!
 * @brief 头像图片名称。
 */
@property (nonatomic, strong) NSString * avatarName;

/*!
 * @brief 头像图片 URL 。
 */
@property (nonatomic, strong) NSString * avatarURL;

/*!
 * @brief 未读数量。
 */
@property (nonatomic, assign, readonly) NSInteger unread;

/*!
 * @brief 气泡显示的数据。
 */
@property (nonatomic, strong, readonly) NSString * badgeValue;


/*!
 * @brief 是否已读消息。
 */
- (BOOL)isRead;

- (void)clearUnread;

- (void)reset:(CConversation *)conversation;

+ (CubeConversation *)conversationWithConversation:(CConversation *)conversation;

@end

#endif /* CubeConversation_h */
