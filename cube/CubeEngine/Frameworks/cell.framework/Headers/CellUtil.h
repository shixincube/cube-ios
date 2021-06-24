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
 * @brief 辅助函数库。
 */
@interface CellUtil : NSObject

/*!
 * @brief 获取当前系统绝对时间值。单位：秒。
 * @return 返回以毫秒为单位的当前系统绝对时间值。
 */
+ (NSTimeInterval)currentTimeInterval;

/*!
 * @brief 返回当前系统绝对时间值。单位：毫秒。
 * @return 返回以毫秒为单位的当前系统绝对时间值。
 */
+ (int64_t)currentTimeMillis;

/*!
 * @brief 生成随机数。
 * @return 返回随机 @c long 型值。
 */
+ (long)randomLong;

/*!
 * @brief 生成指定长度的随机字符串。
 * @param length 指定字符串长度。
 * @return 返回生成的字符串。
 */
+ (NSString *)randomString:(int)length;

/*!
 * @brief 生成指定长度的随机字符串。
 * @param[out] string 指定生成的字符串指针。
 * @param[in] length 指定字符串长度。
 */
+ (void)randomString:(char *)string length:(int)length;

/*!
 * @brief 生成指定长度的随机字节数组。
 * @param[out]  output 指定接收数据的字节数组。
 * @param[in]  length 指定需生成数组的长度。
 */
+ (void)randomBytes:(char *)output length:(int)length;

/*!
 * @brief 生成系统全局唯一无符号序列号。
 * @return 返回长整型形式的系统全局唯一无符号序列号。
 */
+ (int64_t)generateUnsignedSerialNumber;

/*!
 * @brief 转换 @c NSData 为 @c NSTimeInterval，即绝对时间。
 * @param data 符合格式的数据。
 * @return 返回绝对时间。
 */
+ (NSTimeInterval)convertDataToTimeInterval:(NSData *)data;

/*!
 * @brief @c short 型转字节数组。
 * @param[out] output 输出字节数组，长度 2 字节。
 * @param[in] input 输入 @c short 数据。
 * @return 返回数组长度。
 */
+ (unsigned int)shortToBytes:(char *)output input:(short)input;

/*!
 * @brief @c int 型转字节数组。
 * @param[out] output 输出字节数组，长度 4 字节。
 * @param[in] input 输入 @c int 数据。
 * @return 返回数组长度。
 */
+ (unsigned int)intToBytes:(char *)output input:(int)input;

/*!
 * @brief <code>long long</code> 型转字节数组。
 * @param[out] output 输出字节数组，长度 8 字节。
 * @param[in] input 输入 <code>long long</code> 数据。
 * @return 返回数组长度。
 */
+ (unsigned int)longToBytes:(char *)output input:(long long)input;

/*!
 * @brief @c float 型转字节数组。
 * @param[out] output 输出字节数组，长度 4 字节。
 * @param[in] input 输入 @c float 数据。
 * @return 返回数组长度。
 */
+ (unsigned int)floatToBytes:(char *)output input:(float)input;

/*!
 * @brief @c double 型转字节数组。
 * @param[out] output 输出字节数组，长度 8 字节。
 * @param[in] input 输入 @c double 数据。
 * @return 返回数组长度。
 */
+ (unsigned int)doubleToBytes:(char *)output input:(double)input;

/*!
 * @brief @c BOOL 型转字节数组。
 * @param[out] output 输出字节数组，长度 1 字节。
 * @param[in] input 输入 @c BOOL 数据。
 * @return 返回数组长度。
 */
+ (unsigned int)boolToBytes:(char *)output input:(BOOL)input;

/*!
 * @brief 字符串型转字节数组。
 * @param[out] output 输出字节数组。
 * @param[in] input 输入字符串数据。
 * @return 返回数组长度。
 */
+ (unsigned int)stringToBytes:(char *)output input:(NSString *)input;

/*!
 * @brief 字节数组转 @c short 型。
 * @param input 输入数据。
 * @return 返回 @c short 值。
 */
+ (short)bytesToShort:(char *)input;

/*!
 * @brief 字节数组 @c int 型。
 * @param input 输入数据。
 * @return 返回 @c int 值。
 */
+ (int)bytesToInt:(char *)input;

/*!
 * @brief 字节数组转 <code>long long</code> 型。
 * @param input 输入数据。
 * @return 返回 <code>long long</code> 值。
 */
+ (long long)bytesToLong:(char *)input;

/*!
 * @brief 字节数组转 @c float 型。
 * @param input 输入数据。
 * @return 返回 @c float 值。
 */
+ (float)bytesToFloat:(char *)input;

/*!
 * @brief 字节数组转 @c double 型。
 * @param input 输入数据。
 * @return 返回 @c double 值。
 */
+ (double)bytesToDouble:(char *)input;

/*!
 * @brief 字节数组转 @c BOOL 型。
 * @param input 输入数据。
 * @return 返回 @c BOOL 值。
 */
+ (BOOL)bytesToBool:(char *)input;

/*!
 * @brief ZIP 算法压缩数据。
 * @param[out] output 压缩后的数据。
 * @param[in] input 输入需压缩的数据。
 * @param[in] length 输入数据的长度。
 * @return 返回压缩后的数据长度。
 */
+ (NSUInteger)compress:(CellByteBuffer *)output input:(char *)input length:(int)length;

/*!
 * @brief ZIP 算法解压数据。
 * @param[out] output 解压后的数据。
 * @param[in] input 输入需解压的数据。
 * @param[in] length 输入数据的长度。
 * @return 返回解压后的数据长度。
 */
+ (NSUInteger)uncompress:(CellByteBuffer *)output input:(char *)input length:(int)length;

@end
