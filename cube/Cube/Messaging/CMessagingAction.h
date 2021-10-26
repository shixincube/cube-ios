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

#ifndef CMessagingAction_h
#define CMessagingAction_h

/*!
 * @brief 向服务器发送消息。
 */
#define CUBE_MESSAGING_PUSH @"push"

/*!
 * @brief 从服务器拉取消息。
 */
#define CUBE_MESSAGING_PULL @"pull"

/*!
 * @brief 收到在线消息。
 */
#define CUBE_MESSAGING_NOTIFY @"notify"

/*!
 * @brief 撤回消息。
 */
#define CUBE_MESSAGING_RECALL @"recall"

/*!
 * @brief 删除消息。
 */
#define CUBE_MESSAGING_DELETE @"delete"

/*!
 * @brief 标记已读。
 */
#define CUBE_MESSAGING_READ @"read"

#endif /* CMessagingAction_h */
