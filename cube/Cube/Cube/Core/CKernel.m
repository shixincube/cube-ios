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

@implementation CKernelConfig

- (id)init {
    if (self = [super init]) {
        self.port = 7000;
        self.pipelineReady = FALSE;
        self.unconnected = FALSE;
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


@interface CKernel ()

@property (nonatomic, strong) CKernelConfig * config;

@property (nonatomic, strong) CCellPipeline * cellPipeline;

- (void)bundleDefault;

@end

@implementation CKernel

- (id)init {
    if (self = [super init]) {
        self.cellPipeline = [[CCellPipeline alloc] init];
    }
    
    return self;
}

- (void)startup:(CKernelConfig *)config completion:(void (^)(void))completion failure:(void (^)(void))failure {
    self.config = config;
    
    
}

- (void)shutdown {
    [self.cellPipeline close];
}

- (void)suspend {
    
}

- (void)resume {
    
}

#pragma mark Private

- (void)bundleDefault {
    
}

@end
