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
#import "CellMessageService.h"
#import "CellTalkError.h"

@protocol CellTalkDelegate <NSObject>
@optional
/*!
 * @brief 当收到对端发送过来的原语时该方法被调用。
 * @param speaker 接收到数据的会话者
 * @param cellet 发送原语的Cellet名
 * @param primitive 接收到的原语
 */
- (void)onListened:(CellSpeaker *)speaker withCellet:(NSString *)cellet withPrimitive:(CellPrimitive *)primitive;

/*!
 * @brief 当原语发送出去后该方法被调用。
 * @param speaker 发送数据的会话者
 * @param cellet 接收原语的Cellet名
 * @param primitive 发送的原语
 */
- (void)onSpoke:(CellSpeaker *)speaker withCellet:(NSString *)cellet withPrimitive:(CellPrimitive *)primitive;

/*!
 * @brief 当收到服务器回送的原语应答时该方法被调用。
 * @param speaker 发送数据的会话者
 * @param cellet 接收原语的Cellet名
 * @param primitive 发送的原语
 */
- (void)onAck:(CellSpeaker *)speaker withCellet:(NSString *)cellet withPrimitive:(CellPrimitive *)primitive;

/*!
 * @brief 当发送的原语在指定时间内没有应答时该方法被调用。
 * @param speaker 发送数据的会话者
 * @param cellet 接收原语的Cellet
 * @param primitive 发送的原语
 */
- (void)onSpeakTimeout:(CellSpeaker *)speaker withCellet:(NSString *)cellet withPrimitive:(CellPrimitive *)primitive;

/*!
 * @brief 当会话者连接到服务器完成握手后该方法被调用。
 * @param speaker 发送数据的会话者
 */
- (void)onContacted:(CellSpeaker *)speaker;

/*!
 * @brief 当会话者连接到服务器完成握手后该方法被调用。
 * @param speaker 发送数据的会话者
 */
- (void)onQuitted:(CellSpeaker *)speaker;

/*!
 * @brief 当发生故障时该方法被调用。
 * @param speaker 发送数据的会话者
 * @param code 错误码
 */
- (void)onFailed:(CellSpeaker *)speaker andCode:(CellTalkError *)code;

@end


/*!
 * @brief Talk 会话客户端实现。
 */
@interface CellSpeaker : NSObject <CellMessageHandler>

/*! @brief 访问的主机地址。 */
@property (nonatomic, strong, readonly) NSString * host;

/*! @brief 访问的主机端口。 */
@property (nonatomic, assign, readonly) NSUInteger port;

/*! @brief 当前会话状态。 */
@property (atomic, assign, readonly) CellSpeakState state;

/*! @brief 当前会话的上下文。 */
@property (nonatomic, strong, readonly) CellSession * session;

/*! @brief 会话事件代理 */
@property (strong, nonatomic) id<CellTalkDelegate> delegate;

/*!
 * @brief 指定访问服务器的地址和端口进行初始化。
 * @param tag 指定核心标签。
 * @param host 指定服务器地址。
 * @param port 指定服务器端口。
 * @return 返回 @c CellSpeaker 实例。
 */
- (id)initWithTag:(CellNucleusTag *)tag andHost:(NSString *)host andPort:(NSUInteger)port;

/*!
 * @brief 获取服务器地址。
 * @return 返回服务器地址。
 */
- (NSString *)getRemoteHost;

/*!
 * @brief 获取服务器端口。
 * @return 返回服务器端口。
 */
- (NSUInteger)getRemotePort;

/*!
 * @brief 向指定 Cellet 发送原语数据。
 * @param cellet 指定 Cellet 名称。
 * @param primitive 指定待发送的原语。
 * @return 状态正确返回 @c YES 。
*/
- (BOOL)speak:(NSString *)cellet primitive:(CellPrimitive *)primitive;

/*!
 * @brief 向指定 Cellet 发送原语数据。
 * @param cellet 指定 Cellet 名称。
 * @param primitive 指定待发送的原语。
 * @param ack 是否需要对端进行应答。
 * @return 状态正确返回 @c YES 。
*/
- (BOOL)speak:(NSString *)cellet primitive:(CellPrimitive *)primitive withAck:(BOOL)ack;

/*!
 * @brief 向指定 Cellet 发送需要应答的原语数据。
 * @param cellet 指定 Cellet 名称。
 * @param primitive 指定待发送的原语。
 * @return 状态正确返回 @c YES 。
*/
- (BOOL)speakWithAck:(NSString *)cellet primitive:(CellPrimitive *)primitive;

/*!
 * @brief 向指定 Cellet 发送不需要应答的原语数据。
 * @param cellet 指定 Cellet 名称。
 * @param primitive 指定待发送的原语。
 * @return 状态正确返回 @c YES 。
*/
- (BOOL)speakWithoutAck:(NSString *)cellet primitive:(CellPrimitive *)primitive;

/*!
 * @brief 启动。
 * @return 状态正确返回 @c YES 。
 */
- (BOOL)start;

/*!
 * @brief 关闭。
 * @param now 是否不等待连接断开就立即关闭。
 */
- (void)stop:(BOOL)now;

/*!
 * @brief 设置应答超时时间，单位：毫秒。
 * @param timeout 应答等待超时时长。
 */
- (void)setAckTimeout:(NSTimeInterval)timeout;

@end
