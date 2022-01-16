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

#ifndef CConversation_h
#define CConversation_h

#import "CEntity.h"

@class CContact;
@class CGroup;
@class CMessage;


/*!
 * @brief 会话类型。
 */
typedef NS_ENUM(NSInteger, CConversationType) {
    /*! @brief 与联系人的会话。  */
    CConversationTypeContact = 1,

    /*! @brief 与群组的会话。  */
    CConversationTypeGroup = 2,

    /*! @brief 与组织的会话。  */
    CConversationTypeOrganization = 3,

    /*! @brief 系统类型会话。  */
    CConversationTypeSystem = 4,

    /*! @brief 通知类型会话。  */
    CConversationTypeNotifier = 5,

    /*! @brief 助手类型会话。  */
    CConversationTypeAssistant = 6,

    /*! @brief 其他会话类型。  */
    CConversationTypeOther = 9
};


/*!
 * @brief 会话的状态。
 */
typedef NS_ENUM(NSInteger, CConversationState) {
    /*! @brief 正常状态。  */
    CConversationStateNormal = 1,

    /*! @brief 重要的或置顶的状态。  */
    CConversationStateImportant = 2,

    /*! @brief 已删除。  */
    CConversationStateDeleted = 3
};


/*!
 * @brief 会话提醒类型。
 */
typedef NS_ENUM(NSInteger, CConversationReminding) {
    /*! @brief 正常接收。 */
    CConversationRemindingNormal = 1,

    /*! @brief 接收不提醒。 */
    CConversationRemindingClosed = 2,

    /*! @brief 接收但不关注。 */
    CConversationRemindingNotCare = 3,

    /*! @brief 不接收。 */
    CConversationRemindingRefused = 4
};


/*!
 * @brief 会话。
 */
@interface CConversation : CEntity

/*!
 * @brief 会话类型。
 */
@property (nonatomic, assign, readonly) CConversationType type;

/*!
 * @brief 会话状态。
 */
@property (nonatomic, assign, readonly) CConversationState state;

/*!
 * @brief 与会话相关的关键实体的 ID 。
 */
@property (nonatomic, assign, readonly) UInt64 pivotalId;

/*!
 * @brief 关联的联系人。
 */
@property (nonatomic, strong, readonly) CContact * contact;

/*!
 * @brief 关联的群组。
 */
@property (nonatomic, strong, readonly) CGroup * group;

/*!
 * @brief 会话最近的消息。
 */
@property (nonatomic, strong, readonly) CMessage * recentMessage;

/*!
 * @brief 会话提醒类型。
 */
@property (nonatomic, assign, readonly) CConversationReminding reminding;

/*!
 * @brief 头像名称。
 */
@property (nonatomic, strong, readonly) NSString * avatarName;

/*!
 * @brief 头像的 URL 。
 */
@property (nonatomic, strong, readonly) NSString * avatarURL;

/*!
 * @brief 显示名称。
 */
@property (nonatomic, readonly) NSString * displayName;

/*!
 * @brief 日期。
 */
@property (nonatomic, strong, readonly) NSDate * date;

/*!
 * @brief 最近的摘要。
 */
@property (nonatomic, strong, readonly) NSString * recentSummary;


/*!
 * @brief 使用 JSON 数据初始化。
 */
- (instancetype)initWithJSON:(NSDictionary *)json;

/*!
 * @brief 通过指定参数值初始化。
 */
- (instancetype)initWithId:(UInt64)identity
                 timestamp:(UInt64)timestamp
                      type:(CConversationType)type
                     state:(CConversationState)state
                 pivotalId:(UInt64)pivotalId
             recentMessage:(CMessage *)recentMessage
                 reminding:(CConversationReminding)reminding;

/*!
 * @brief 判断指定消息是否属于该会话。
 * @param message 指定消息。
 * @return 如果属于该会话消息返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)isFocus:(CMessage *)message;

/*!
 * @brief 设置关联联系人。
 * @private
 */
- (void)setPivotalWithContact:(CContact *)contact;

/*!
 * @brief 设置关联群组。
 * @private
 */
- (void)setPivotalWithGroup:(CGroup *)group;

/*!
 * @brief 重置最近消息。
 * @private
 */
- (void)resetRecentMessage:(CMessage *)message;

@end

#endif /* CConversation_h */
