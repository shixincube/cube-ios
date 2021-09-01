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

#import "CHyperTextMessage.h"

NSString * CFormattedContentText = @"text";

NSString * CFormattedContentAt = @"at";

NSString * CFormattedContentEmoji = @"emoji";


@implementation CFormattedContent

- (instancetype)initWithFormat:(NSString *)format content:(NSString *)content {
    if (self = [super init]) {
        _format = format;
        _content = content;
    }

    return self;
}

@end


@interface CHyperTextMessage ()

- (void)parse:(NSString *)content;

@end


@implementation CHyperTextMessage

- (instancetype)initWithMessage:(CMessage *)message {
    if (self = [super initWithMessage:message]) {
        _formattedContents = [[NSMutableArray alloc] init];
        
        [self.payload setValue:@"hypertext" forKey:@"type"];
        
        _plaintext = [self.payload valueForKey:@"content"];

        [self parse:_plaintext];
    }
    
    return self;
}

- (instancetype)initWithText:(NSString *)text {
    NSDictionary * payload = @{@"type":@"hypertext", @"content":text};

    if (self = [super initWithPayload:payload]) {
        _formattedContents = [[NSMutableArray alloc] init];

        _plaintext = text;

        [self parse:_plaintext];
    }
    
    return self;
}

- (void)parse:(NSString *)content {
    // AT Format: [@ name # id ]
    // Emoji Format: [E desc # code ]
    
    
}

@end
