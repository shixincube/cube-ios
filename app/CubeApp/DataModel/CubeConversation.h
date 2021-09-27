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

#ifndef CubeConversation_h
#define CubeConversation_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CubeConversationType) {
    CubeConversationTypeContact,        // 联系人的消息
    CubeConversationTypeGroup,          // 群组的消息
    CubeConversationTypeOrganization,   // 企业及组织消息
    CubeConversationTypeNotifier        // 通知
};

typedef NS_ENUM(NSInteger, CubeMessageRemindType) {
    CubeMessageRemindTypeNormal,        // 正常接受
    CubeMessageRemindTypeClosed,        // 不提示
    CubeMessageRemindTypeNotCare,       // 不看
    CubeMessageRemindTypeUnlike         // 不喜欢
};


/*!
 * @brief 会话描述。
 */
@interface CubeConversation : NSObject

/*!
 * @brief 会话类型。
 */
@property (nonatomic, assign) CubeConversationType type;

/*!
 * @brief 消息提示类型。
 */
@property (nonatomic, assign) CubeMessageRemindType remindType;

/*!
 * @brief 关联的联系人。
 */
@property (nonatomic, strong) CContact * contact;

/*!
 * @brief 关联的群组。
 */
@property (nonatomic, strong) CGroup * group;

/*!
 * @brief 该会话联系人或群组的 ID 。
 */
@property (nonatomic, assign) UInt64 identity;

/*!
 * @brief 会话显示的名称。
 */
@property (nonatomic, strong) NSString * displayName;

/*!
 * @brief 头像图片名称。
 */
@property (nonatomic, strong) NSString * avatarName;

/*!
 * @brief 头像图片 URL 。
 */
@property (nonatomic, strong) NSString * avatarURL;

/*!
 * @brief 日期。
 */
@property (nonatomic, strong) NSDate * date;

/*!
 * @brief 显示的内容。
 */
@property (nonatomic, strong) NSString * content;

/*!
 * @brief 未读数量。
 */
@property (nonatomic, assign) NSInteger unread;

/*!
 * @brief 气泡显示的数据。
 */
@property (nonatomic, strong, readonly) NSString * badgeValue;



+ (CubeConversation *)conversationWithMessage:(CMessage *)message currentOwner:(CSelf *)owner;


/*!
 * @brief 是否已读消息。
 */
- (BOOL)isRead;

@end

#endif /* CubeConversation_h */
