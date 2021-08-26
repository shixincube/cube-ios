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

#ifndef CMessageState_h
#define CMessageState_h

/*!
 * @brief 消息状态。
 */
typedef enum _CMessageState {
    
    /*!
     * @brief 未知。
     */
    CMessageStateUnknown = 0,
    
    /*!
     * @brief 未发送。
     */
    CMessageStateUnsent = 5,
    
    /*!
     * @brief 发送中。
     */
    CMessageStateSending = 9,
    
    /*!
     * @brief 已发送。
     */
    CMessageStateSent = 10,
    
    /*!
     * @brief 已读。
     */
    CMessageStateRead = 20,
    
    /*!
     * @brief 已撤回。
     */
    CMessageStateRecalled = 30,
    
    /*!
     * @brief 已删除。
     */
    CMessageStateDeleted = 40,
    
    /*!
     * @brief 被阻止发送。
     */
    CMessageStateSendBlocked = 51,
    
    /*!
     * @brief 被阻止接收。
     */
    CMessageStateReceiveBlocked = 52,
    
    /*!
     * @brief 消息出现故障。
     */
    CMessageStateFault = 1

} CMessageState;

#endif /* CMessageState_h */
