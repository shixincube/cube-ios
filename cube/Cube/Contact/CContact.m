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

#import "CContact.h"
#import "CDevice.h"
#import "CContactAppendix.h"

@implementation CContact

- (instancetype)initWithId:(UInt64)identity name:(NSString *)name domain:(NSString *)domain {
    if (self = [super initWithId:identity name:name domain:domain]) {
        _devices = [[NSMutableArray alloc] initWithCapacity:2];
    }

    return self;
}

- (instancetype)initWithId:(UInt64)identity name:(NSString *)name domain:(NSString *)domain timestamp:(UInt64)timestamp {
    if (self = [super initWithId:identity name:name domain:domain timestamp:timestamp]) {
        _devices = [[NSMutableArray alloc] initWithCapacity:2];
    }

    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json domain:(NSString *)domain {
    if (self = [super initWithJSON:json]) {
        self.domain = domain;

        _devices = [[NSMutableArray alloc] initWithCapacity:2];

        if ([json objectForKey:@"devices"]) {
            NSArray * list = [json valueForKey:@"devices"];
            for (NSDictionary * devJson in list) {
                CDevice * device = [CDevice deviceWithJSON:devJson];
                [self addDevice:device];
            }
        }
    }

    return self;
}

- (NSString *)getPriorityName {
    if (self.appendix && [self.appendix hasRemarkName]) {
        return self.appendix.remarkName;
    }

    return self.name;
}

- (void)addDevice:(CDevice *)device {
    for (CDevice * dev in _devices) {
        if ([dev isEqual:device]) {
            return;
        }
    }

    [_devices addObject:device];
}

- (void)removeDevice:(CDevice *)device {
    for (NSUInteger i = 0; i < _devices.count; ++i) {
        CDevice * dev = [_devices objectAtIndex:i];
        if ([dev isEqual:device]) {
            [_devices removeObjectAtIndex:i];
            break;
        }
    }
}

- (CDevice *)getDevice {
    if (_devices.count == 0) {
        return [[CDevice alloc] initWithName:@"Unknown" platform:@"null"];
    }

    return [_devices objectAtIndex:_devices.count - 1];
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return TRUE;
    }

    if (!object || ![object isKindOfClass:[self class]]) {
        return FALSE;
    }

    CContact * other = object;
    return (other.identity == self.identity) &&
            [other.domain isEqualToString:self.domain];
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [super toJSON];

    NSMutableArray * list = [[NSMutableArray alloc] initWithCapacity:_devices.count];
    for (CDevice * dev in _devices) {
        [list addObject:[dev toJSON]];
    }
    [json setValue:list forKey:@"devices"];

    return json;
}

- (NSMutableDictionary *)toCompactJSON {
    NSMutableDictionary * json = [super toCompactJSON];
    return json;
}

@end
