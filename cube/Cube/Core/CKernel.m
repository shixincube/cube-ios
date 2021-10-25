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

#import "CKernel.h"
#import "CModule.h"
#import "CError.h"
#import "CAuthToken.h"
#import "CCellPipeline.h"
#import "CEntityInspector.h"
#import "CAuthService.h"
#import "CContactService.h"
#import "CKernel+Delegate.h"

@implementation CKernelConfig

- (instancetype)init {
    if (self = [super init]) {
        self.address = @"127.0.0.1";
        self.port = 7000;
        self.pipelineReady = FALSE;
        self.enabledMessaging = TRUE;
    }

    return self;
}

- (instancetype)initWithAddress:(NSString *)address domain:(NSString *)domain appKey:(NSString *)appKey {
    if (self = [super init]) {
        self.address = address;
        self.port = 7000;
        self.domain = domain;
        self.appKey = appKey;

        self.pipelineReady = FALSE;
        self.enabledMessaging = TRUE;
    }

    return self;
}

- (instancetype)initWithAddress:(NSString *)address andPort:(NSUInteger)port domain:(NSString *)domain appKey:(NSString *)appKey {
    if (self = [super init]) {
        self.address = address;
        self.port = port;
        self.domain = domain;
        self.appKey = appKey;

        self.pipelineReady = FALSE;
        self.enabledMessaging = TRUE;
    }
    return self;
}

+ (CKernelConfig *)configWithAddress:(NSString *)address domain:(NSString *)domain appKey:(NSString *)appKey {
    CKernelConfig * config = [[CKernelConfig alloc] initWithAddress:address domain:domain appKey:appKey];
    return config;
}

+ (CKernelConfig *)configWithAddress:(NSString *)address andPort:(NSUInteger)port domain:(NSString *)domain appKey:(NSString *)appKey {
    CKernelConfig * config = [[CKernelConfig alloc] initWithAddress:address andPort:port domain:domain appKey:appKey];
    return config;
}

@end


@interface CKernel () {
    /*! @brief 是否已处于工作状态。 */
    BOOL _working;

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
- (BOOL)checkAuth:(CKernelConfig *)config handler:(void (^)(CError *, CAuthToken *))handler;

@end

@implementation CKernel

- (instancetype)init {
    if (self = [super init]) {
        _working = FALSE;
        _cellPipeline = [[CCellPipeline alloc] init];
        _modules = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (BOOL)startup:(CKernelConfig *)config completion:(void (^)(void))completion failure:(void (^)(CError *))failure {
    if (_working) {
        return FALSE;
    }

    _config = config;

    _working = TRUE;

    _entityInspector = [[CEntityInspector alloc] init];

    // 配置默认规格
    [self bundleDefault];

    // 启动管道
    [_cellPipeline setRemoteAddress:_config.address withPort:_config.port];
    [_cellPipeline addListener:self];
    [_cellPipeline open];

    BOOL ret = [self checkAuth:config handler:^(CError * error, CAuthToken * token) {
        if (token) {
            // 设置数据通道的访问令牌码
            self->_cellPipeline.tokenCode = token.code;

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                completion();
            });
        }
        else {
            self->_working = FALSE;

            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                failure(error);
            });
        }
    }];

    return ret;
}

- (void)shutdown {
    [_entityInspector destroy];

    [_cellPipeline close];

    _working = FALSE;
}

- (void)suspend {
    
}

- (void)resume {
    if (_working) {
        if ([self hasModule:CUBE_MODULE_CONTACT]) {
            CContactService * contact = (CContactService *) [self getModule:CUBE_MODULE_CONTACT];
            [contact comeback];
        }

        if (![_cellPipeline isReady]) {
            [_cellPipeline open];
        }
    }
}

- (BOOL)isReady {
    return _working && (self.authToken && [self.authToken isValid]);
}

- (void)installModule:(CModule *)module {
    module.kernel = self;
    
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

- (CAuthToken *)activeToken:(UInt64)contactId {
    CAuthService * authService = (CAuthService *) [self getModule:CUBE_MODULE_AUTH];
    CAuthToken * contactToken = [authService allocToken:contactId];

    // 更新管道令牌码
    if (contactToken) {
        _cellPipeline.tokenCode = contactToken.code;
    }

    return contactToken;
}

#pragma mark - Getters

- (CAuthToken *)authToken {
    CAuthService * authService = (CAuthService *) [self getModule:CUBE_MODULE_AUTH];
    if (!authService) {
        return nil;
    }

    return authService.token;
}

- (CPipeline *)mainPipeline {
    return _cellPipeline;
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

- (BOOL)checkAuth:(CKernelConfig *)config handler:(void (^)(CError * error, CAuthToken *))handler {
    if (![self hasModule:CUBE_MODULE_AUTH]) {
        NSLog(@"Kernel#checkAuth : Can NOT find auth module : %@", CUBE_MODULE_AUTH);
        return FALSE;
    }

    CAuthService * authService = (CAuthService *) [self getModule:CUBE_MODULE_AUTH];

    // 先查找本地存储的令牌
    CAuthToken * token = [authService loadLocalToken:config.domain appKey:config.appKey];
    if (token && [token isValid]) {
        handler(nil, token);
        return TRUE;
    }

    [authService check:config.domain appKey:config.appKey handler:^(CError *error, CAuthToken *token) {
        if (error) {
            handler(error, nil);
        }
        else {
            handler(nil, token);
        }
    }];
    
    return TRUE;
}

@end
