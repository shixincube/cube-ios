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

#ifndef CubeAccount_h
#define CubeAccount_h

#import <Foundation/Foundation.h>

@interface CubeAccount : NSObject

@property (nonatomic, assign, readonly) NSUInteger identity;

@property (nonatomic, strong, readonly) NSString * accountName;

@property (nonatomic, strong, readonly) NSString * phoneNumber;

@property (nonatomic, strong, readonly) NSString * displayName;

@property (nonatomic, strong, readonly) NSString * region;

@property (nonatomic, strong, readonly) NSString * avatar;

@property (nonatomic, assign, readonly) NSInteger state;

@property (nonatomic, assign, readonly) UInt64 localTimestamp;


+ (CubeAccount *)accountWithJSON:(NSDictionary *)json;

- (instancetype)initWithJSON:(NSDictionary *)accountJSON;

- (NSDictionary *)toJSON;

- (NSDictionary *)toDesensitizingJSON;

+ (NSString *)getAvatar:(NSDictionary *)json;

@end

#endif /* CubeAccount_h */
