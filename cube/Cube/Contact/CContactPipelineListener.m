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

#import "CContactPipelineListener.h"
#import "CContactAction.h"

@interface CContactPipelineListener () {
    
    CContactService * _service;
}

@end

@implementation CContactPipelineListener

- (instancetype)initWithService:(CContactService *)service {
    if (self = [super init]) {
        _service = service;
    }

    return self;
}

- (void)didReceive:(CPipeline *)pipeline source:(NSString *)source packet:(CPacket *)packet {
    if (packet.state.code != CSC_Ok) {
        NSLog(@"CContactPipelineListener#didReceive code : %d", packet.state.code);
        return;
    }

    if ([packet.name isEqualToString:CUBE_CONTACT_SIGNIN]) {
        [_service triggerSignIn:[packet extractStateCode] payload:[packet extractData]];
    }
    else if ([packet.name isEqualToString:CUBE_CONTACT_SIGNOUT]) {
        [_service triggerSignOut];
    }
}

- (void)didOpen:(CPipeline *)pipeline {
    // 如果用户请求签入但是签入失败（在签入时可能没有网络），则在连接建立后尝试自动签入
    if (_service.myself && ![_service isReady]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self->_service signIn:self->_service.myself handleSuccess:^(CSelf *myself) {
                // Nothing
            } handleFailure:^(CError * _Nonnull error) {
                // Nothing
            }];
        });
    }
}

- (void)didClose:(CPipeline *)pipeline {
    
}

@end
