/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Shixin Cube Team.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#ifndef CUtils_h
#define CUtils_h

#import <Foundation/Foundation.h>

/*!
 * @brief 辅助函数库。
 */
@interface CUtils : NSObject

/*!
 * @brief 获取当前时间快照的时间戳。
 * @return 返回自1970年到当前时间快照的毫秒计数表示的时间戳。
 */
+ (UInt64)currentTimeMillis;

/*!
 * @brief 将 JSON 格式字符串转为字典形式。
 * @param jsonString 指定 JSON 格式字符串。
 * @return 返回字典实例。
 */
+ (NSDictionary *)toJSONWithString:(NSString *)jsonString;

/*!
 * @brief 将字典形式 JSON 转为字符串形式。
 * @param json 指定字典形式。
 * @return 返回 JSON 格式的字符串。
 */
+ (NSString *)toStringWithJSON:(NSDictionary *)json;

@end

#endif /* CUtils_h */
