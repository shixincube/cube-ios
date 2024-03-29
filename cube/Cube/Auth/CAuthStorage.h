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

#ifndef CAuthStorage_h
#define CAuthStorage_h

#import <Foundation/Foundation.h>
#import "CAuthToken.h"

/*!
 * @brief 授权模块存储器。
 */
@interface CAuthStorage : NSObject

/*!
 * @brief 开启存储器。
 * @return 返回是否成功开启。
 */
- (BOOL)open;

/*!
 * @brief 关闭存储器。
 */
- (void)close;

/*!
 * @brief 加载指定域的令牌。
 * @param domain 指定域。
 * @param appKey 指定 App Key 。
 * @return 返回令牌实例。
 */
- (CAuthToken *)loadTokenWithDomain:(NSString *)domain appKey:(NSString *)appKey;

/*!
 * @brief 加载指定联系人的令牌。
 * @param contactId 指定联系人 ID 。
 * @param domain 指定域。
 * @param appKey 指定 App Key 。
 * @return 返回令牌实例。
 */
- (CAuthToken *)loadTokenWithContactId:(UInt64)contactId domain:(NSString *)domain appKey:(NSString *)appKey;

/*!
 * @brief 保存令牌。
 * @param authToken 指定令牌。
 */
- (void)saveToken:(CAuthToken *)authToken;

/*!
 * @brief 更新令牌。
 * @param authToken 指定令牌。
 * @return 更新成功返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)updateToken:(CAuthToken *)authToken;

@end

#endif /* CAuthStorage_h */
