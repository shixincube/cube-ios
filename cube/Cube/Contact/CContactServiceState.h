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

#ifndef CContactServiceState_h
#define CContactServiceState_h

/*!
 * @brief 联系人服务状态码。
 */
typedef enum _CContactServiceState {
    
    /*! 成功。 */
    Ok = 0,
    
    /*! 无效的参数。 */
    InvalidParameter = 5,
    
    /*! 数据结构错误。 */
    DataStructureError = 8,
    
    /*! 遇到故障。 */
    Failure = 9,
    
    /*! 无效域信息。 */
    InvalidDomain = 11,
    
    /*! 未签入联系人。 */
    NoSignIn = 12,
    
    /*! 未找到群组。 */
    NotFindGroup = 15,
    
    /*! 令牌不一致。 */
    InconsistentToken = 21,
    
    /*! 不被接受的非法操作。 */
    IllegalOperation = 25,
    
    /*! 服务器错误。 */
    ServerError = 101,
    
    /*! 不被允许的操作。 */
    NotAllowed = 102,
    
    /*! 未知的状态。 */
    Unknown = 99
    
} CContactServiceState

#endif /* CContactServiceState_h */
