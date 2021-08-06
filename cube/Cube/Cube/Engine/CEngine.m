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

#import "CEngine.h"

@implementation CEngine

+ (CEngine *)sharedInstance {
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
    }

    return self;
}

- (void)start:(CKernelConfig *)config success:(void (^)(CKernel *))success failure:(void (^)(CError *))failure {
    [_kernel startup:config completion:^ {
        success(self->_kernel);
    } failure:^(CError * error) {
        failure(error);
    }];
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

@end

