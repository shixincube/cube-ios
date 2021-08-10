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

#ifndef CEntity_h
#define CEntity_h

#import "CJSONable.h"

/*!
 * @brief 信息实体对象。所有实体对象的基类。
 */
@interface CEntity : CJSONable

/*! 实体 ID 。 */
@property (nonatomic, assign, readonly) UInt64 identity;

/*! 实体创建时的时间戳。 */
@property (nonatomic, assign, readonly) UInt64 timestamp;

/*! 实体的到期时间。 */
@property (nonatomic, assign, readonly) UInt64 expiry;

/*! 关联上下文数据。 */
@property (nonatomic, strong) NSMutableDictionary * context;


/*!
 * @brief 默认初始化。
 * @return 返回实体实例。
 */
- (instancetype)init;

/*!
 * @brief 使用 ID 初始化。
 * @param identity 指定实体 ID 。
 * @return 返回实体实例。
 */
- (instancetype)initWithId:(UInt64)identity;

/*!
 * @brief 使用 ID 和实体时间戳初始化。
 * @param identity 指定实体 ID 。
 * @param timestamp 指定时间戳。
 * @return 返回实体实例。
 */
- (instancetype)initWithId:(UInt64)identity timestamp:(UInt64)timestamp;

@end

#endif /* CEntity_h */
