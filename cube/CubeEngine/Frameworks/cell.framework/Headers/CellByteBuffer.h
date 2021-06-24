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
 * @brief 支持弹性空间调整的字节缓存。
 */
@interface CellByteBuffer : NSObject

/*!
 * @brief 指定初始容量初始化。
 * @param capacity 初始化容量。
 * @return 返回 @c CellByteBuffer 实例。
 */
- (id)initWithCapacity:(NSUInteger)capacity;

/*!
 * @brief 返回当前缓存的容量。
 * @return 返回当前缓存的容量。
 */
- (NSUInteger)capacity;

/*!
 * @brief 返回数据游标 position 位置。
 * @return 返回数据游标 position 位置。
 */
- (NSUInteger)position;

/*!
 * @brief 定位数据游标。
 * @param newPosition 新的游标位置。
 * @return 返回 @c self 指针。
 */
- (CellByteBuffer *)position:(NSUInteger)newPosition;

/*!
 * @brief 返回 limit 限制位。
 * @return 返回 limit 限制位。
 */
- (NSUInteger)limit;

/*!
 * @brief 设置新的限制位。
 * @param newLimit 新的限制位位置。
 * @return 返回 @c self 指针。
 */
- (CellByteBuffer *)limit:(NSUInteger)newLimit;

/*!
 * @brief 复位所有标记，实现清空数据的效果。
 */
- (void)clear;

/*!
 * @brief 整理数据，设定限制位到当前游标，并将游标重置。
 * @return 返回 @c self 指针。
 */
- (CellByteBuffer *)flip;

/*!
 * @brief 返回数据游标距离限制位的长度。
 * @return 返回数据游标距离限制位的长度。
 */
- (NSUInteger)remaining;

/*!
 * @brief 是否还有剩余数据。
 * @return 如果游标未移动到限制位返回 @c YES ，否则返回 @c NO 。
 */
- (BOOL)hasRemaining;

/*!
 * @brief 写入数据并后移游标。
 * @param data 数据源。
 * @return 返回 @c self 指针。
 */
- (CellByteBuffer *)put:(char)data;

/*!
 * @brief 写入数据并后移游标。
 * @param data 数据源。
 * @param offset 数据源偏移。
 * @param length 数据源长度。
 * @return 返回 @c self 指针。
 */
- (CellByteBuffer *)put:(const char *)data offset:(NSUInteger)offset length:(NSUInteger)length;

/*!
 * @brief 返回当前游标位置的数据并后移游标。
 * @return 返回当前游标位置的数据并后移游标。
 */
- (char)get;

/*!
 * @brief 返回指定位置处的数据。
 * @param[out] buf 将缓存内的数据复制到输入的字节数组。
 * @param[in] offset 指定接收数据的内存偏移位。
 * @param[in] length 指定接收的数据长度。
 * @return 返回 @c self 指针。
 */
- (CellByteBuffer *)get:(char *)buf offset:(NSUInteger)offset length:(NSUInteger)length;

/*!
 * @brief 将整个缓存的数据返回。
 * @return 返回整个缓存的数据。
 */
- (char *)bytes;

@end
