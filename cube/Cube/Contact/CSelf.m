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

#import "CSelf.h"
#import "CAuthService.h"

@implementation CSelf

- (instancetype)initWithId:(UInt64)identity name:(NSString *)name {
    if (self = [super initWithId:identity name:name domain:[CAuthService domain]]) {
        _device = [[CDevice alloc] init];

        [self addDevice:_device];
    }

    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithId:[[json valueForKey:@"id"] unsignedLongLongValue] name:[json valueForKey:@"name"] domain:[CAuthService domain]]) {
        _device = [[CDevice alloc] init];

        [self addDevice:_device];

        if ([json objectForKey:@"devices"]) {
            NSArray * devices = [json objectForKey:@"devices"];
            for (NSDictionary * devJson in devices) {
                CDevice * device = [[CDevice alloc] initWithJSON:devJson];
                [self addDevice:device];
            }
        }

        if ([json objectForKey:@"context"]) {
            self.context = [json valueForKey:@"context"];
        }
    }

    return self;
}

- (void)updateWithJSON:(NSDictionary *)json {
    self.name = [json valueForKey:@"name"];

    if ([json objectForKey:@"context"]) {
        self.context = [json valueForKey:@"context"];
    }
    
    if ([json objectForKey:@"devices"]) {
        NSArray * devices = [json objectForKey:@"devices"];
        for (NSDictionary * devJson in devices) {
            CDevice * device = [[CDevice alloc] initWithJSON:devJson];
            [self addDevice:device];
        }
    }
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [super toJSON];
    [json setValue:[_device toJSON] forKey:@"device"];
    return json;
}

- (NSMutableDictionary *)toCompactJSON {
    NSMutableDictionary * json = [super toCompactJSON];
    [json setValue:[_device toJSON] forKey:@"device"];
    return json;
}

@end
