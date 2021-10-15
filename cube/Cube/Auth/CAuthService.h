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

#ifndef CAuthService_h
#define CAuthService_h

#ifndef CUBE_MODULE_AUTH
/*! @brief 模块名。 */
#define CUBE_MODULE_AUTH @"Auth"
#endif

#import "CModule.h"
#import "CAuthToken.h"
#import "CError.h"

/*!
 * @brief 授权服务。管理引擎的授权信息。
 */
@interface CAuthService : CModule

/*! @brief 当前使用的访问令牌。 */
@property (nonatomic, strong) CAuthToken * token;

- (instancetype)init;

/*!
 * @brief 校验当前的令牌是否有效。该方法先从本地获取本地令牌进行校验，如果本地令牌失效或者未找到本地令牌，则尝试从授权服务器获取有效的令牌。
 * @param domain 令牌对应的域。
 * @param appKey 令牌指定的 App Key 串。
 * @param handler 操作回调。
 */
- (void)check:(NSString *)domain appKey:(NSString *)appKey handler:(void(^)(CError * error, CAuthToken * token))handler;

/*!
 * @brief 加载令牌。
 * @param domain 指定域。
 * @param appKey 指定 App Key 数据。
 * @return 返回有效的令牌。
 */
- (CAuthToken *)checkLocalToken:(NSString *)domain appKey:(NSString *)appKey;

/*!
 * @brief 从服务器申请令牌。
 * @param domain 令牌对应的域。
 * @param appKey 令牌指定的 App Key 串。
 * @param handler 操作回调。
 */
- (void)applyToken:(NSString *)domain appKey:(NSString *)appKey handler:(void(^)(CError * error, CAuthToken * token))handler;

/*!
 * @brief 将当前令牌分配给指定的联系人。
 * @param contactId 指定联系人 ID 。
 * @return 返回令牌。
 */
- (CAuthToken *)allocToken:(UInt64)contactId;

/*!
 * @brief 获取当前配置的域。
 * @return 返回当前工作的域。
 */
+ (NSString *)domain;

@end

#endif /* CAuthService_h */
