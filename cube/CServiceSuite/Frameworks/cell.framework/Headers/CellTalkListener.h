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

#ifndef CellTalkListener_h
#define CellTalkListener_h

#import "CellPrerequisites.h"

/*!
 * @brief 会话监听器。
 */
@protocol CellTalkListener <NSObject>
@optional

/*!
 * @brief 当收到对端发送过来的原语时该方法被调用。
 * @param speaker 接收到数据的会话者。
 * @param cellet 发送原语的 Cellet 名。
 * @param primitive 接收到的原语。
 */
- (void)onListened:(CellSpeaker *)speaker cellet:(NSString *)cellet primitive:(CellPrimitive *)primitive;

/*!
 * @brief 当原语发送出去后该方法被调用。
 * @param speaker 发送数据的会话者。
 * @param cellet 接收原语的 Cellet 名。
 * @param primitive 发送的原语。
 */
- (void)onSpoke:(CellSpeaker *)speaker cellet:(NSString *)cellet primitive:(CellPrimitive *)primitive;

/*!
 * @brief 当收到服务器回送的原语应答时该方法被调用。
 * @param speaker 发送数据的会话者。
 * @param cellet 接收原语的 Cellet 名。
 * @param primitive 发送的原语。
 */
- (void)onAck:(CellSpeaker *)speaker cellet:(NSString *)cellet primitive:(CellPrimitive *)primitive;

/*!
 * @brief 当发送的原语在指定时间内没有应答时该方法被调用。
 * @param speaker 发送数据的会话者。
 * @param cellet 接收原语的 Cellet 名。
 * @param primitive 发送的原语。
 */
- (void)onSpeakTimeout:(CellSpeaker *)speaker cellet:(NSString *)cellet primitive:(CellPrimitive *)primitive;

/*!
 * @brief 当会话者连接到服务器完成握手后该方法被调用。
 * @param speaker 发送数据的会话者。
 */
- (void)onContacted:(CellSpeaker *)speaker;

/*!
 * @brief 当会话者断开与服务器的连接时该方法被调用。
 * @param speaker 发送数据的会话者。
 */
- (void)onQuitted:(CellSpeaker *)speaker;

/*!
 * @brief 当发生故障时该方法被调用。
 * @param speaker 发送数据的会话者。
 * @param error 错误描述。
 */
- (void)onFailed:(CellSpeaker *)speaker error:(CellTalkError *)error;

@end

#endif /* CellTalkListener_h */
