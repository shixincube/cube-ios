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
 * @brief 内核标签。
 */
@interface CellNucleusTag : NSObject

/*!
 * @brief 使用随机 UUID 初始化标签。
 * @return 标签对象实例。
 */
- (id)initWithRandom;

/*!
 * @brief 根据 UUID 格式的字符串初始化标签。
 * @param uuid 字符串形式的 UUID 。
 * @return 标签对象实例。
 */
- (id)initWithString:(NSString *)uuid;

/*!
 * @brief 获取 UUID 的字符串形式。
 * @return 返回 UUID 的字符串形式。
 */
- (NSString *)getAsString;

/*!
 * @brief 返回 UUID 的字符串形式。
 * @param output 输出的数据数组。
 * @return 返回输出数组的长度。
 */
- (NSUInteger)getAsBytes:(char *) output;

@end
