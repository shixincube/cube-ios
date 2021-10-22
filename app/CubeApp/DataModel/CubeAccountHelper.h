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

#ifndef CubeAccountHelper_h
#define CubeAccountHelper_h

#import <Foundation/Foundation.h>
#import "CubeExplorer.h"

@class CubeAccount;
@class CSelf;

/*!
 * @brief 用于管理账号本地数据的辅助库。
 */
@interface CubeAccountHelper : NSObject <CContactEventDelegate>

@property (nonatomic, strong, readonly) NSString * defaultAvatarImageName;

@property (nonatomic, strong, readonly) CubeExplorer * explorer;

@property (nonatomic, strong, readonly) NSString * tokenCode;

@property (nonatomic, assign, readonly) NSUInteger tokenExpireTime;

@property (nonatomic, strong) CubeAccount * currentAccount;

@property (nonatomic, strong) NSDictionary * engineConfig;

@property (nonatomic, strong) CSelf * owner;

+ (CubeAccountHelper *)sharedInstance;

- (void)saveToken:(NSString *)code tokenExpireTime:(NSUInteger)expireTime;

- (BOOL)checkValidToken;

/*!
 * @brief 注入引擎相关的事件。
 * 当联系人模块需要获取联系人详情的 context 数据时，Helper 使用 Explorer 访问应用服务器将联系人数据写入到魔方引擎。
 * Helper 将代理 CContactEventDelegate 里的方法。
 */
- (void)injectEngineEvent;

- (void)getBuildinAccounts:(void(^)(NSArray<__kindof CubeAccount *> * accountList))handler;

/*!
 * @brief 解释头像名为头像文件名。
 */
+ (NSString *)explainAvatar:(NSString *)avatarName;

@end

#endif /* CubeAccountHelper_h */
