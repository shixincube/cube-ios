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

#import "CellPrerequisites.h"

/*!
 * @brief 心跳管理事件代理。
 */
@protocol CellHeartbeatMachineDelegate <NSObject>

@optional

/*!
 * @brief 当被管理的会话心跳超时时调用该方法。
 * @param session 超时的会话。
 * @param duration 超时会话的最近一次心跳时长。
 */
- (void)onSessionTimeout:(CellSession *)session duration:(int64_t)duration;

@end


/*!
 * @brief 用于维护心跳的管理器。
 */
@interface CellHeartbeatMachine : NSObject

@property (nonatomic, strong) id<CellHeartbeatMachineDelegate> heartbeatDelegate;

/*!
 * @brief 初始化方法。
 * @param connector 指定连接器。
 * @param delegate 事件代理。
 * @return 返回 @c CellHeartbeatMachine 实例。
 */
- (id)initWithConnector:(CellNonblockingConnector *)connector withDelegate:(id<CellHeartbeatMachineDelegate>)delegate;

/*!
 * @brief 启动心跳控制器。
 */
- (void)startup;

/*!
 * @brief 关闭心跳控制器。
 */
- (void)shutdown;

/*!
 * @brief 添加被管理的心跳会话。
 * @param session 指定待管理的会话上下文。
 * @param tag 对端标签。
 */
- (void)addSession:(CellSession *)session withTag:(NSString *)tag;

/*!
 * @brief 删除被管理的心跳会话。
 * @param session 指定待删除的会话上下文。
 */
- (void)removeSession:(CellSession *)session;

/*!
 * @brief 处理来自对端的心跳数据。
 * @param session 消息层的会话上下文。
 * @param data 原始报文。
 * @param length 原始报文长度。
 * @param time 接收到数据包时的时间。
 */
- (void)processHeartbeat:(CellSession *)session data:(char *)data length:(NSUInteger)length
                    time:(int64_t)time;


/*!
 * @brief 处理来自对端的返回的心跳应答。
 * @param session 消息层的会话上下文。
 * @param data 原始报文。
 * @param length 原始报文长度。
 */
- (void)processHeartbeatAck:(CellSession *)session data:(char *)data length:(NSUInteger)length;

@end
