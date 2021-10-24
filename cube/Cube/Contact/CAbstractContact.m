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

#import "CAbstractContact.h"

@implementation CAbstractContact

- (instancetype)initWithId:(UInt64)identity name:(NSString *)name domain:(NSString *)domain {
    if (self = [super initWithId:identity]) {
        self.name = name;
        self.domain = domain;
    }

    return self;
}

- (instancetype)initWithId:(UInt64)identity name:(NSString *)name domain:(NSString *)domain timestamp:(UInt64)timestamp {
    if (self = [super initWithId:identity timestamp:timestamp]) {
        self.name = name;
        self.domain = domain;
    }

    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithJSON:json]) {
        if ([json objectForKey:@"name"]) {
            self.name = [json valueForKey:@"name"];
        }
        if ([json objectForKey:@"domain"]) {
            self.domain = [json valueForKey:@"domain"];
        }

        if ([json objectForKey:@"context"]) {
            self.context = [json valueForKey:@"context"];
        }
    }

    return self;
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [super toJSON];
    [json setValue:self.name forKey:@"name"];
    [json setValue:self.domain forKey:@"domain"];

    if (nil != self.context) {
        [json setValue:self.context forKey:@"context"];
    }

    return json;
}

- (NSMutableDictionary *)toCompactJSON {
    return [self toJSON];
}

@end
