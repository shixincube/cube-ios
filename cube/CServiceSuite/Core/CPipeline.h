//
//  CPipeline.h
//  CServiceSuite
//
//  Created by Ashine on 2020/9/1.
//  Copyright © 2020 Ashine. All rights reserved.
//

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
