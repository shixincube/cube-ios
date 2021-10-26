/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Cube Team.
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

#import "CDevice.h"
#import "DeviceUtil.h"
#import <UIKit/UIDevice.h>

@implementation CDevice

- (instancetype)init {
    if (self = [super init]) {
        DeviceUtil * devUtil = [[DeviceUtil alloc] init];
        // 设备描述，例如：iPhone 11 Pro
        NSString * desc = [devUtil hardwareSimpleDescription];

        UIDevice * device = [UIDevice currentDevice];
        _name = device.model;

        _platform = [NSString stringWithFormat:@"%@/%@ %@/%@", desc,
                     [device systemName], [device systemVersion],
                     device.identifierForVendor.UUIDString];
    }

    return self;
}

- (instancetype)initWithName:(NSString *)name platform:(NSString *)platform {
    if (self = [super init]) {
        _name = name;
        _platform = platform;
    }
    
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super init]) {
        _name = [json valueForKey:@"name"];
        _platform = [json valueForKey:@"platform"];
    }

    return self;
}

- (BOOL)isEqual:(id)object {
    if (self == object) {
        return TRUE;
    }

    if (!object || ![object isKindOfClass:[self class]]) {
        return FALSE;
    }

    CDevice * other = object;
    return [_name isEqualToString:other.name] && [_platform isEqualToString:other.platform];
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [[NSMutableDictionary alloc] init];
    [json setValue:_name forKey:@"name"];
    [json setValue:_platform forKey:@"platform"];
    return json;
}

- (NSMutableDictionary *)toCompactJSON {
    return [self toJSON];
}

+ (CDevice *)deviceWithJSON:(NSDictionary *)json {
    return [[CDevice alloc] initWithJSON:json];
}

@end
