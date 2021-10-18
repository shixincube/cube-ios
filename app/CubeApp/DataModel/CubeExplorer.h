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

#ifndef CubeExplorer_h
#define CubeExplorer_h

#import <UIKit/UIKit.h>

/*!
 * 状态码。
 */
typedef NS_ENUM(NSInteger, CubeStateCode) {
    /*! 成功。 */
    CubeStateCodeSuccess = 0,
    
    /*! 不被允许的行为。 */
    CubeStateCodeNotAllowed = 1,
    
    /*! 找不到用户。 */
    CubeStateCodeNotFindAccount = 5,
    
    /*! 无效的令牌。 */
    CubeStateCodeInvalidToken = 6,
    
    /*! 找不到令牌。 */
    CubeStateCodeNotFindToken = 7,
    
    /*! 无效账号。 */
    CubeStateCodeInvalidAccount = 8,
    
    /*! 数据错误。 */
    CubeStateCodeDataError = 9,
    
    /*! 其他状态。 */
    CubeStateCodeOther = 99
};


@interface CubeExplorer : NSObject

/*!
 * @brief 返回默认的账号头像。
 */
- (NSString *)defaultAvatar;

/*!
 * @brief 使用手机号码登录。
 */
- (void)loginWithPhoneNumber:(NSString *)phoneNumber
                    password:(NSString *)password
                     success:(CubeBlockRequestSuccessWithData)success
                     failure:(CubeBlockRequestFailureWithError)failure;

/*!
 * @brief 使用手机号码注册账号。
 */
- (void)registerWithPhoneNumber:(NSString *)phoneNumber
                       password:(NSString *)password
                       nickname:(NSString *)nickname
                         avatar:(NSString *)avatar
                        success:(CubeBlockRequestSuccessWithData)success
                        failure:(CubeBlockRequestFailureWithError)failure;

/*!
 * @brief 使用令牌获取账号数据。
 */
- (void)getAccountWithToken:(NSString *)tokenCode
                    success:(CubeBlockRequestSuccessWithData)success
                    failure:(CubeBlockRequestFailureWithError)failure;

/*!
 * @brief 使用账号 ID 获取账号数据。
 */
- (void)getAccountWithId:(NSUInteger)accountId
               tokenCode:(NSString *)tokenCode
                 success:(CubeBlockRequestSuccessWithData)success
                 failure:(CubeBlockRequestFailureWithError)failure;

/*!
 * @brief 获取引擎配置。
 */
- (void)getEngineConfigWithSuccess:(CubeBlockRequestSuccessWithData)success
                           failure:(CubeBlockRequestFailureWithError)failure;

/*!
 * @brief 获取内置的演示用的账号数据。
 */
- (void)getBuildinAccounts:(CubeBlockRequestSuccessWithData)success
                   failure:(CubeBlockRequestFailureWithError)failure;

@end

#endif /* CubeExplorer_h */
