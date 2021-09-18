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

#import "CubeAccount.h"
#import "CubeAppUtil.h"
#import <Cube/CUtils.h>

@implementation CubeAccount

+ (CubeAccount *)accountWithJSON:(NSDictionary *)json {
    return [[CubeAccount alloc] initWithJSON:json];
}

- (instancetype)initWithJSON:(NSDictionary *)accountJSON {
    if (self = [super init]) {
        _identity = [[accountJSON valueForKey:@"id"] unsignedLongValue];
        _phoneNumber = [accountJSON valueForKey:@"phone"];
        _displayName = [accountJSON valueForKey:@"name"];
        _region = [accountJSON valueForKey:@"region"];
        _avatar = [accountJSON valueForKey:@"avatar"];
        _state = [[accountJSON valueForKey:@"state"] integerValue];

        if ([accountJSON objectForKey:@"account"]) {
            _accountName = [accountJSON valueForKey:@"account"];
        }
        else {
            _accountName = @"";
        }

        if ([accountJSON objectForKey:@"localTimestamp"]) {
            _localTimestamp = [[accountJSON valueForKey:@"localTimestamp"] unsignedLongLongValue];
        }
        else {
            _localTimestamp = [CUtils currentTimeMillis];
        }
    }

    return self;
}

- (NSDictionary *)toJSON {
    NSDictionary * json = @{
        @"id" : [NSNumber numberWithUnsignedLongLong:_identity],
        @"account" : _accountName,
        @"phone" : _phoneNumber,
        @"name" : _displayName,
        @"avatar" : _avatar,
        @"region" : _region,
        @"state" : [NSNumber numberWithUnsignedInteger:_state],
        @"localTimestamp": [NSNumber numberWithUnsignedLongLong:_localTimestamp]
    };
    return json;
}

- (NSDictionary *)toDesensitizingJSON {
    NSDictionary * json = @{
        @"id" : [NSNumber numberWithUnsignedLongLong:_identity],
        @"phone" : [CubeAppUtil desensitizePhoneNumber:_phoneNumber],
        @"name" : _displayName,
        @"avatar" : _avatar,
        @"region" : _region,
        @"state" : [NSNumber numberWithUnsignedInteger:_state]
    };
    return json;
}

@end
