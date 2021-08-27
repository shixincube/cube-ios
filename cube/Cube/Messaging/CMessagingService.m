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

#import "CMessagingService.h"
#import "CMessagingPipelineListener.h"
#import "CMessagingStorage.h"
#import "CMessagingObserver.h"
#import "CContactEvent.h"
#import "CKernel.h"

@implementation CMessagingService

- (instancetype)init {
    if (self = [super initWithName:CUBE_MODULE_MESSAGING]) {
        _pipelineListener = [[CMessagingPipelineListener alloc] initWithService:self];
        _storage = [[CMessagingStorage alloc] init];
        _observer = [[CMessagingObserver alloc] initWithService:self];
        _serviceReady = FALSE;
    }

    return self;
}

- (BOOL)start {
    if (![super start]) {
        return FALSE;
    }

    // 监听联系人模块
    CContactService * contactService = (CContactService *) [self.kernel getModule:CUBE_MODULE_CONTACT];
    [contactService attachWithName:CContactEventSignIn observer:_observer];

    if ([contactService isReady]) {
        [self prepare:contactService];

        _serviceReady = TRUE;
    }

    [self.pipeline addListener:CUBE_MODULE_MESSAGING listener:_pipelineListener];

    return TRUE;
}

- (void)stop {
    [super stop];

    [self.pipeline removeListener:CUBE_MODULE_MESSAGING listener:_pipelineListener];
    
    // 关闭存储
    [_storage close];
    
    _serviceReady = FALSE;
}

- (void)suspend {
    [super suspend];
}

- (void)resume {
    [super resume];
}

- (BOOL)isReady {
    return _serviceReady;
}

#pragma mark - Private

- (void)prepare:(CContactService *)contactService {
    CSelf * myself = contactService.myself;
    // 开启存储器
    [_storage open:myself.identity domain:myself.domain];

    // 查询本地最近消息时间
    
}

@end
