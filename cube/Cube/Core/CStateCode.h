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

#ifndef CStateCode_h
#define CStateCode_h

#import <Foundation/Foundation.h>

/*!
 * @brief 状态码。
 */
typedef enum _CStateCode {
    /*!
     * @brief 成功。
     */
    CStateOk = 1000,

    /*!
     * @brief 数据请求错误。
     */
    CStateBadRequest = 1400,

    /*!
     * @brief 未知的请求命令。
     */
    CStateNotFound = 1404,

    /*!
     * @brief 没有找到授权码。
     */
    CStateNoAuthToken = 1501,

    /*!
     * @brief 请求服务超时。
     */
    CStateServiceTimeout = 2001,

    /*!
     * @brief 负载格式错误。
     */
    CStatePayloadFormat = 2002,

    /*!
     * @brief 参数错误。
     */
    CStateInvalidParameter = 2003,

    /*!
     * @brief 网关错误。
     */
    CStateGatewayError = 2101

} CStateCode;

/*!
 * @brief 通道状态描述。
 */
@interface CPipelineState : NSObject

/*! @brief 状态码。  */
@property (nonatomic, assign) CStateCode code;

/*! @brief 状态描述。  */
@property (nonatomic, strong) NSString * desc;


- (instancetype)initWithCode:(CStateCode)code desc:(NSString *)desc;

@end

#endif /* CStateCode_h */
