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

#import "CMessageDraft.h"
#import "CMessage.h"
#import "CContact.h"
#import "CUtils.h"

@implementation CMessageDraft

- (instancetype)initWithContact:(CContact *)contact message:(CMessage *)message {
    if (self = [super initWithId:contact.identity timestamp:[CUtils currentTimeMillis]]) {
        self.ownerId = contact.identity;
        self.message = message;
    }
    return self;
}

- (instancetype)initWithId:(UInt64)identity timestamp:(UInt64)timestamp message:(CMessage *)message {
    if (self = [super initWithId:identity timestamp:timestamp]) {
        self.ownerId = identity;
        self.message = message;
    }
    return self;
}

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithId:[[json valueForKey:@"owner"] unsignedLongLongValue] timestamp:[[json valueForKey:@"time"] unsignedLongLongValue]]) {
        self.ownerId = self.identity;
        self.message = [[CMessage alloc] initWithJSON:[json valueForKey:@"message"]];
    }
    return self;
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [super toJSON];
    [json setValue:[NSNumber numberWithUnsignedLongLong:self.ownerId] forKey:@"owner"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:self.timestamp] forKey:@"time"];
    [json setValue:[self.message toJSON] forKey:@"message"];
    return json;
}

@end
