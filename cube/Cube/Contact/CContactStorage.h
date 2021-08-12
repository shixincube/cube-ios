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

#ifndef CContactStorage_h
#define CContactStorage_h

#import "CContact.h"

/*!
 * @brief 联系人模块存储器。
 */
@interface CContactStorage : NSObject

/*!
 * @brief 初始化。
 */
- (instancetype)init;

/*!
 * @brief 开启存储器。
 * @param contactId 指定联系人 ID 。
 * @param domain 指定域。
 * @return 开启成功返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)open:(UInt64)contactId domain:(NSString *)domain;

/*!
 * @brief 关闭存储器。
 */
- (void)close;


- (CContact *)readContact:(UInt64)contactId;

@end

#endif /* CContactStorage_h */
