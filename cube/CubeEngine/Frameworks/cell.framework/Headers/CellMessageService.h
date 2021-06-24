/*
This source file is part of Cell.

The MIT License (MIT)

Copyright (c) 2020 Shixin Cube Team.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#include "CellPrerequisites.h"

/*!
 * @brief 消息错误码定义。
 */
typedef enum _CellMessageErrorCode
{
    /*! @brief 未知的错误类型。 */
    CellMessageErrorUnknown = 100,
    /*! @brief 无效的网络地址。 */
    CellMessageErrorAddressInvalid = 101,
    /*! @brief 错误的状态。 */
    CellMessageErrorStateError = 102,
    
    /*! @brief Socket 函数发生错误。 */
    CellMessageErrorSocketFailed = 200,
    /*! @brief 绑定服务时发生错误。 */
    CellMessageErrorBindFailed = 201,
    /*! @brief 监听连接时发生错误。 */
    CellMessageErrorListenFailed = 202,
    /*! @brief Accept 发生错误。 */
    CellMessageErrorAcceptFailed = 203,

    /*! @brief 连接失败。 */
    CellMessageErrorConnectFailed = 300,
    /*! @brief 连接超时。 */
    CellMessageErrorConnectTimeout = 301,
    /*! @brief 连接正常结束 */
    CellMessageErrorConnectEnd = 305,

    /*! @brief 写数据超时。 */
    CellMessageErrorWriteTimeout = 401,
    /*! @brief 读数据超时。 */
    CellMessageErrorReadTiemout = 402,
    /*! @brief 写入数据时发生错误。 */
    CellMessageErrorWriteFailed = 403,
    /*! @brief 读取数据时发生错误。 */
    CellMessageErrorReadFailed = 404,
    /*! @brief 写数据越界。 */
    CellMessageErrorWriteOutOfBounds = 405

} CellMessageErrorCode;


/*!
 * @brief 消息服务处理监听器。
 */
@protocol CellMessageHandler <NSObject>
@optional

/*!
 * @brief 创建连接会话。
 * @param session 发生此事件的会话。
 */
- (void)sessionCreated:(CellSession *)session;

/*!
 * @brief 销毁连接会话。
 * @param session 发生此事件的会话。
 */
- (void)sessionDestroyed:(CellSession *)session;

/*!
 * @brief 开启连接会话。
 * @param session 发生此事件的会话。
 */
- (void)sessionOpened:(CellSession *)session;

/*!
 * @brief 关闭连接会话。
 * @param session 发生此事件的会话。
 */
- (void)sessionClosed:(CellSession *)session;

/*!
 * @brief 接收到消息。
 * @param session 发生此事件的会话。
 * @param message 接收到的消息。
 */
- (void)messageReceived:(CellSession *)session message:(CellMessage *)message;

/*!
 * @brief 消息已发送。
 * @param session 发生此事件的会话。
 * @param message 已发送的消息。
 */
- (void)messageSent:(CellSession *)session message:(CellMessage *)message;

/*!
 * @brief 发生错误。
 * @param errorCode 发生错误的错误码。
 * @param session 发生此事件的会话。
 * @see CellMessageErrorCode
 */
- (void)errorOccurred:(CellMessageErrorCode)errorCode session:(CellSession *)session;

@end


/*!
 * @brief 消息服务。
 */
@interface CellMessageService : NSObject

/*! @brief 消息事件委派。 */
@property (strong, nonatomic) id<CellMessageHandler> delegate;

/*!
 * @brief 指定消息操作委派初始化。
 * @param delegate 指定委派。
 * @return 返回 @ref CellMessageService 实例。
 */
- (id)initWithDelegate:(id<CellMessageHandler>)delegate;

/*!
 * @brief 设置消息操作委派。
 * @param delegate 指定委派。
 */
- (void)setDelegate:(id<CellMessageHandler>)delegate;

@end
