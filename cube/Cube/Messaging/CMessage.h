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

#ifndef CMessage_h
#define CMessage_h

#import "CEntity.h"
#import "CMessageType.h"

@class CContact;
@class CGroup;

/*!
 * @brief 消息作用域。
 */
typedef enum _CMessageScope {

    /*!
     * @brief 无限制。
     */
    CMessageScopeUnlimited = 0,

    /*!
     * @brief 仅自己可见。
     */
    CMessageScopePrivate = 1

} CMessageScope;


/*!
 * @brief 消息实体。
 */
@interface CMessage : CEntity

/*! @brief 消息所在的域。 */
@property (nonatomic, strong, readonly) NSString * domain;

/*! @brief 消息发送方 ID 。 */
@property (nonatomic, assign, readonly) UInt64 from;

/*! @brief 消息发件人。 */
@property (nonatomic, strong, readonly) CContact * sender;

/*! @brief 消息接收方 ID 。 */
@property (nonatomic, assign, readonly) UInt64 to;

/*! @brief 消息收件人。 */
@property (nonatomic, strong, readonly) CContact * receiver;

/*! @brief 消息的收发源。该属性表示消息在一个广播域里的域标识或者域 ID 。 */
@property (nonatomic, assign, readonly) UInt64 source;

/*! @brief 消息的收发群组。 */
@property (nonatomic, strong, readonly) CGroup * sourceGroup;

/*! @brief 本地时间戳。 */
@property (nonatomic, assign, readonly) UInt64 localTS;

/*! @brief 服务器端时间戳。 */
@property (nonatomic, assign, readonly) UInt64 remoteTS;

/*! @brief 消息负载数据。 */
@property (nonatomic, strong, readonly) NSDictionary * payload;

/*! @brief 消息的摘要内容。 */
@property (nonatomic, strong, readonly) NSString * summary;

/*! @brief 消息类型。 */
@property (nonatomic, assign, readonly) CMessageType type;

/*! @brief 消息的创建时间。 */
@property (nonatomic, strong, readonly) NSDate * date;

/*!
 * @brief 消息状态描述。
 * @see CMessageState
 */
@property (nonatomic, assign) int state;

/*! @brief 自己是否是该消息的撰写人。 */
@property (nonatomic, assign) BOOL selfTyper;

/*! @brief 该消息的参与人。 */
@property (nonatomic, weak, readonly) CContact * partner;

/*! @brief 自定义数据。 */
@property (nonatomic, strong) id customData;


//@property (nonatomic, strong, readonly) FileAttachment * attachment;


/*!
 * @brief 初始化消息。
 * @param payload 消息的负载数据。
 * @return 返回 @c CMessage 实例。
 */
- (instancetype)initWithPayload:(NSDictionary *)payload;

/*!
 * @brief 使用 JSON 数据初始化消息实体。
 * @param json 消息的 JSON 结构。
 * @return 返回 @c CMessage 实例。
 */
- (instancetype)initWithJSON:(NSDictionary *)json;

/*!
 * @brief 使用其他消息实例数据初始化消息实体。
 * @param message 源消息实例。
 * @return 返回 @c CMessage 实例。
 */
- (instancetype)initWithMessage:(CMessage *)message;

/*!
 * @brief 获取消息范围。
 */
- (int)getScope;

/*!
 * @brief 是否来自群组。
 * @return 如果消息来自群组返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)isFromGroup;


/*!
 * @brief 设置消息路由相关数据。
 * @private
 */
- (void)bind:(UInt64)from
          to:(UInt64)to
      source:(UInt64)source;

/*!
 * @private
 */
- (void)assignTS:(UInt64)localTS remoteTS:(UInt64)remoteTS;

/*!
 * @private
 */
- (void)assign:(CContact *)sender receiver:(CContact *)receiver
   sourceGroup:(CGroup *)sourceGroup;

/*!
 * @private
 */
- (void)assignSender:(CContact *)sender;

/*!
 * @private
 */
- (void)assignReceiver:(CContact *)receiver;

/*!
 * @private
 */
- (void)assignSourceGroup:(CGroup *)group;

@end

#endif /* CMessage_h */
