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

#import "CKernel.h"
#import "../Pipeline/CCellPipeline.h"
#import "../Auth/CAuthService.h"

@implementation CKernelConfig

- (id)init {
    if (self = [super init]) {
        self.port = 7000;
        self.pipelineReady = FALSE;
        self.unconnected = FALSE;
        self.enabledMessaging = FALSE;
    }

    return self;
}

- (id)initWithAddress:(NSString *)address domain:(NSString *)domain appKey:(NSString *)appKey {
    if (self = [super init]) {
        self.address = address;
        self.domain = domain;
        self.appKey = appKey;

        self.port = 7000;
        self.pipelineReady = FALSE;
        self.unconnected = FALSE;
    }

    return self;
}

@end


@interface CKernel () {
    /*! @brief 是否已处于工作状态。 */
    BOOL _working;

    /*! @brief 配置。 */
    CKernelConfig * _config;

    /*! @brief Cell 数据通道。 */
    CCellPipeline * _cellPipeline;

    /*! @brief 模块清单。 */
    NSMutableDictionary <NSString *, __kindof CModule *> * _modules;
}

/*!
 * @brief 进行默认规则配置。
 */
- (void)bundleDefault;

/*!
 * @brief 检查授权。
 * @param config 引擎配置。
 * @param handler 回调。
 */
- (void)checkAuth:(CKernelConfig *)config handler:(void (^)(CAuthToken *))handler;

@end

@implementation CKernel

- (id)init {
    if (self = [super init]) {
        _working = FALSE;
        _cellPipeline = [[CCellPipeline alloc] init];
        _modules = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)startup:(CKernelConfig *)config completion:(void (^)(void))completion failure:(void (^)(void))failure {
    _config = config;

    _working = TRUE;

    // 配置默认规格
    [self bundleDefault];

    // 启动管道
    [_cellPipeline setRemoteAddress:_config.address withPort:_config.port];
    [_cellPipeline open];

//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
//    });

    [self checkAuth:config handler:^(CAuthToken * token) {
        if (token) {
            self.authToken = token;
            completion();
        }
        else {
            failure();
        }
    }];
}

- (void)shutdown {
    [_cellPipeline close];
}

- (void)suspend {
    
}

- (void)resume {
    
}

- (BOOL)isReady {
    return _working && (self.authToken && [self.authToken isValid]);
}

- (void)installModule:(CModule *)module {
    [_modules setObject:module forKey:module.name];
}

- (void)uninstallModule:(CModule *)module {
    [_modules removeObjectForKey:module.name];
}

- (CModule *)getModule:(NSString *)moduleName {
    return [_modules objectForKey:moduleName];
}

- (BOOL)hasModule:(NSString *)moduleName {
    return ([_modules objectForKey:moduleName]) ? TRUE : FALSE;
}

#pragma mark - Private

- (void)bundleDefault {
    NSEnumerator * enumerator = [_modules keyEnumerator];
    NSString * key = nil;

    while ((key = [enumerator nextObject])) {
        CModule * module = [_modules objectForKey:key];
        module.pipeline = _cellPipeline;
    }
}

- (void)checkAuth:(CKernelConfig *)config handler:(void (^)(CAuthToken *))handler {
    if (![self hasModule:CUBE_MODULE_AUTH]) {
        handler(nil);
        return;
    }
    
    CAuthService * atuhService = (CAuthService *) [self getModule:CUBE_MODULE_AUTH];
    [atuhService check:config.domain appKey:config.appKey address:config.address].then(^(id token) {
        if (nil == token) {
            handler(nil);
        }
        else {
            handler((CAuthToken *) token);
        }
    }).catch(^(NSError *error) {
        handler(nil);
    });
}

@end
