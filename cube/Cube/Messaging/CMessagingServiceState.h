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

#ifndef CMessagingServiceState_h
#define CMessagingServiceState_h

/*!
 * @brief 消息服务状态码。
 */
typedef enum _CMessagingServiceState {

    /*! 成功。 */
    CMessagingServiceStateOk = 0,

    /*! 无效参数。 */
    CMessagingServiceStateInvalidParameter = 5,

    /*! 遇到故障。 */
    CMessagingServiceStateFailure = 9,

    /*! 无效域信息。 */
    CMessagingServiceStateInvalidDomain = 11,

    /*! 数据结构错误。 */
    CMessagingServiceStateDataStructureError = 12,

    /*! 没有域信息。 */
    CMessagingServiceStateNoDomain = 13,

    /*! 没有设备信息。 */
    CMessagingServiceStateNoDevice = 14,

    /*! 没有找到联系人。 */
    CMessagingServiceStateNoContact = 15,

    /*! 没有找到群组。 */
    CMessagingServiceStateNoGroup = 16,

    /*! 附件错误。 */
    CMessagingServiceStateAttachmentError = 17,

    /*! 群组错误。 */
    CMessagingServiceStateGroupError = 18,

    /*! 被对方阻止。 */
    CMessagingServiceStateBeBlocked = 30,

    /*! 禁止操作。 */
    CMessagingServiceStateForbidden = 101,

    /*! 不能被执行的操作。 */
    CMessagingServiceStateIllegalOperation = 103,

    /*! 数据超时。 */
    CMessagingServiceStateDataTimeout = 104,

    /*! 服务器故障。 */
    CMessagingServiceStateServerFault = 105,

    /*! 存储里没有读取到数据。 */
    CMessagingServiceStateStorageNoData = 106,

    /*! 数据管道故障。 */
    CMessagingServiceStatePipelineFault = 107,

    /*! 未知的状态。 */
    CMessagingServiceStateUnknown = 99

} CMessagingServiceState;

#endif /* CMessagingServiceState_h */
