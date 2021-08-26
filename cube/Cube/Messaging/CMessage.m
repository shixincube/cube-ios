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

#import "CMessage.h"
#import "CAuthService.h"
#import "CUtils.h"

@interface CMessage ()

/*!
 * @brief 消息作用域。
 * 0 - 无限制
 * 1 - 仅作用于发件人
 */
@property (atomic, assign) NSInteger scope;

@end


@implementation CMessage

@synthesize domain = _domain;
@synthesize from = _from;
@synthesize sender = _sender;
@synthesize to = _to;
@synthesize receiver = _receiver;
@synthesize source = _source;
@synthesize sourceGroup = _sourceGroup;
@synthesize localTS = _localTS;
@synthesize remoteTS = _remoteTS;
@synthesize payload = _payload;

- (instancetype)initWithPayload:(NSDictionary *)payload {
    if (self = [super init]) {
        _domain = [CAuthService domain];
        _payload = payload;
        _localTS = [CUtils currentTimeMillis];
        _remoteTS = 0;
        _from = 0;
        _to = 0;
        _source = 0;
    }

    return self;
}

- (BOOL)isFromGroup {
    return (_source > 0);
}

- (void)setRoute:(UInt64)from  sender:(CContact *)sender
              to:(UInt64)to receiver:(CContact *)receiver
          source:(UInt64)source sourceGroup:(CGroup *)sourceGroup {
    _from = from;
    _sender = sender;
    _to = to;
    _receiver = receiver;
    _source = source;
    _sourceGroup = sourceGroup;
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [super toJSON];
    
    return json;
}

- (NSMutableDictionary *)toCompactJSON {
    NSMutableDictionary * json = [super toCompactJSON];
    return json;
}

@end
