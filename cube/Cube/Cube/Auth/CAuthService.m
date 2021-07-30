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

#import "CAuthService.h"
#import "CAuthAction.h"
#import "CAuthStorage.h"
#import "CPipeline.h"
#import "CPacket.h"

typedef void (^wait_block_t)(void);

@interface CAuthService () {
    
    int waitingCount;
}

- (void)waitPipelineReady:(wait_block_t)block;

@end

@implementation CAuthService

- (id)init {
    if (self = [super initWithName:CUBE_MODULE_AUTH]) {
        waitingCount = 0;
    }

    return self;
}

- (AnyPromise *)check:(NSString *)domain appKey:(NSString *)appKey address:(NSString *)address {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolver) {
        CAuthStorage * storage = [[CAuthStorage alloc] init];
        
        // 打开存储器
        if ([storage open]) {
            CAuthToken * token = [storage loadTokenWithDomain:domain appKey:appKey];
            if (nil != token && [token isValid]) {
                // 关闭存储器
                [storage close];

                resolver(token);
            }
            else {
                // 关闭存储器
                [storage close];

                if (nil != address) {
                    self.pipeline.address = address;
                }
                
                // 从服务器申请令牌
                [self.pipeline open];

                // 等待通道就绪
                self->waitingCount = 0;

                [self waitPipelineReady:^(void) {
                    if (self->waitingCount >= 5) {
                        // 超时
                        resolver(nil);
                        return;
                    }
                    
                    [self applyToken:domain appKey:appKey].then(^(id value) {
                        
                    }).catch(^(NSError * error) {
                        
                    });
                }];
            }
        }
        else {
            resolver(nil);
        }
    }];
}

- (AnyPromise *)applyToken:(NSString *)domain appKey:(NSString *)appKey {
    return [AnyPromise promiseWithResolverBlock:^(PMKResolver resolver) {
        // 向服务器请求
        NSDictionary * data = @{@"domain": domain, @"appKey": appKey};
        CPacket * packet = [[CPacket alloc] initWithName:CUBE_AUTH_APPLY_TOKEN andData:data];

        [self.pipeline send:CUBE_MODULE_AUTH withPacket:packet handleResponse:^(CPacket *packet) {
                    
        }];
    }];
}

- (void)waitPipelineReady:(wait_block_t)block {
    ++waitingCount;
    if (waitingCount >= 5) {
        block();
        return;
    }

    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, 1000 * NSEC_PER_MSEC);
    dispatch_after(delayInNanoSeconds,
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0),
                   ^(void) {
        if ([self.pipeline isReady]) {
            block();
        }
        else {
            [self waitPipelineReady:block];
        }
    });
}

@end