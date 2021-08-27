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

#ifndef CModule_h
#define CModule_h

#import "CSubject.h"

@class CKernel;
@class CPipeline;
@class CError;

/*! 回调错误事件的 Block 定义。 */
typedef void (^CubeFailureBlock)(CError * _Nonnull error);

/*!
 * @brief 内核模块。
 */
@interface CModule : CSubject

/*! @brief 模块名。 */
@property (nonatomic, nonnull, strong) NSString * name;

/*! @brief 内核。 */
@property (nonatomic, nullable, strong) CKernel * kernel;

/*! @brief 模块使用的默认数据管道。 */
@property (nonatomic, nullable, strong) CPipeline * pipeline;

/*!
 * @brief 使用模块名初始化。
 * @param name 模块名。
 * @return 模块实例。
 */
- (instancetype _Nonnull)initWithName:(NSString * _Nonnull)name;

/*!
 * @brief 是否已启动过该模块。
 * @return 如果已启动返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)hasStarted;

/*!
 * @brief 启动模块。
 * @return 返回 @c FALSE 表示模块不再需要执行启动流程。
 */
- (BOOL)start;

/*!
 * @brief 停止模块。
 */
- (void)stop;

/*!
 * @brief 挂起模块。
 */
- (void)suspend;

/*!
 * @brief 恢复模块。
 */
- (void)resume;

/*!
 * @brief 模块是否就绪。
 * @return 如果模块就绪返回 @c TRUE  。
 */
- (BOOL)isReady;

@end

#endif /* CModule_h */
