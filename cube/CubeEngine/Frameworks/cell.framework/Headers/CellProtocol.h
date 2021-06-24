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

/*! @brief 握手协议。 */
const static char CellProtocolHandshake[2] = { 'H', 'S' };
/*! @brief 握手协议码。 */
const static char CellProtocolHandshakeCode = 1;

/*! @brief 无应答会话协议。 */
const static char CellProtocolSpeakNoAck[2] = { 'S', 'N' };
/*! @brief 无应答会话协议码。 */
const static char CellProtocolSpeakNoAckCode = 2;

/*! @brief 可应答会话协议。 */
const static char CellProtocolSpeakAck[2] = { 'S', 'A' };
/*! @brief 可应答会话协议码。 */
const static char CellProtocolSpeakAckCode = 3;

/*! @brief 会话应答协议。 */
const static char CellProtocolAck[2] = { 'A', 'C' };
/*! @brief 会话应答协议码。 */
const static char CellProtocolAckCode = 6;

/*! @brief 心跳协议。 */
const static char CellProtocolHeartbeat[2] = { 'H', 'B' };
/*! @brief 心跳协议码。 */
const static char CellProtocolHeartbeatCode = 7;

/*! @brief 心跳应答协议。 */
const static char CellProtocolHeartbeatAck[2] = { 'H', 'A' };
/*! @brief 心跳应答协议码。 */
const static char CellProtocolHeartbeatAckCode = 8;


/*!
 * @brief 握手协议。
 */
@interface CellHandshakeProtocol : NSObject
@property (nonatomic, strong) NSData * key;
@property (nonatomic, strong) NSString * tag;
@end


/*!
 * @brief 心跳协议。
 */
@interface CellHeartbeatProtocol : NSObject
@property (nonatomic, strong) NSString * tag;
@property (nonatomic, assign) int64_t originateTimestamp;
@property (nonatomic, assign) int64_t receiveTimestamp;
@property (nonatomic, assign) int64_t transmitTimestamp;
@end


/*!
 * @brief 无应答会话协议。
 */
@interface CellSpeakNoAckProtocol: NSObject
@property (nonatomic, strong) NSString *target;
@property (nonatomic, strong) CellPrimitive *primitive;
@end


/*!
 * @brief 可应答会话协议。
 */
@interface CellSpeakAckProtocol : NSObject
@property (nonatomic, strong) NSString * target;
@property (nonatomic, strong) CellPrimitive * primitive;
@end


/*!
 * @brief 会话应答协议。
 */
@interface CellAckProtocol : NSObject
@property (nonatomic, strong) NSString * target;
@property (nonatomic, strong) NSData * sn;
@end


/*!
 * @brief 协议描述。
 * 数据包字段，单位 byte：
 * @code
 * +--|-00-|-01-|-02-|-03-|-04-|-05-|-06-|-07-+<br>
 * |--+---------------------------------------+<br>
 * |01| VER| SN |         RES       |    PN   |<br>
 * |--+---------------------------------------+<br>
 * |02|              DATA BEGIN               |<br>
 * |--+---------------------------------------+<br>
 * |03|                ... ...                |<br>
 * |--+---------------------------------------+<br>
 * |04|               DATA END                |<br>
 * |--+---------------------------------------+<br>
 * @endcode
 * DATA 段的数据使用 0x1E 作为数据分隔符。
 */
@interface CellProtocol : NSObject

/*!
 * @brief 识别协议类型。
 * @param data 原始数据报文。
 * @return 返回协议码。
 */
+ (char)recognize:(char *)data;

/*!
 * @brief 序列化握手。
 * @param[out] output 保存了报文数据的缓存。
 * @param[in] key 通信的密钥。
 * @param[in] keyLength 密钥长度。
 * @param[in] tag 对端的标签。
 * @param[in] tagLength 标签长度。
 */
+ (void)serializeHandshake:(CellByteBuffer *)output key:(char *)key keyLength:(int)keyLength tag:(const char *)tag tagLength:(NSUInteger)tagLength;

/*!
 * @brief 反序列化握手。
 * @param data 原始数据报文。
 * @param length 数据报文长度。
 * @return 握手协议实例。
 */
+ (CellHandshakeProtocol *)deserializeHandshake:(char *)data length:(NSUInteger)length;

/*!
 * @brief 序列化心跳。
 * @param[out] output 保存了报文数据的缓存。
 * @param[in] tag 内核标签。
 * @param[in] timestamp 时间戳。
 */
+ (void)serializeHeartbeat:(CellByteBuffer *)output tag:(NSString *)tag timestamp:(int64_t)timestamp;

/*!
 * @brief 反序列化心跳。
 * @param data 数据报文。
 * @param length 数据报文长度。
 * @return 返回心跳协议实例。
 */
+ (CellHeartbeatProtocol *)deserializeHeartbeat:(char *)data length:(NSUInteger)length;

/*!
 * @brief 序列化心跳应答。
 * @param[out] output 保存了报文数据的缓存。
 * @param[in] tag 给予应答的标签。
 * @param[in] originateTimestamp 原心跳协议的原时间戳。
 * @param[in] receiveTimestamp 本端接收数据的时间戳。
 * @param[in] transmitTimestamp 本端发送应答的时间戳。
 */
+ (void)serializeHeartbeatAck:(CellByteBuffer *)output tag:(NSString *)tag originateTimestamp:(int64_t)originateTimestamp
             receiveTimestamp:(int64_t)receiveTimestamp transmitTimestamp:(int64_t)transmitTimestamp;

/*!
 * @brief 反序列化心跳应答。
 * @param data 数据报文。
 * @param length 数据报文长度。
 * @return 返回心跳协议实例。
 */
+ (CellHeartbeatProtocol *)deserializeHeartbeatAck:(char *)data length:(NSUInteger)length;

/*!
 * @brief 序列化无应答会话协议。
 * @param[out] output 保存了报文数据的缓存。
 * @param[in] target 目标名称。
 * @param[in] primitive 原语数据。
 */
+ (void)serializeSpeakNoAck:(CellByteBuffer *)output target:(NSString *)target primitive:(CellPrimitive *)primitive;

/*!
 * @brief 反序列化无应答会话协议。
 * @param data 数据报文。
 * @param length 数据报文长度。
 * @return 返回会话协议实例。
 */
+ (CellSpeakNoAckProtocol *)deserializeSpeakNoAck:(char *)data length:(NSUInteger)length;

/*!
 * @brief 序列化可应答会话协议。
 * @param[out] output 保存了报文数据的缓存。
 * @param[in] target 目标名称。
 * @param[in] primitive 原语数据。
 */
+ (void)serializeSpeakAck:(CellByteBuffer *)output target:(NSString *)target primitive:(CellPrimitive *)primitive;

/*!
 * @brief 反序列化可应答会话协议。
 * @param data 数据报文。
 * @param length 数据报文长度。
 * @return 返回会话协议实例。
 */
+ (CellSpeakAckProtocol *)deserializeSpeakAck:(char *)data length:(NSUInteger)length;

/*!
 * @brief 序列化应答协议。
 * @param[out] output 保存了报文数据的缓存。
 * @param[in] target 目标名称。
 * @param[in] sn 应答序号。
 */
+ (void)serializeAck:(CellByteBuffer *)output target:(NSString *)target sn:(char *)sn;

/*!
 * @brief 反序列化应答协议。
 * @param data 数据报文。
 * @param length 数据报文长度。
 * @return 返回应答协议实例。
 */
+ (CellAckProtocol *)deserializeAck:(char *)data length:(NSUInteger)length;

/*!
 * @brief 产生并消费掉一个可用的包序号。
 * @return 返回可用的包序号。
 */
+ (char)consumeSN;

/*!
 * @brief 查找并进行数据转义。
 */
+ (NSUInteger)escape:(char *)output input:(char *)input length:(NSUInteger)length;

@end
