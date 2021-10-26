/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Cube Team.
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

#ifndef NSDate_Relation_h
#define NSDate_Relation_h

#import <Foundation/Foundation.h>

@interface NSDate (Relation)

#pragma mark - 日期关系
- (BOOL)isSameDay:(NSDate *)aDate;
@property (nonatomic, assign, readonly) BOOL isToday;
@property (nonatomic, assign, readonly) BOOL isTomorrow;
@property (nonatomic, assign, readonly) BOOL isYesterday;

- (BOOL)isSameWeekAsDate:(NSDate *)aDate;
@property (nonatomic, assign, readonly) BOOL isThisWeek;
@property (nonatomic, assign, readonly) BOOL isNextWeek;
@property (nonatomic, assign, readonly) BOOL isLastWeek;

- (BOOL)isSameMonthAsDate:(NSDate *)aDate;
@property (nonatomic, assign, readonly) BOOL isThisMonth;
@property (nonatomic, assign, readonly) BOOL isNextMonth;
@property (nonatomic, assign, readonly) BOOL isLastMonth;

- (BOOL)isSameYearAsDate:(NSDate *)aDate;
@property (nonatomic, assign, readonly) BOOL isThisYear;
@property (nonatomic, assign, readonly) BOOL isNextYear;
@property (nonatomic, assign, readonly) BOOL isLastYear;

- (BOOL)isEarlierThanDate:(NSDate *)aDate;
- (BOOL)isLaterThanDate:(NSDate *)aDate;
@property (nonatomic, assign, readonly) BOOL isInFuture;
@property (nonatomic, assign, readonly) BOOL isInPast;

@property (nonatomic, assign, readonly) BOOL isTypicallyWorkday;
@property (nonatomic, assign, readonly) BOOL isTypicallyWeekend;

#pragma mark - 间隔日期
+ (NSDate *)dateTomorrow;
+ (NSDate *)dateYesterday;
+ (NSDate *)dateWithDaysFromNow:(NSInteger)days;
+ (NSDate *)dateWithDaysBeforeNow:(NSInteger)days;
+ (NSDate *)dateWithHoursFromNow:(NSInteger)hours;
+ (NSDate *)dateWithHoursBeforeNow:(NSInteger)hours;
+ (NSDate *)dateWithMinutesFromNow:(NSInteger)minutes;
+ (NSDate *)dateWithMinutesBeforeNow:(NSInteger)minutes;

#pragma mark - 日期加减
- (NSDate *)dateByAddingYears:(NSInteger)years;
- (NSDate *)dateBySubtractingYears:(NSInteger)years;
- (NSDate *)dateByAddingMonths:(NSInteger)months;
- (NSDate *)dateBySubtractingMonths:(NSInteger)months;
- (NSDate *)dateByAddingDays:(NSInteger)days;
- (NSDate *)dateBySubtractingDays:(NSInteger)days;
- (NSDate *)dateByAddingHours:(NSInteger)hours;
- (NSDate *)dateBySubtractingHours:(NSInteger)hours;
- (NSDate *)dateByAddingMinutes:(NSInteger)minutes;
- (NSDate *)dateBySubtractingMinutes:(NSInteger)minutes;

#pragma mark - 日期间隔
- (NSInteger)minutesAfterDate:(NSDate *)aDate;
- (NSInteger)minutesBeforeDate:(NSDate *)aDate;
- (NSInteger)hoursAfterDate:(NSDate *)aDate;
- (NSInteger)hoursBeforeDate:(NSDate *)aDate;
- (NSInteger)daysAfterDate:(NSDate *)aDate;
- (NSInteger)daysBeforeDate:(NSDate *)aDate;
- (NSInteger)distanceInDaysToDate:(NSDate *)anotherDate;

@end

#endif /* NSDate_Relation_h */
