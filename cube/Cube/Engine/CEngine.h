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

#ifndef CEngine_h
#define CEngine_h

#import <Foundation/Foundation.h>

#import "../Core/CKernel.h"
#import "../Core/CError.h"
#import "../Auth/CAuthService.h"
#import "../Contact/CContactService.h"
#import "../Messaging/CMessagingService.h"

@interface CEngine : NSObject

/*!
 * @brief 获取引擎单例。
 * @return 返回魔方引擎的实例。
 */
+ (CEngine *)sharedInstance;

/*!
 * @brief 内核实例。
 */
@property (nonatomic, strong, readonly) NSString * version;

/*!
 * @brief 内核实例。
 */
@property (nonatomic, strong, readonly) CKernel * kernel;

/*!
 * @brief 启动魔方引擎。
 * @param config 内核配置。
 * @param success 启动成功回调函数。
 * @param failure 启动故障回调函数。
 */
- (void)start:(CKernelConfig *)config success:(void(^)(CEngine * engine))success failure:(void(^)(CError * error))failure;

/*!
 * @brief 停止魔方引擎。
 */
- (void)stop;

/*!
 * @brief 挂起魔方引擎。用于应用程序退到后台。
 */
- (void)suspend;

/*!
 * @brief 恢复魔方引擎。用于应用程序回到前台。
 */
- (void)resume;

/*!
 * @brief 是否已启动。
 * @return 引擎已启动返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)hasStarted;

- (CSelf *)signInWithId:(UInt64)contactId;

- (CSelf *)signInWithId:(UInt64)contactId andName:(NSString *)name andContext:(NSDictionary *)context;

/*!
 * @brief 获取联系人服务模块。
 * @return 返回联系人服务模块实例。
 */
- (CContactService *)getContactService;

/*!
 * @brief 获取消息服务模块。
 * @return 返回消息服务模块实例。
 */
- (CMessagingService *)getMessagingService;

@end

#endif /* CEngine_h */
