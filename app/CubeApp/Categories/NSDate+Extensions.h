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

#ifndef NSDate_Extensions_h
#define NSDate_Extensions_h

#import <Foundation/Foundation.h>

@interface NSDate (Extensions)

#pragma mark - 基本时间参数

@property (nonatomic, assign, readonly) NSUInteger year;
@property (nonatomic, assign, readonly) NSUInteger month;
@property (nonatomic, assign, readonly) NSUInteger day;
@property (nonatomic, assign, readonly) NSUInteger hour;
@property (nonatomic, assign, readonly) NSUInteger minute;
@property (nonatomic, assign, readonly) NSUInteger second;

/*! @brief 星期。 */
@property (nonatomic, assign, readonly) NSUInteger weekday;

/*! @brief 当前月份的天数。 */
@property (nonatomic, assign, readonly) NSUInteger dayInMonth;

/*! @brief 是不是闰年。 */
@property (nonatomic, assign, readonly) BOOL isLeapYear;


#pragma mark - 日期格式化

/*! @brief YYYY年MM月dd日 */
- (NSString *)formatYMD;

/*! @brief 自定义分隔符，YYYY年MM月dd日 */
- (NSString *)formatYMDWithSeparate:(NSString *)separate;

/*! @brief MM月dd日 */
- (NSString *)formatMD;

/*! @brief 自定义分隔符 ，MM月dd日 */
- (NSString *)formatMDWithSeparate:(NSString *)separate;

/*! @brief HH:MM:SS */
- (NSString *)formatHMS;

/*! @brief HH:MM */
- (NSString *)formatHM;

/*! @brief 星期N */
- (NSString *)formatWeekday;

/*! @brief 月份 */
- (NSString *)formatMonth;

#pragma mark - 常用毫秒单位

- (UInt64)timeIntervalSince1970Mills;

@end

#endif /* NSDate_Extensions_h */
