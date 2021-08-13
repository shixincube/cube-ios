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
#import "CContactAction.h"
#import "CContactServiceState.h"
#import "CError.h"
#import "CKernel.h"

@interface CContactService () {
    
    CContactPipelineListener * _pipelineListener;
    
    CContactStorage * _storage;
    
    BOOL _selfReady;
    
    NSInteger _waitReadyCount;
}

- (void)waitReady:(void(^)(BOOL timeout))handler;

@end


@implementation CContactService

- (instancetype)init {
    if (self = [super initWithName:CUBE_MODULE_CONTACT]) {
        _pipelineListener = [[CContactPipelineListener alloc] initWithService:self];
        _storage = [[CContactStorage alloc] initWithService:self];
        _selfReady = FALSE;
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
    
    // 关闭存储
    [_storage close];
}

- (void)suspend {
    [super suspend];
}

- (void)resume {
    [super resume];
}

- (BOOL)isReady {
    return _selfReady;
}

- (void)signIn:(CSelf *)mySelf handleSuccess:(sign_block_t)handleSuccess handleFailure:(cube_failure_block_t)handleFailure {
    // 开启存储
    [_storage open:mySelf.identity domain:mySelf.domain];
    
    if (![self.pipeline isReady]) {
        handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:CSC_Contact_NoNetwork]);
        return;
    }

    // 10 秒
    _waitReadyCount = 100;

    [self.kernel activeToken:mySelf.identity handler:^(CAuthToken * token) {
        if (token) {
            // 设置 MySelf 实例
            self.myself = mySelf;

            // 打包数据
            NSMutableDictionary * data = [[NSMutableDictionary alloc] init];
            [data setValue:[mySelf toJSON] forKey:@"self"];
            [data setValue:[token toJSON] forKey:@"token"];

            CPacket * signInPacket = [[CPacket alloc] initWithName:CUBE_CONTACT_SIGNIN andData:data];
            [self.pipeline send:CUBE_MODULE_CONTACT withPacket:signInPacket handleResponse:^(CPacket *packet) {
                [self waitReady:^(BOOL timeout) {
                    if (timeout) {
                        // 超时
                        handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:CSC_Contact_ServerError]);
                    }
                    else {
                        handleSuccess(self.myself);
                    }
                }];
            }];
        }
        else {
            handleFailure([[CError alloc] initWithModule:CUBE_MODULE_CONTACT code:CSC_Contact_InconsistentToken]);
        }
    }];
}

- (void)signInWith:(UInt64)identity name:(NSString *)name handleSuccess:(sign_block_t)handleSuccess handleFailure:(cube_failure_block_t)handleFailure {
    CSelf * mySelf = [[CSelf alloc] initWithId:identity name:name];
    [self signIn:mySelf handleSuccess:handleSuccess handleFailure:handleFailure];
}

- (void)getAppendixWithContact:(CContact *)contact handleSuccess:(void(^)(CContact *, CContactAppendix *))handleSuccess handleFailure:(cube_failure_block_t)handleFailure {
    NSNumber * contactId = [NSNumber numberWithUnsignedLongLong:contact.identity];
    NSDictionary * data = [NSDictionary dictionaryWithObjectsAndKeys:contactId, @"contactId", nil];
    CPacket * request = [[CPacket alloc] initWithName:CUBE_CONTACT_GETAPPENDIX andData:data];
    // 发送请求
    [self.pipeline send:CUBE_MODULE_CONTACT withPacket:request handleResponse:^(CPacket *packet) {
        if (packet.state.code != CSC_Ok) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:packet.state.code];
            handleFailure(error);
            return;
        }

        int stateCode = [packet extractStateCode];
        if (stateCode != CSC_Contact_Ok) {
            CError * error = [CError errorWithModule:CUBE_MODULE_CONTACT code:stateCode];
            handleFailure(error);
            return;
        }

        CContactAppendix * appendix = [[CContactAppendix alloc] initWithService:self contact:contact json:[packet extractData]];

        // 更新存储
        [self->_storage writeContactAppendix:appendix];

        handleSuccess(contact, appendix);
    }];
}

- (void)getAppendixWithGroup:(CGroup *)group handleSuccess:(void(^)(CGroup *, CGroupAppendix *))handleSuccess handleFailure:(cube_failure_block_t)handleFailure {
    
}

- (void)listGroups:(UInt64)beginning ending:(UInt64)ending handler:(void (^)(NSArray *))handler {
    // TODO
    NSMutableArray * list = [[NSMutableArray alloc] init];
    handler(list);
}

#pragma mark - Private

- (void)waitReady:(void (^)(BOOL timeout))handler {
    --_waitReadyCount;
    if (_waitReadyCount <= 0) {
        handler(TRUE);
        _waitReadyCount = 0;
        return;
    }

    if (_selfReady) {
        handler(FALSE);
        _waitReadyCount = 0;
        return;
    }

    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, 100 * NSEC_PER_MSEC);
    dispatch_after(delayInNanoSeconds,
                dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0),
                ^(void) {
                    [self waitReady:handler];
                });
}

@end
