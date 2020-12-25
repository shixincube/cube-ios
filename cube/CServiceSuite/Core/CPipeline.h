/**
* This file is part of Cube.
*
* The MIT License (MIT)
*
* Copyright (c) 2020 Shixin Cube Team.
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


#import <Foundation/Foundation.h>
#import "CPacket.h"

//NS_ASSUME_NONNULL_BEGIN

/*
 * pipeline 约束了管道的行为，name、address、port是必要属性，使用name区分及获取管道，address及port为管道的连接地址
 管道内部维护了监听器集合，通过send方法发送packet到管道，通过triggerListener触发管道接收的packet
 */

@class CPipeline;

@protocol CPipelineListener <NSObject>

@optional

- (void)onReceived:(CPipeline *)pipeline source:(NSString *)source packet:(CPacket *)packet;

- (void)onError:(NSError *)error;

@end


/*
 * 这里暴露了一些业务层不需要调用的api，TODO: 内部隐藏这些api使其透明
 */

@interface CPipeline : NSObject

/// 获取管道name
@property (nonatomic , copy ,readonly) NSString *name;

/// 获取管道address
@property (nonatomic , copy,readonly) NSString *address;

/// 获取管道port
@property (nonatomic , assign,readonly) NSUInteger port;

/// 获取管道的状态
@property (nonatomic , assign ,readonly) BOOL isReady;

//
@property (nonatomic , copy) NSString *tokenCode;


- (instancetype)initWithName:(NSString *)name;

- (void)addListener:(NSString *)destination listener:(id<CPipelineListener>)listener;

- (void)removeListener:(NSString *)destination listener:(id<CPipelineListener>)listener;

- (__kindof NSArray<id<CPipelineListener>> *)getListener:(NSString *)destination;

- (void)setRemoteAddress:(NSString *)address port:(NSUInteger)port;

- (void)triggerListener:(NSString *)source packet:(CPacket *)packet;

- (void)triggerCallBack:(NSString *)source packet:(CPacket *)packet callback:(void(^)(CPacket *))callback;

@end

@interface CPipeline (SubClassHook)

- (void)open;

- (void)close;

- (void)send:(NSString *)destination packet:(CPacket *)packet response:(void(^)(CPacket *packet))response;

@end

//NS_ASSUME_NONNULL_END
