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

@interface CellHeartbeatContext : NSObject

/*! @brief 心跳包离开发送端的时间。 */
@property (nonatomic, assign) int64_t originateTimestamp;

/*! @brief 对端接收到心跳包的时间。 */
@property (nonatomic, assign) int64_t receiveTimestamp;

/*! @brief 对方返回心跳应答的时间。 */
@property (nonatomic, assign) int64_t transmitTimestamp;

/*! @brief 本地收到心跳应答的时间。 */
@property (nonatomic, assign) int64_t localTimestamp;

/*! @brief 内核标签。 */
@property (nonatomic, copy) NSString *tag;

/*! @brief 关联的会话。 */
@property (nonatomic, strong) CellSession *session;

/*!
 * @brief 初始化。
 * @param session 关联的消息层会话。
 * @param tag 指定内核标签。
 * @return 返回 @c CellHeartbeatContext 实例。
 */
- (id)initWithSession:(CellSession *)session withTag:(NSString *)tag;

@end
