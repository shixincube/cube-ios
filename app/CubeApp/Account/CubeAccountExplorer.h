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

#ifndef CubeAccountExplorer_h
#define CubeAccountExplorer_h

#import <UIKit/UIKit.h>

/*!
 * 状态码。
 */
typedef NS_ENUM(NSInteger, CubeAccountStateCode) {
    /*! 成功。 */
    CubeAccountStateCodeSuccess = 0,
    
    /*! 重复的账号操作行为。 */
    CubeAccountStateCodeRepeat = 1,
    
    /*! 找不到用户。 */
    CubeAccountStateCodeNotFindAccount = 5,
    
    /*! 无效的令牌。 */
    CubeAccountStateCodeInvalidToken = 6,
    
    /*! 找不到令牌。 */
    CubeAccountStateCodeNotFindToken = 7,
    
    /*! 无效账号。 */
    CubeAccountStateCodeInvalidAccount = 8,
    
    /*! 数据错误。 */
    CubeAccountStateCodeDataError = 9,
    
    /*! 其他状态。 */
    CubeAccountStateCodeOther = 99
};

@interface CubeAccountExplorer : NSObject

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

@end

#endif /* CubeAccountExplorer_h */
