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

#ifndef CPluginSystem_h
#define CPluginSystem_h

#import "CHook.h"
#import "CPlugin.h"

/*!
 * @brief 插件系统。
 */
@interface CPluginSystem : NSObject

/*!
 * @brief 添加事件钩子。
 * @param hook 指定钩子实例。
 */
- (void)addHook:(CHook *)hook;

/*!
 * @brief 移除事件钩子。
 * @param hook 指定钩子实例。
 */
- (void)removeHook:(CHook *)hook;

/*!
 * @brief 获取指定事件名的钩子。
 * @param name 指定事件名。
 * @return 返回指定事件名的钩子。
 */
- (CHook *)getHook:(NSString *)name;

/*!
 * @brief 清空钩子。
 */
- (void)clearHooks;

/*!
 * @brief 注册插件。
 * @param name 钩子事件名。
 * @param plugin 插件实例。
 */
- (void)registerPlugin:(NSString *)name plugin:(id<CPlugin>)plugin;

/*!
 * @brief 注销插件。
 * @param name 钩子事件名。
 * @param plugin 插件实例。
 */
- (void)deregisterPlugin:(NSString *)name plugin:(id<CPlugin>)plugin;

/*!
 * @brief 清空插件。
 */
- (void)clearPlugins;


/*!
 * @brief 同步方式进行数据处理。
 * @param name 钩子名称。
 * @param data 待处理数据。
 * @return 返回处理后的数据。
 */
- (id)syncApply:(NSString *)name data:(id)data;

@end

#endif /* CPluginSystem_h */
