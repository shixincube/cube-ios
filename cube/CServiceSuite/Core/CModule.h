//
//  CModule.h
//  CServiceSuite
//
//  Created by Ashine on 2020/9/1.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CSubject.h"
#import "CPluginSystem.h"
#import "CPipeline.h"

NS_ASSUME_NONNULL_BEGIN

@interface CModule : CSubject

@property (nonatomic , copy ,readonly) NSString *name;

/// 依赖模块
@property (nonatomic , strong ,readonly) NSArray <NSString *> *dependModules;

/// 依赖库
@property (nonatomic , copy ,readonly) NSString *dependLibs;

/// 插件系统
@property (nonatomic , strong,readonly) CPluginSystem *pluginSystem;


@property (nonatomic , weak) CPipeline *pipeline;


@property (nonatomic , assign,readonly) BOOL started;


- (instancetype)initWithName:(NSString *)name;

- (void)start;

- (void)stop;

- (void)suspend;

- (void)resume;


// 依赖的其它模块 @[moduleName1,moduleName2,...]
- (void)requireModules:(NSArray <NSString *>*)modules;


//- (void)requireLibs:()


@end

NS_ASSUME_NONNULL_END
