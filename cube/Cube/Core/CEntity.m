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

#import "CEntity.h"
#import "CUtils.h"
#import <cell/CellUtil.h>

@implementation CEntity

- (instancetype)init {
    if (self = [super init]) {
        _identity = [CellUtil generateUnsignedSerialNumber];
        _timestamp = [CUtils currentTimeMillis];
        _last = _timestamp;
        _expiry = _last + CUBE_LIFECYCLE_IN_MSEC;
        self.context = nil;
    }

    return self;
}

- (instancetype)initWithId:(UInt64)identity {
    if (self = [super init]) {
        _identity = identity;
        _timestamp = [CUtils currentTimeMillis];
        _last = _timestamp;
        _expiry = _last + CUBE_LIFECYCLE_IN_MSEC;
        self.context = nil;
    }
    
    return self;
}

- (instancetype)initWithId:(UInt64)identity timestamp:(UInt64)timestamp {
    if (self = [super init]) {
        _identity = identity;
        _timestamp = timestamp;
        _last = timestamp;
        _expiry = _last + CUBE_LIFECYCLE_IN_MSEC;
        self.context = nil;
    }

    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super init]) {
        _identity = [[json valueForKey:@"id"] unsignedLongLongValue];

        if ([json objectForKey:@"timestamp"])
            _timestamp = [[json valueForKey:@"timestamp"] unsignedLongLongValue];
        else
            _timestamp = [CUtils currentTimeMillis];

        if ([json objectForKey:@"last"])
            _last = [[json valueForKey:@"last"] unsignedLongLongValue];
        else
            _last = [CUtils currentTimeMillis];

        if ([json objectForKey:@"expiry"])
            _expiry = [[json valueForKey:@"expiry"] unsignedLongLongValue];
        else
            _expiry = _last + CUBE_LIFECYCLE_IN_MSEC;

        self.context = nil;
    }

    return self;
}

- (UInt64)getId {
    return _identity;
}

- (void)resetLast:(UInt64)time {
    _last = time;
    _expiry = time + CUBE_LIFECYCLE_IN_MSEC;
}

- (void)resetExpiry:(UInt64)expiry lastTimestamp:(UInt64)lastTimestamp {
    _last = lastTimestamp;
    _expiry = expiry;
}

- (BOOL)isValid {
    return _expiry > [CUtils currentTimeMillis];
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [[NSMutableDictionary alloc] init];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_identity] forKey:@"id"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_timestamp] forKey:@"timestamp"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_last] forKey:@"last"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_expiry] forKey:@"expiry"];
    return json;
}

- (NSMutableDictionary *)toCompactJSON {
    NSMutableDictionary * json = [[NSMutableDictionary alloc] init];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_identity] forKey:@"id"];
    return json;
}

@end
