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

#import "NSDate+Extensions.h"

@implementation NSDate (Extensions)

#pragma mark - 基本时间参数
- (NSUInteger)year {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitYear) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSYearCalendarUnit) fromDate:self];
#endif
    return [dayComponents year];
}

- (NSUInteger)month {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMonth) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMonthCalendarUnit) fromDate:self];
#endif
    return [dayComponents month];
}

- (NSUInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitDay) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSDayCalendarUnit) fromDate:self];
#endif
    return [dayComponents day];
}


- (NSUInteger)hour {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitHour) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSHourCalendarUnit) fromDate:self];
#endif
    return [dayComponents hour];
}

- (NSUInteger)minute {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitMinute) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSMinuteCalendarUnit) fromDate:self];
#endif
    return [dayComponents minute];
}

- (NSUInteger)second {
    NSCalendar *calendar = [NSCalendar currentCalendar];
#if __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_8_0
    NSDateComponents *dayComponents = [calendar components:(NSCalendarUnitSecond) fromDate:self];
#else
    NSDateComponents *dayComponents = [calendar components:(NSSecondCalendarUnit) fromDate:self];
#endif
    return [dayComponents second];
}

- (NSUInteger)weekday {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:(NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday) fromDate:self];
    NSInteger weekday = [comps weekday] - 1;
    weekday = weekday == 0 ? 7 : weekday;
    return weekday;
}

- (NSUInteger)dayInMonth {
    switch (self.month) {
        case 1: case 3: case 5: case 7: case 8: case 10: case 12:
            return 31;
        case 2:
            return self.isLeapYear ? 29 : 28;
    }
    return 30;
}

- (BOOL)isLeapYear {
    if ((self.year % 4  == 0 && self.year % 100 != 0) || self.year % 400 == 0) {
        return YES;
    }
    return NO;
}

#pragma mark - 日期格式化

- (NSString *)formatYMD {
    return [NSString stringWithFormat:@"%lu年%02lu月%02lu日", (unsigned long)self.year, (unsigned long)self.month, (unsigned long)self.day];
}

- (NSString *)formatYMDWithSeparate:(NSString *)separate {
    return [NSString stringWithFormat:@"%lu%@%02lu%@%02lu", (unsigned long)self.year, separate, (unsigned long)self.month, separate, (unsigned long)self.day];
}

- (NSString *)formatMD {
    return [NSString stringWithFormat:@"%02lu月%02lu日", (unsigned long)self.month, (unsigned long)self.day];
}

- (NSString *)formatMDWithSeparate:(NSString *)separate {
    return [NSString stringWithFormat:@"%02lu%@%02lu", (unsigned long)self.month, separate, (unsigned long)self.day];
}

- (NSString *)formatHMS {
    return [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)self.hour, (unsigned long)self.minute, (unsigned long)self.second];
}

- (NSString *)formatHM {
    return [NSString stringWithFormat:@"%02lu:%02lu", (unsigned long)self.hour, (unsigned long)self.minute];
}

- (NSString *)formatWeekday {
    switch([self weekday]) {
        case 1:
            return NSLocalizedString(@"星期一", nil);
        case 2:
            return NSLocalizedString(@"星期二", nil);
        case 3:
            return NSLocalizedString(@"星期三", nil);
        case 4:
            return NSLocalizedString(@"星期四", nil);
        case 5:
            return NSLocalizedString(@"星期五", nil);
        case 6:
            return NSLocalizedString(@"星期六", nil);
        case 7:
            return NSLocalizedString(@"星期天", nil);
        default:
            break;
    }
    return @"";
}

- (NSString *)formatMonth {
    switch(self.month) {
        case 1:
            return NSLocalizedString(@"一月", nil);
        case 2:
            return NSLocalizedString(@"二月", nil);
        case 3:
            return NSLocalizedString(@"三月", nil);
        case 4:
            return NSLocalizedString(@"四月", nil);
        case 5:
            return NSLocalizedString(@"五月", nil);
        case 6:
            return NSLocalizedString(@"六月", nil);
        case 7:
            return NSLocalizedString(@"七月", nil);
        case 8:
            return NSLocalizedString(@"八月", nil);
        case 9:
            return NSLocalizedString(@"九月", nil);
        case 10:
            return NSLocalizedString(@"十月", nil);
        case 11:
            return NSLocalizedString(@"十一月", nil);
        case 12:
            return NSLocalizedString(@"十二月", nil);
        default:
            break;
    }
    return @"";
}

- (UInt64)timeIntervalSince1970Mills {
    return (UInt64)([self timeIntervalSince1970] * 1000.0f);
}

@end
