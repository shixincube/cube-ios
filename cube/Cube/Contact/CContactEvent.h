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

#ifndef CContactEvent_h
#define CContactEvent_h

#import <Foundation/Foundation.h>

/*
 * @brief 联系人模块的事件。
 */

/*! 当前客户端的联系人签入。 */
extern NSString * CContactEventSignIn;

/*! 当前客户端的联系人签出。 */
extern NSString * CContactEventSignOut;

/*! 当前客户端的联系人恢复连接。 */
extern NSString * CContactEventComeback;

/*! 当前客户端的联系人数据就绪。该事件依据网络连通情况和签入账号情况可能被多次触发。 */
extern NSString * CContactEventSelfReady;

/*! 群组已更新。 */
extern NSString * CContactEventGroupUpdated;

/*! 群组被创建。 */
extern NSString * CContactEventGroupCreated;

/*! 群组已解散。 */
extern NSString * CContactEventGroupDissolved;

/*! 群成员加入。 */
extern NSString * CContactEventGroupMemberAdded;

/*! 群成员移除。 */
extern NSString * CContactEventGroupMemberRemoved;

/*! 群组的附录进行了实时更新。 */
extern NSString * CContactEventGroupAppendixUpdated;

/*! 遇到程序故障。 */
extern NSString * CContactEventFault;

/*! 未知事件。 */
extern NSString * CContactEventUnknown;

#endif /* CContactEvent_h */
