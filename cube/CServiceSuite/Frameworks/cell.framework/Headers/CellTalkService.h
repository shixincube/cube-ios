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

#ifndef CellTalkService_h
#define CellTalkService_h

#import "CellPrerequisites.h"
#import "CellTalkService.h"
#import "CellTalkListener.h"
#import "CellSession.h"

/*!
 * @brief 会话服务。
 */
@interface CellTalkService : NSObject

/*! @brief 内核标签。 */
@property (nonatomic, strong) CellNucleusTag *tag;

/*! @brief 事件监听代理。 */
@property (nonatomic, weak) id<CellTalkListener> delegate;

/*!
 * @brief 通过指定内核标签初始化会话服务。
 * @param tag 内核标签。
 * @return 返回 @c CellTalkService 实例。
 */
- (id)initWithTag:(CellNucleusTag *)tag;


/*!
 * @brief 与指定地址和端口的服务器建立连接。
 * @param host 指定地址。
 * @param port 指定端口。
 * @return 返回 @c CellSpeaker 实例。
 */
- (CellSpeaker *)call:(NSString *)host withPort:(int)port;


/*!
 * @brief 与指定地址和端口的服务器建立连接。
 * @param host 指定地址。
 * @param port 指定端口。
 * @param cellet 指定 Cellet 名称。
 * @return 返回 @c CellSpeaker 实例。
 */
- (CellSpeaker *)call:(NSString *)host withPort:(int)port withCellet:(NSString *)cellet;


/*!
 * @brief 与指定地址和端口的服务器建立连接。
 * @param host 指定地址。
 * @param port 指定端口。
 * @param cellets 指定 Cellet 名称。
 * @return 返回 @c CellSpeaker 实例。
 */
- (CellSpeaker *)call:(NSString *)host withPort:(int)port withCellets:(NSArray <NSString *>*)cellets;


/*!
 * @brief 关闭与指定地址和端口的服务器的连接。
 * @param host 指定地址。
 * @param port 指定端口。
 * @param now 是否立即挂断。
 */
- (void)hangup:(NSString *)host withPort:(int)port withNow:(BOOL)now;


/*!
 * @brief 向指定的 Cellet 发送原语，无需对端进行应答。
 * @param cellet 指定 Cellet 名称。
 * @param primitive 指定原语。
 * @return 如果状态正确返回 @c YES ，否则返回 @c NO 。
 */
- (BOOL)speak:(NSString *)cellet withPrimitive:(CellPrimitive *)primitive;


/*!
 * @brief 向指定的 Cellet 发送原语。
 * @param cellet 指定 Cellet 名称。
 * @param primitive 指定原语。
 * @param ack 是否需要对端进行应答。
 * @return 如果状态正确返回 @c YES ，否则返回 @c NO 。
 */
- (BOOL)speak:(NSString *)cellet withPrimitive:(CellPrimitive *)primitive withAck:(BOOL)ack;


/*!
 * @brief 向指定的 Cellet 发送原语，需要对端进行应答。
 * @param cellet 指定 Cellet 名称。
 * @param primitive 指定原语。
 * @return 如果状态正确返回 @c YES ，否则返回 @c NO 。
 */
- (BOOL)speakWithAck:(NSString *)cellet withPrimitive:(CellPrimitive *)primitive;


/*!
 * @brief 向指定的Cellet发送原语，无需对端进行应答。
 * @param cellet 指定 Cellet 名称。
 * @param primitive 指定原语。
 * @return 如果状态正确返回 @c YES ，否则返回 @c NO 。
 */
- (BOOL)speakWithoutAck:(NSString *)cellet withPrimitive:(CellPrimitive *)primitive;


/*!
 * @brief 设置原语应答超时时间。
 * @param timeout 指定超时时长，单位：毫秒。
 */
- (void)setAckTimeout:(int64_t)timeout;


/*!
 * @brief 获取原语应答超时时间。
 * @return 返回原语应答超时时间。
 */
- (int64_t)getAckTimeout;


/*!
 * @brief 是否已经连接到指定的 Cellet 。
 * @param cellet 指定 Cellet 名称。
 * @return 如果已连接到指定的 Cellet 返回 @c YES ，否则返回 @c NO 。
 */
- (BOOL)isCalled:(NSString *)cellet;


/*!
 * @brief 是否已经连接到服务器。
 * @param host 指定服务器地址。
 * @param port 指定服务器端口。
 * @return 如果已连接到指定的服务器返回 @c YES ，否则返回 @c NO 。
 */
- (BOOL)isCalled:(NSString *)host withPort:(int)port;

@end

#endif
