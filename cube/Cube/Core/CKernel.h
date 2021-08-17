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

#ifndef CKernel_h
#define CKernel_h

#import <Foundation/Foundation.h>
#import "CModule.h"
#import "CError.h"
#import "../Auth/CAuthToken.h"

#ifndef CUBE_KERNEL_SC_NO_MODULE
#define CUBE_KERNEL_SC_NO_MODULE 300
#endif

#ifndef CUBE_KERNEL_SC_NO_TOKEN
#define CUBE_KERNEL_SC_NO_TOKEN 305
#endif


/*!
 * @brief 内核配置定义。
 */
@interface CKernelConfig : NSObject

/*!
 * @brief 管道服务器地址。
 */
@property (nonatomic, strong) NSString * address;

/*!
 * @brief 授权的指定域。
 */
@property (nonatomic, strong) NSString * domain;

/*!
 * @brief 当前应用申请到的 App Key 串。
 */
@property (nonatomic, strong) NSString * appKey;

/*!
 * @brief 管道服务器端口。
 */
@property (nonatomic, assign) NSUInteger port;

/*!
 * @brief 启动时不等待连接。
 */
@property (nonatomic, assign) BOOL unconnected;

/*!
 * @brief 内核是否等待通道就绪再回调。
 */
@property (nonatomic, assign) BOOL pipelineReady;

/*!
 * @brief 是否启用消息服务。
 */
@property (nonatomic, assign) BOOL enabledMessaging;

/*!
 * @brief 初始化。
 * @param address 指定服务器地址。
 * @param domain 指定所属域名称。
 * @param appKey 指定该 App 的 Key 串。
 */
- (instancetype)initWithAddress:(NSString *)address domain:(NSString *)domain appKey:(NSString *)appKey;

@end


/*!
 * @brief 内核。内核管理所有的模块和通信管道。
 */
@interface CKernel : NSObject

/*! @brief 有效的访问令牌。 */
@property (nonatomic, strong) CAuthToken * authToken;

/*! @brief 配置。 */
@property (nonatomic, strong, readonly) CKernelConfig * config;

/*!
 * @brief 启动内核。
 * @param config 配置信息。
 * @param completion 启动成功回调函数。
 * @param failure 启动失败回调函数。
 * @return 返回是否允许启动。
 */
- (BOOL)startup:(CKernelConfig *)config completion:(void(^)(void))completion
        failure:(void(^)(CError *))failure;

/*!
 * @brief 关闭内核。
 */
- (void)shutdown;

/*!
 * @brief 挂起内核。
 */
- (void)suspend;

/*!
 * @brief 恢复内核。
 */
- (void)resume;

/*!
 * @brief 是否就绪。
 * @return 返回是否就绪。
 */
- (BOOL)isReady;

/*!
 * @brief 安装模块。
 * @param module 指定待安装的模块。
 */
- (void)installModule:(CModule *)module;

/*!
 * @brief 卸载模块。
 * @param module 指定待卸载的模块。
 */
- (void)uninstallModule:(CModule *)module;

/*!
 * @brief 获取指定模块。
 * @param moduleName 指定模块名称。
 * @return 返回指定名称的模块，如果没有找到模块返回 @c nil 。
 */
- (CModule *)getModule:(NSString *)moduleName;

/*!
 * @brief 是否已经安装指定模块。
 * @param moduleName 指定模块名称。
 * @return 如果已经安装指定模块返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)hasModule:(NSString *)moduleName;

/*!
 * @brief 使用指定联系人 ID 绑定已生效的令牌。
 */
- (void)activeToken:(UInt64)contactId handler:(void(^)(CAuthToken *))handler;

@end

#endif /* CKernel_h */
