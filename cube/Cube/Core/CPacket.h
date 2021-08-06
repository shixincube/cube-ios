/**
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

#ifndef CPacket_h
#define CPacket_h

#import <Foundation/Foundation.h>
#import "CStateCode.h"

@interface CPacket : NSObject

/*! @brief 数据包包名。 */
@property (nonatomic, strong) NSString * name;

/*! @brief 数据包负载数据。 */
@property (nonatomic, strong) NSDictionary * data;

/*! @brief 数据包序号。 */
@property (nonatomic, assign) UInt64 sn;

/*! @brief 数据包应答状态。 */
@property (nonatomic, strong) CPipelineState * state;

/*!
 * @brief 指定数据包名和数据初始化。
 */
- (instancetype)initWithName:(NSString *)name andData:(NSDictionary *)data;

/*!
 * @brief 指定数据包名和数据初始化。
 */
- (instancetype)initWithName:(NSString *)name andData:(NSDictionary *)data andSN:(UInt64)sn;

/*!
 * @brief 提取包负载的状态码。
 */
- (int)extractStateCode;

/*!
 * @brief 提取包负载的数据。
 */
- (NSDictionary *)extractData;

@end

#endif /* CPacket_h */
