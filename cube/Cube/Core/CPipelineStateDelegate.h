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

#ifndef CPipelineStateDelegate_h
#define CPipelineStateDelegate_h

#import <Foundation/Foundation.h>

@class CKernel;
@class CError;

/*!
 * @brief 数据通道状态代理。
 */
@protocol CPipelineStateDelegate <NSObject>

@optional

/*!
 * @brief 当管道与服务器建立连接时回调。
 * @param kernel 引擎内核对象。
 */
- (void)pipelineOpened:(CKernel *)kernel;

/*!
 * @brief 当管道与服务器关闭连接时回调。
 * @param kernel 引擎内核对象。
 */
- (void)pipelineClosed:(CKernel *)kernel;

/*!
 * @brief 当管道发生故障时回调。
 * @param error 发生故障时的故障数据。
 * @param kernel 引擎内核对象。
 */
- (void)pipelineFaultOccurred:(CError *)error kernel:(CKernel *)kernel;

@end

#endif /* CPipelineStateDelegate_h */
