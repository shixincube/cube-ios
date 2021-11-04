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

#ifndef CSelf_h
#define CSelf_h

#import "CContact.h"

@class CDevice;

/*!
 * @brief 用户描述自己的账号。
 */
@interface CSelf : CContact

/*! 当前设备。 */
@property (nonatomic, strong, readonly) CDevice * device;

/*!
 * @brief 初始化。
 * @param identity 指定联系人 ID 。
 * @param name 指定名称。
 * @return 返回 @c CSelf 实例。
 */
- (instancetype)initWithId:(UInt64)identity name:(NSString *)name;

/*!
 * @brief 初始化。
 * @param identity 指定联系人 ID 。
 * @param name 指定名称。
 * @param context 指定上下文数据。
 * @return 返回 @c CSelf 实例。
 */
- (instancetype)initWithId:(UInt64)identity name:(NSString *)name context:(NSDictionary *)context;

/*!
 * @brief 初始化。
 * @param json 指定 JSON 格式的数据 。
 * @return 返回实例。
 */
- (instancetype)initWithJSON:(NSDictionary *)json;

- (void)updateWithJSON:(NSDictionary *)json;

@end

#endif /* CSelf_h */
