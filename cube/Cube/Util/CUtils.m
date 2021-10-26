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

#import "CUtils.h"

@implementation CUtils

+ (UInt64)currentTimeMillis {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000.0f;
    return [[NSNumber numberWithDouble:time] unsignedLongLongValue];
}

+ (NSDictionary *)toJSONWithString:(NSString *)jsonString {
    NSData * data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError * error = nil;
    NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data
                                                          options:NSJSONReadingMutableContainers
                                                            error:&error];
    return json;
}

+ (NSString *)toStringWithJSON:(NSDictionary *)json {
    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:json options:0 error:&error];
    NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return jsonString;
}

+ (NSString *)byteBufferToString:(CellByteBuffer *)buffer {
    char * buf = malloc(buffer.limit + 1);
    memset(buf, 0x0, buffer.limit + 1);
    memcpy(buf, [buffer bytes], buffer.limit);
    NSString * result = [NSString stringWithUTF8String:buf];
    free(buf);
    return result;
}

@end
