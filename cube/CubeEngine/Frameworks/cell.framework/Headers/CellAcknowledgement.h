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
 * @brief 应答管理事件代理。
 */
@protocol CellAcknowledgementDelegate <NSObject>

@optional

/*!
 * @brief 当终端应答超时时调用该方法。
 * @param session 超时的会话上下文。
 * @param cellet 关联的 Cellet 名称。
 * @param primitive 超时未应答的原语。
 */
- (void)onAckTimeout:(CellSession *)session withCellet:(NSString *)cellet withPrimitive:(CellPrimitive *)primitive;

@end


/*!
 * @brief 应答管理器。
 */
@interface CellAcknowledgement : NSObject

@property (nonatomic, weak) id<CellAcknowledgementDelegate> acknowledgementDelegate;

- (id)initWithDic:(NSMutableDictionary<NSNumber *, CellPrimitiveCapsule *> *)spokeDic withDelegate:(id<CellAcknowledgementDelegate>)delegate;

/*!
 * @brief 启动管理器。
 */
- (void)start;

/*!
 * @brief 关闭管理器。
 */
- (void)stop;

/*!
 * @brief 重置超时时间。
 * @param timeout 指定超时时间。
 */
- (void)resetTimeout:(NSTimeInterval)timeout;

/*!
 * @brief 获取应答的超时时间。
 * @return 返回应答的超时时间。
 */
- (NSTimeInterval)getTimeout;

@end
