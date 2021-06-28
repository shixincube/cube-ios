/**
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

#ifndef CPipeline_h
#define CPipeline_h

#import <Foundation/Foundation.h>
#import "CPacket.h"

@class CPipeline;

/*!
 * @brief 数据通道服务事件代理。
 */
@protocol CPipelineDelegate <NSObject>

@required
- (void)didReceive:(CPipeline *)pipeline source:(NSString *)source packet:(CPacket *)packet;

@optional
- (void)didOpen:(CPipeline *)pipeline source:(NSString *)source packet:(CPacket *)packet;

@optional
- (void)didClose:(CPipeline *)pipeline source:(NSString *)source packet:(CPacket *)packet;

@optional
- (void)faultOccurred:(CPipeline *)pipeline code:(NSInteger)code;

@end


/*!
 * @brief 数据通道服务接口。
 */
@interface CPipeline : NSObject

@property (nonatomic, strong, readonly) NSString * name;

@property (nonatomic, strong) NSString * address;

@property (nonatomic, assign) NSInteger port;

@property (nonatomic, assign) id<CPipelineDelegate> delegate;

/*!
 * @brief 通过指定管道名称初始化。
 * @param name 指定管道名。
 */
- (id)initWith:(NSString *)name;

/*!
 * @brief 开启管道。
 */
- (void)open;

/*!
 * @brief 关闭管道。
 */
- (void)close;

/*!
 * @brief 数据通道是否就绪。
 * @return 如果就绪返回 @c true 。
 */
- (BOOL)isReady;

/*!
 * @brief 设置服务的地址和端口。
 * @param address 服务器访问地址。
 * @param port 服务器访问端口。
 */
- (void)setRemoteAddress:(NSString *)address withPort:(NSInteger)port;

@end

#endif /* CPipeline_h */
