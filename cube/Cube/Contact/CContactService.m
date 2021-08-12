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

#import "CContactService.h"
#import "CContactPipelineListener.h"
#import "CContactStorage.h"

@interface CContactService () {
    
    CContactPipelineListener * _pipelineListener;
    
    CContactStorage * _storage;
}

@end


@implementation CContactService

- (instancetype)init {
    if (self = [super initWithName:CUBE_MODULE_CONTACT]) {
        _pipelineListener = [[CContactPipelineListener alloc] initWithService:self];
        _storage = [[CContactStorage alloc] init];
    }

    return self;
}

- (BOOL)start {
    if (![super start]) {
        return FALSE;
    }

    [self.pipeline addListener:CUBE_MODULE_CONTACT listener:_pipelineListener];

    return TRUE;
}

- (void)stop {
    [super stop];

    [self.pipeline removeListener:CUBE_MODULE_CONTACT listener:_pipelineListener];
}

- (void)suspend {
    [super suspend];
}

- (void)resume {
    [super resume];
}

- (BOOL)isReady {
    return FALSE;
}

@end
