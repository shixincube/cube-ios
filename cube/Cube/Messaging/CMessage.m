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
#import "CMessageState.h"
#import "CAuthService.h"
#import "CUtils.h"

@interface CMessage ()

/*!
 * @brief 消息持有者 ID 。
 */
@property (nonatomic, assign) UInt64 owner;

/*!
 * @brief 消息作用域。
 * 0 - 无限制
 * 1 - 仅作用于发件人，用于管理本地消息通知。
 */
@property (nonatomic, assign) int scope;

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
@synthesize state = _state;
@synthesize owner = _owner;
@synthesize scope = _scope;

- (instancetype)initWithPayload:(NSDictionary *)payload {
    if (self = [super init]) {
        _domain = [CAuthService domain];
        _payload = payload;
        _localTS = [CUtils currentTimeMillis];
        _remoteTS = 0;
        _from = 0;
        _to = 0;
        _source = 0;
        _owner = 0;
        _state = CMessageStateUnknown;
        _scope = 0;
    }

    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithId:[[json valueForKey:@"id"] unsignedLongLongValue]]) {
        _domain = [json valueForKey:@"domain"];
        _from = [[json valueForKey:@"from"] unsignedLongLongValue];
        _to = [[json valueForKey:@"to"] unsignedLongLongValue];
        _source = [[json valueForKey:@"source"] unsignedLongLongValue];
        _owner = [[json valueForKey:@"owner"] unsignedLongLongValue];
        _localTS = [[json valueForKey:@"lts"] unsignedLongLongValue];
        _remoteTS = [[json valueForKey:@"rts"] unsignedLongLongValue];
        _state = [[json valueForKey:@"state"] intValue];
        _scope = [[json valueForKey:@"scope"] intValue];

        if ([json objectForKey:@"payload"]) {
            _payload = [json valueForKey:@"payload"];
        }
    }

    return self;
}

- (instancetype)initWithMessage:(CMessage *)message {
    if (self = [super initWithId:message.identity]) {
        _domain = message.domain;
        _from = message.from;
        _sender = message.sender;
        _to = message.to;
        _receiver = message.receiver;
        _source = message.source;
        _sourceGroup = message.sourceGroup;
        _localTS = message.localTS;
        _remoteTS = message.remoteTS;
        _payload = message.payload;
        _state = message.state;
        _owner = message.owner;
        _scope = message.scope;
    }

    return self;
}

- (int)getScope {
    return _scope;
}

- (BOOL)isFromGroup {
    return (_source > 0);
}

- (void)bind:(UInt64)from
          to:(UInt64)to
      source:(UInt64)source {
    _from = from;
    _to = to;
    _source = source;
}

- (void)assignTS:(UInt64)localTS remoteTS:(UInt64)remoteTS {
    _localTS = localTS;
    _remoteTS = remoteTS;
}

- (void)assign:(CContact *)sender receiver:(CContact *)receiver
   sourceGroup:(CGroup *)sourceGroup {
    _sender = sender;
    _receiver = receiver;
    _sourceGroup = sourceGroup;
}

- (void)assignSender:(CContact *)sender {
    _sender = sender;
}

- (void)assignReceiver:(CContact *)receiver {
    _receiver = receiver;
}

- (void)assignSourceGroup:(CGroup *)group {
    _sourceGroup = group;
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [super toJSON];
    [json setValue:[NSNumber numberWithUnsignedLongLong:self.identity] forKey:@"id"];
    [json setValue:_domain forKey:@"domain"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_from] forKey:@"from"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_to] forKey:@"to"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_source] forKey:@"source"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_owner] forKey:@"owner"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_localTS] forKey:@"lts"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_remoteTS] forKey:@"rts"];
    [json setValue:[NSNumber numberWithInteger:_state] forKey:@"state"];
    [json setValue:[NSNumber numberWithInteger:_scope] forKey:@"scope"];
    [json setValue:_payload forKey:@"payload"];
    return json;
}

- (NSMutableDictionary *)toCompactJSON {
    return [self toJSON];
}

@end
