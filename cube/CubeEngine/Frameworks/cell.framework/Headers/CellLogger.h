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
 * @brief 日志记录器。
 */
@interface CellLogger : NSObject

/*!
 * @brief 记录 DEBUG 等级日志。
 * @param format 格式化字符串。
 */
+ (void)d:(NSString *)format, ...;

/*!
 * @brief 记录 INFO 等级日志。
 * @param format 格式化字符串。
 */
+ (void)i:(NSString *)format, ...;

/*!
 * @brief 记录 WARNING 等级日志。
 * @param format 格式化字符串。
 */
+ (void)w:(NSString *)format, ...;

/*!
 * @brief 记录 ERROR 等级日志。
 * @param format 格式化字符串。
 */
+ (void)e:(NSString *)format, ...;

/*!
 * @brief 当前日志等级是否是 DEBUG 级别。
 * @return 如果当前日志等级是 DEBUG 级别返回 @c YES 。
 */
+ (BOOL)isDebugLevel;

@end
