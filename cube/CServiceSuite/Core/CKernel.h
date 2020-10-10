//
//  CKernel.h
//  CServiceSuite
//
//  Created by Ashine on 2020/9/1.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CCore.h"
#import "CCellPipeLine.h"

NS_ASSUME_NONNULL_BEGIN


@interface CKernelConfig : NSObject

@property (nonatomic , copy) NSString *domain;

@property (nonatomic , copy) NSString *address;

@property (nonatomic , copy) NSString *appKey;

@property (nonatomic , assign) BOOL pipelineReady;

@end

@interface CKernel : NSObject

/// 获取kernel实例
+ (instancetype)shareKernel;

- (void)startUp:(CKernelConfig *)config completion:(void(^)(void))completion failure:(void(^)(void))failure;

- (void)shutdown;

- (void)suspend;

- (void)resume;


/// 安装管道
/// @param pipeline pipeline
- (void)installPipeline:(CPipeline *)pipeline;

/// 卸载管道
/// @param pipeline pipeline
- (void)uninstallPipeline:(CPipeline *)pipeline;

/// 获取管道
/// @param pipelineName pipelineName
- (CPipeline *)getPipeline:(NSString *)pipelineName;

/// 安装模块
/// @param module module
- (void)installModule:(CModule *)module;

/// 卸载模块
/// @param module module
- (void)uninstallModule:(CModule *)module;

/// 获取module
/// @param moduleName moduleName
- (CModule *)getModule:(NSString *)moduleName;



@end

NS_ASSUME_NONNULL_END
