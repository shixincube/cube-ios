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
#import <PromiseKit/AnyPromise.h>
#import "CModule.h"
#import "CError.h"
#import "CAuthToken.h"
#import "CCellPipeline.h"
#import "CAuthService.h"
#import "CContactService.h"

@implementation CKernelConfig

- (instancetype)init {
    if (self = [super init]) {
        self.port = 7000;
        self.pipelineReady = FALSE;
        self.enabledMessaging = TRUE;
    }

    return self;
}

- (instancetype)initWithAddress:(NSString *)address domain:(NSString *)domain appKey:(NSString *)appKey {
    if (self = [super init]) {
        self.address = address;
        self.domain = domain;
        self.appKey = appKey;

        self.port = 7000;
        self.pipelineReady = FALSE;
        self.enabledMessaging = TRUE;
    }

    return self;
}

+ (CKernelConfig *)configWithAddress:(NSString *)address domain:(NSString *)domain appKey:(NSString *)appKey {
    CKernelConfig * config = [[CKernelConfig alloc] initWithAddress:address domain:domain appKey:appKey];
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
- (void)checkAuth:(CKernelConfig *)config handler:(void (^)(CError *, CAuthToken *))handler;

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

    // 配置默认规格
    [self bundleDefault];

    // 启动管道
    [_cellPipeline setRemoteAddress:_config.address withPort:_config.port];
    [_cellPipeline open];
 
    [self checkAuth:config handler:^(CError * error, CAuthToken * token) {
        if (token) {
            // 设置访问令牌
            self.authToken = token;
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
    
    return TRUE;
}

- (void)shutdown {
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
    return [authService allocToken:contactId];
}

#pragma mark - Getters

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

- (void)checkAuth:(CKernelConfig *)config handler:(void (^)(CError * error, CAuthToken *))handler {
    if (![self hasModule:CUBE_MODULE_AUTH]) {
        handler([CError errorWithModule:@"Kernel" code:CUBE_KERNEL_SC_NO_MODULE], nil);
        return;
    }

    CAuthService * authService = (CAuthService *) [self getModule:CUBE_MODULE_AUTH];

    CAuthToken * token = [authService checkLocalToken:config.domain appKey:config.appKey];
    if (token && [token isValid]) {
        handler(nil, token);
        return;
    }

    [authService check:config.domain appKey:config.appKey address:config.address].then(^(id token) {
        if ([token isKindOfClass:[CError class]]) {
            handler((CError *) token, nil);
        }
        else {
            handler(nil, (CAuthToken *) token);
        }
    }).catch(^(NSError *error) {
        if ([error isKindOfClass:[CError class]]) {
            handler((CError *) error, nil);
        }
        else {
            handler([CError errorWithError:error], nil);
        }
    });
}

@end
