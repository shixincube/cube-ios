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

#ifndef CHook_h
#define CHook_h

#import <Foundation/Foundation.h>

@class CPluginSystem;

/*!
 * @brief 事件钩子。
 */
@interface CHook : NSObject

/*! 插件系统。 */
@property (nonatomic, weak) CPluginSystem * system;

/*! 钩子的事件名。 */
@property (nonatomic, strong, readonly) NSString * name;

/*!
 * @brief 使用触发的事件名初始化。
 * @param name 触发的事件名。
 * @return 返回 @c CHook 实例。
 */
- (instancetype)initWithName:(NSString *)name;

/*!
 * @brief 触发钩子，从系统里找到对应的插件进行数据处理，并返回处理后的数据。
 * @param data 指定触发事件时的数据。
 * @return 返回处理后的数据。
 */
- (id)apply:(id)data;

@end

#endif /* CHook_h */
