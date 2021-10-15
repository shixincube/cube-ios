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

#import "CAuthToken.h"

#pragma mark - CPrimaryDescription

@implementation CPrimaryDescription

- (instancetype)initWithAddress:(NSString *)address primaryContent:(NSDictionary *)primaryContent {
    if (self = [super init]) {
        self.address = address;
        self.primaryContent = primaryContent;
    }
    
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super init]) {
        self.address = [json objectForKey:@"address"];
        self.primaryContent = json[@"primaryContent"];
    }
    return self;
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [[NSMutableDictionary alloc] init];
    [json setValue:self.address forKey:@"address"];
    [json setValue:self.primaryContent forKey:@"primaryContent"];
    return json;
}

- (NSMutableDictionary *)toCompactJSON {
    return [self toJSON];
}

@end


#pragma mark - CAuthToken

@implementation CAuthToken

@synthesize description = _description;

- (CPrimaryDescription *)description {
    return _description;
}

- (void)setDescription:(CPrimaryDescription *)description {
    _description = description;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super init]) {
        self.code = [json objectForKey:@"code"];
        self.domain = [json objectForKey:@"domain"];
        self.appKey = [json objectForKey:@"appKey"];
        self.cid = [[json objectForKey:@"cid"] unsignedLongLongValue];
        self.issues = [[json objectForKey:@"issues"] unsignedLongLongValue];
        self.expiry = [[json objectForKey:@"expiry"] unsignedLongLongValue];
        self.description = [[CPrimaryDescription alloc] initWithJSON:json[@"description"]];
    }

    return self;
}

- (BOOL)isValid {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 1000.0f;
    UInt64 timestamp = [[NSNumber numberWithDouble:time] unsignedLongLongValue];
    return ((timestamp + 60000) < self.expiry);
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [[NSMutableDictionary alloc] init];
    [json setValue:self.code forKey:@"code"];
    [json setValue:self.domain forKey:@"domain"];
    [json setValue:self.appKey forKey:@"appKey"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:self.cid] forKey:@"cid"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:self.issues] forKey:@"issues"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:self.expiry] forKey:@"expiry"];
    [json setValue:[self.description toJSON] forKey:@"description"];
    return json;
}

- (NSMutableDictionary *)toCompactJSON {
    return [self toJSON];
}

@end
