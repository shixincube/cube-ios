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
    CSC_Ok = 1000,

    /*!
     * @brief 数据请求错误。
     */
    CSC_BadRequest = 1400,

    /*!
     * @brief 未知的请求命令。
     */
    CSC_NotFound = 1404,

    /*!
     * @brief 没有找到授权码。
     */
    CSC_NoAuthToken = 1501,

    /*!
     * @brief 请求服务超时。
     */
    CSC_ServiceTimeout = 2001,

    /*!
     * @brief 负载格式错误。
     */
    CSC_PayloadFormat = 2002,

    /*!
     * @brief 参数错误。
     */
    CSC_InvalidParameter = 2003,

    /*!
     * @brief 网关错误。
     */
    CSC_GatewayError = 2101

} CStateCode;

/*!
 * @brief 通道状态描述。
 */
@interface CPipelineState : NSObject

/*! @brief 状态码。  */
@property (nonatomic, assign) unsigned int code;

/*! @brief 状态描述。  */
@property (nonatomic, strong) NSString * desc;


- (instancetype)initWithCode:(unsigned int)code desc:(NSString *)desc;

@end

#endif /* CStateCode_h */
