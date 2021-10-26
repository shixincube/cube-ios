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

#ifndef CContactServiceState_h
#define CContactServiceState_h

/*!
 * @brief 联系人服务状态码。
 */
typedef enum _CContactServiceState {

    /*! 成功。 */
    CContactServiceStateOk = 0,

    /*! 无效的参数。 */
    CContactServiceStateInvalidParameter = 5,

    /*! 数据结构错误。 */
    CContactServiceStateDataStructureError = 8,

    /*! 遇到故障。 */
    CContactServiceStateFailure = 9,

    /*! 无效域信息。 */
    CContactServiceStateInvalidDomain = 11,

    /*! 未签入联系人。 */
    CContactServiceStateNoSignIn = 12,
    
    /*! 未找到联系人。 */
    CContactServiceStateNotFindContact = 14,

    /*! 未找到群组。 */
    CContactServiceStateNotFindGroup = 15,

    /*! 未找到联系人分区。 */
    CContactServiceStateNotFindContactZone = 16,

    /*! 令牌不一致。 */
    CContactServiceStateInconsistentToken = 21,

    /*! 不被接受的非法操作。 */
    CContactServiceStateIllegalOperation = 25,

    /*! 服务器错误。 */
    CContactServiceStateServerError = 101,

    /*! 不被允许的操作。 */
    CContactServiceStateNotAllowed = 102,

    /*! 无网络连接。 */
    CContactServiceStateNoNetwork = 103,

    /*! 未知的状态。 */
    CContactServiceStateUnknown = 99

} CContactServiceState;

#endif /* CContactServiceState_h */
