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

#ifndef CELL_HEAD_LENGTH
#define CELL_HEAD_LENGTH 4
#endif

#ifndef CELL_TAIL_LENGTH
#define CELL_TAIL_LENGTH 4
#endif

/// 默认消息头。
static char MessageDefaultHead[] = { 0x20, 0x13, 0x09, 0x08 };

/// 默认消息尾。
static char MessageDefaultTail[] = { 0x19, 0x78, 0x10, 0x04 };

/*!
 * @brief 消息描述类。
 */
@interface CellMessage : NSObject

/*! @brief 消息序号。 */
@property (nonatomic, strong, readonly) NSNumber *sn;

/*! @brief 自定义上下文。 */
@property (nonatomic, strong) NSObject * context;

/*!
 * @brief 指定数据对象初始化。
 * @param data 指定消息数据。
 * @return 返回 @ref CellMessage 对象实例。
 */
- (id)initWithData:(NSData *)data;

/*!
 * @brief 指定字节数组初始化。
 *
 * @param bytes 指定字节数组形式的消息数据。
 * @param length 指定数据长度。
 * @return 返回 @ref CellMessage 对象实例。
 */
- (id)initWithBytes:(const char *)bytes length:(NSUInteger)length;

/*!
 * @brief 获取消息的数据。
 * @return 返回消息数据。
 */
- (NSData *)data;

/*!
 * @brief 获得消息的数据指针。
 * @return 返回消息的数据指针。
 */
- (char *)getPayload;

/*!
 * @brief 获得消息数据的长度。
 * @return 返回消息数据的长度。
 */
- (NSUInteger)getPayloadLength;

/*!
 * @brief 设置消息负载数据。
 * @param bytes 指定字节数组形式的消息数据。
 * @param length 指定数据长度。
 */
- (void)setPayload:(const char *)bytes length:(NSUInteger)length;

/*!
 * @brief 是否使用了压缩格式。
 * @return 返回是否使用了压缩格式。
 */
- (BOOL)isCompressible;

/*!
 * @brief 校验负载是否是压缩格式。
 * @return 返回消息负载是否是压缩格式。
 */
- (BOOL)verifyCompression;

/*!
 * @brief 是否需要压缩。
 * @return 返回是否需要压缩。
 */
- (BOOL)needCompressible;

/*!
 * @brief 校验指定的数据是否是压缩格式。
 * @param data 数据报文。
 * @return 返回数据报文是否是压缩格式。
 */
+ (BOOL)verifyCompression:(NSData *)data;

/*!
 * @brief 从指定的数据源提取符合格式的 @ref CellMessage 数据对象列表。
 * @param result 保存提取结果。
 * @param source 数据源。
 * @param remains 剩余的数据缓存。
 */
+ (void)extract:(NSMutableArray *)result source:(CellByteBuffer *)source remains:(CellByteBuffer *)remains;

@end
