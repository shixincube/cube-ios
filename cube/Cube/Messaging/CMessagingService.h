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

#ifndef CMessagingService_h
#define CMessagingService_h

#import "CModule.h"
#import "CContactService.h"
#import "CMessage.h"

#ifndef CUBE_MODULE_MESSAGING
/*! @brief 模块名。 */
#define CUBE_MODULE_MESSAGING @"Messaging"
#endif

@class CMessagingService;
@class CMessagingPipelineListener;
@class CMessagingStorage;
@class CMessagingObserver;


/*!
 * @brief 消息实时通知的代理协议。
 */
@protocol CMessagingNotifyDelegate <NSObject>

- (void)notify:(CMessage *)message service:(CMessagingService *)service;

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

/*! 默认回溯时长，默认值：14个自然天。 */
@property (nonatomic, assign) UInt64 defaultRetrospect;

/*! 消息实时接收的代理。 */
@property (retain) id<CMessagingNotifyDelegate> notifyDelegate;


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
 * @private
 * @brief 进行数据加载。
 */
- (void)prepare:(CContactService *)contactService completedHandler:(void(^)(void))completedHandler;

/*!
 * @private
 * @brief 从服务器上下载指定时间段内的数据，数据将直接写入本地存储。
 * @param beginning 指定获取消息的起始时间。
 * @param ending 指定获取消息的截止时间。
 * @param completedHandler 指定本次查询回调，该回调函数仅用于通知该次查询结束，不携带任何消息数据。
 */
- (void)queryRemoteMessage:(UInt64)beginning ending:(UInt64)ending completedHandler:(void(^)(void))completedHandler;

/*!
 * @private
 * @brief 触发拉取消息完成回调句柄。
 */
- (void)firePullCompletedHandler;

/*!
 * @private
 * @brief 填充消息。
 */
- (void)fillMessage:(CMessage *)message;

@end

#endif /* CMessagingService_h */
