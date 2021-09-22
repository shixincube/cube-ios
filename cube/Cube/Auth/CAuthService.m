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

#import "CAuthService.h"
#import "CAuthAction.h"
#import "CAuthStorage.h"
#import "CPipeline.h"
#import "CPacket.h"
#import "CStateCode.h"

#define MAX_WAITING_COUNT 50

typedef void (^wait_block_t)(void);

static NSString * sCubeDomain = @"shixincube.com";

@interface CAuthService () {
    
    int waitingCount;
}

- (void)waitPipelineReady:(wait_block_t)block;

@end

@implementation CAuthService

- (instancetype)init {
    if (self = [super initWithName:CUBE_MODULE_AUTH]) {
        waitingCount = 0;
        self.token = nil;
    }

    return self;
}

- (CAuthToken *)checkLocalToken:(NSString *)domain appKey:(NSString *)appKey {
    sCubeDomain = domain;

    CAuthStorage * storage = [[CAuthStorage alloc] init];
    if ([storage open]) {
        CAuthToken * token = [storage loadTokenWithDomain:domain appKey:appKey];
        if (token && [token isValid]) {
            // 令牌赋值
            self.token = token;

            [storage close];

            return self.token;
        }
        else {
            [storage close];

            return nil;
        }
    }

    return nil;
}

- (void)check:(NSString *)domain appKey:(NSString *)appKey address:(NSString *)address handler:(void(^)(CError * error, CAuthToken * token))handler {
    // 赋值 Domain 数据
    sCubeDomain = domain;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        CAuthStorage * storage = [[CAuthStorage alloc] init];

        // 打开存储器
        if ([storage open]) {
            CAuthToken * token = [storage loadTokenWithDomain:domain appKey:appKey];
            if (token && [token isValid]) {
                // 关闭存储器
                [storage close];

                self.token = token;

                handler(nil, token);
            }
            else {
                // 等待通道就绪
                self->waitingCount = 0;

                [self waitPipelineReady:^(void) {
                    if (self->waitingCount >= MAX_WAITING_COUNT) {
                        // 超时
                        NSLog(@"CAuthService#waitPipelineReady timeout");

                        // 关闭存储器
                        [storage close];

                        handler([CError errorWithModule:CUBE_MODULE_AUTH code:CAuthServiceStateTimeout], nil);
                        return;
                    }

                    [self applyToken:domain appKey:appKey handler:^(CError *error, CAuthToken *token) {
                        if (error) {
                            NSLog(@"CAuthService#applyToken error : %ld", error.code);

                            // 关闭存储器
                            [storage close];

//                            handler([CError errorWithModule:CUBE_MODULE_AUTH code:CAuthServiceStateFailure], nil);
                            handler(error, nil);
                        }
                        else {
                            NSLog(@"CAuthService#applyToken OK");

                            // 保存令牌
                            [storage saveToken:token];

                            self.token = token;

                            // 关闭存储器
                            [storage close];

                            handler(nil, token);
                        }
                    }];
                }];
            }
        }
        else {
            // 开启存储错误
            handler([CError errorWithModule:CUBE_MODULE_AUTH code:CAuthServiceStateStorage], nil);
        }
    });
}

- (void)applyToken:(NSString *)domain appKey:(NSString *)appKey handler:(void(^)(CError * error, CAuthToken * token))handler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        // 向服务器请求
        NSDictionary * data = @{@"domain": domain, @"appKey": appKey};
        CPacket * packet = [[CPacket alloc] initWithName:CUBE_AUTH_APPLY_TOKEN andData:data];

        [self.pipeline send:CUBE_MODULE_AUTH withPacket:packet handleResponse:^(CPacket *packet) {
            if (packet.state.code != CSC_Ok) {
                handler([CError errorWithModule:CUBE_MODULE_AUTH code:packet.state.code], nil);
                return;
            }

            int state = [packet extractStateCode];
            if (state == CAuthServiceStateOk) {
                // 创建令牌数据
                CAuthToken * authToken = [[CAuthToken alloc] initWithJSON:[packet extractData]];
                handler(nil, authToken);
            }
            else {
                handler([CError errorWithModule:CUBE_MODULE_AUTH code:state], nil);
            }
        }];
    });
}

- (CAuthToken *)allocToken:(UInt64)contactId {
    if (!self.token) {
        return nil;
    }

    if (self.token.cid != contactId) {
        // 按照指定 ID 获取令牌
        CAuthStorage * storage = [[CAuthStorage alloc] init];
        if ([storage open]) {
            // 查询指定令牌
            CAuthToken * contactToken = [storage loadTokenWithContactId:contactId domain:self.token.domain appKey:self.token.appKey];

            if (nil == contactToken) {
                // 没有对应的令牌，将当前令牌进行更新
                self.token.cid = contactId;

                // 更新令牌
                [storage updateToken:self.token];
            }
            else {
                // 覆盖当前令牌
                self.token = contactToken;
            }

            [storage close];
        }
    }

    return self.token;
}

- (void)waitPipelineReady:(wait_block_t)block {
    if ([self.pipeline isReady]) {
        block();
        return;
    }

    ++waitingCount;
    if (waitingCount >= MAX_WAITING_COUNT) {
        block();
        return;
    }

    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC);
    dispatch_after(delayInNanoSeconds,
                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
                    [self waitPipelineReady:block];
                });
}

+ (NSString *)domain {
    return sCubeDomain;
}

@end
