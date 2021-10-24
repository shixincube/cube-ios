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

#ifndef CAbstractContact_h
#define CAbstractContact_h

#import "CEntity.h"

/*!
 * @brief 抽象联系人。
 */
@interface CAbstractContact : CEntity

/*! @brief 联系人名称。 */
@property (nonatomic, strong) NSString * name;

/*! @brief 联系人所属的域。 */
@property (nonatomic, strong) NSString * domain;

/*! @brief 自定义数据，为应用程序提供关联其他数据对象的属性。 */
@property (nonatomic, strong) id customData;


/*!
 * @brief 初始化抽象联系人。
 * @param identity 指定联系人 ID 。
 * @param name 指定联系人名称。
 * @param domain 指定联系人所在的域。
 * @return 返回对象实例。
 */
- (instancetype)initWithId:(UInt64)identity name:(NSString *)name domain:(NSString *)domain;

/*!
 * @brief 初始化抽象联系人。
 * @param identity 指定联系人 ID 。
 * @param name 指定联系人名称。
 * @param domain 指定联系人所在的域。
 * @param timestamp 指定时间戳。
 * @return 返回对象实例。
 */
- (instancetype)initWithId:(UInt64)identity name:(NSString *)name domain:(NSString *)domain timestamp:(UInt64)timestamp;

/*!
 * @brief 使用 JSON 数据初始化。
 * @param json 指定 JSON 数据结构。
 * @return 返回对象实例。
 */
- (instancetype)initWithJSON:(NSDictionary *)json;

@end

#endif /* CAbstractContact_h */
