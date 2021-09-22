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

#import "CEngine.h"

#import "CKernel.h"
#import "CError.h"
#import "CAuthService.h"
#import "CContactService.h"
#import "CMessagingService.h"
#import "CMessagingExtension.h"
#import "CUtils.h"
#import "CSelf.h"
#import "CPipeline.h"

@implementation CEngine

+ (CEngine * _Nonnull)sharedInstance {
    static CEngine *engine;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [[CEngine alloc] init];
    });
    return engine;
}

- (instancetype)init {
    if (self = [super init]) {
        _kernel = [[CKernel alloc] init];
        [_kernel installModule:[[CAuthService alloc] init]];
        [_kernel installModule:[[CContactService alloc] init]];
        [_kernel installModule:[[CMessagingService alloc] init]];

        _version = CUBE_KERNEL_VERSION;

        _lastError = nil;
    }

    return self;
}

- (void)startWithConfig:(CKernelConfig * _Nonnull)config success:(void (^)(CEngine * _Nullable))success failure:(void (^)(CError * _Nonnull))failure {
    [_kernel startup:config completion:^ {
        success(self);
    } failure:^(CError * error) {
        failure(error);
    }];
}

- (BOOL)startWithConfig:(CKernelConfig *)config timeoutInMilliseconds:(UInt64)timeoutInMilliseconds {
    __block CError * startupError = nil;

    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

    BOOL result = [_kernel startup:config completion:^{
        dispatch_semaphore_signal(semaphore);
    } failure:^(CError * error) {
        startupError = [CError errorWithModule:error.module code:error.code];
        dispatch_semaphore_signal(semaphore);
    }];

    if (!result) {
        // 内核操作无效
        _lastError = [CError errorWithModule:@"Kernel" code:-1];
        return FALSE;
    }

    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, timeoutInMilliseconds * NSEC_PER_MSEC);
    dispatch_semaphore_wait(semaphore, timeout);

    // 记录错误
    _lastError = startupError;

    return (nil == startupError);
}

- (void)stop {
    [_kernel shutdown];
}

- (void)suspend {
    [_kernel suspend];
}

- (void)resume {
    [_kernel resume];
}

- (BOOL)hasStarted {
    return [_kernel isReady];
}

- (BOOL)isReadyForPipeline {
    if (_kernel.mainPipeline) {
        return [_kernel.mainPipeline isReady];
    }
    
    return FALSE;
}

- (CSelf * _Nullable)signInWithId:(UInt64)contactId {
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);

    CContactService * contactService = [self getContactService];
    BOOL ret = [contactService signInWith:contactId name:@"Cube" handleSuccess:^(CSelf * owner) {
        dispatch_semaphore_signal(semaphore);
    } handleFailure:^(CError * _Nonnull error) {
        dispatch_semaphore_signal(semaphore);
    }];

    if (!ret) {
        return nil;
    }

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    return contactService.owner;
}

- (CSelf * _Nullable)signInWithId:(UInt64)contactId andName:(NSString * _Nonnull)name andContext:(NSDictionary * _Nullable)context {
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    __block CError * signInError = nil;

    CContactService * contactService = [self getContactService];
    
    // 实例化 CSelf
    CSelf * me = [[CSelf alloc] initWithId:contactId name:name];
    if (context) {
        me.context = context;
    }

    BOOL ret = [contactService signIn:me handleSuccess:^(CSelf *owner) {
        dispatch_semaphore_signal(semaphore);
    } handleFailure:^(CError * _Nonnull error) {
        signInError = error;
        dispatch_semaphore_signal(semaphore);
    }];

    if (!ret) {
        return nil;
    }

    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    if (nil != signInError) {
        _lastError = signInError;
        return nil;
    }
    else {
        return contactService.owner;
    }
}

- (CContactService * _Nullable)getContactService {
    return (CContactService *) [_kernel getModule:CUBE_MODULE_CONTACT];
}

- (CMessagingService * _Nullable)getMessagingService {
    return (CMessagingService *) [_kernel getModule:CUBE_MODULE_MESSAGING];
}

#pragma mark - Getters

- (CContactService *)contactService {
    return (CContactService *) [_kernel getModule:CUBE_MODULE_CONTACT];
}

- (CMessagingService *)messagingService {
    return (CMessagingService *) [_kernel getModule:CUBE_MODULE_MESSAGING];
}

@end

