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

#ifndef CMessagingEvent_h
#define CMessagingEvent_h

#import <Foundation/Foundation.h>

/*! @brief 当消息模块就绪时。 */
extern NSString * CMessagingEventReady;

/*! 收到新消息。 */
extern NSString * CMessagingEventNotify;

/*! 消息已经发出。 */
extern NSString * CMessagingEventSent;

/*! 消息正在发送。 */
extern NSString * CMessagingEventSending;

/*! 消息数据处理中。 */
extern NSString * CMessagingEventProcessing;

/*! 消息被撤回。 */
extern NSString * CMessagingEventRecall;

/*! 消息被删除。 */
extern NSString * CMessagingEventDelete;

/*! 消息已读。 */
extern NSString * CMessagingEventRead;

/*! 消息被发送到服务器成功标记为仅作用于自己设备。 */
extern NSString * CMessagingEventMarkOnlyOwner;

/*! 消息被阻止发送。 */
extern NSString * CMessagingEventSendBlocked;

/*! 消息被阻止接收。 */
extern NSString * CMessagingEventReceiveBlocked;

/*! 消息处理故障。 */
extern NSString * CMessagingEventFault;

/*! 未知事件。仅用于调试。 */
extern NSString * CMessagingEventUnknown;

#endif /* CMessagingEvent_h */
