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
#import "NSString+Cube.h"
#import "CUtils.h"

NSString * CFormattedContentText = @"text";

NSString * CFormattedContentAt = @"at";

NSString * CFormattedContentEmoji = @"emoji";


@implementation CFormattedContent

- (instancetype)initWithFormat:(NSString *)format content:(NSDictionary *)content {
    if (self = [super init]) {
        _format = format;
        _content = content;
    }

    return self;
}

@end


@interface CHyperTextMessage ()

- (void)parse:(NSString *)input;

/*! @brief 分析 Emoji 格式。 */
- (NSDictionary *)parseEmoji:(NSString *)input;

/*! @brief 分析 AT 格式。 */
- (NSDictionary *)parseAt:(NSString *)input;

@end


@implementation CHyperTextMessage

- (instancetype)initWithMessage:(CMessage *)message {
    if (self = [super initWithMessage:message]) {
        _formattedContents = [[NSMutableArray alloc] init];

        if (![self.payload objectForKey:@"type"]) {
            [self.payload setValue:@"hypertext" forKey:@"type"];
        }

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

        [self parse:text];
    }
    
    return self;
}

+ (CHyperTextMessage *)messageWithText:(NSString *)text {
    return [[CHyperTextMessage alloc] initWithText:text];
}

#pragma mark - Getters

- (NSString *)summary {
    return _plaintext;
}

- (CMessageType)type {
    return CMessageTypeText;
}

#pragma mark - Private

- (void)parse:(NSString *)input {
    // AT Format: [@ name # id ]
    // Emoji Format: [E desc # code ]
    
    BOOL phaseEmoji = FALSE;
    BOOL phaseAt = FALSE;
    CellByteBuffer * content = [[CellByteBuffer alloc] initWithCapacity:128];
    CellByteBuffer * string = [[CellByteBuffer alloc] initWithCapacity:32];

    const char * inputArray = [input cStringUsingEncoding:NSUTF8StringEncoding];
    size_t length = strlen(inputArray);

    for (size_t i = 0; i < length; ++i) {
        char c = inputArray[i];
        if (c == '\\') {
            // 转义
            c = inputArray[++i];
            if (!phaseEmoji && !phaseAt) {
                [content put:c];
            }
            else {
                [string put:c];
            }
        }
        else if (c == '[') {
            char next = inputArray[i+1];
            if (next == 'E') {
                // 记录之前缓存里的文本数据
                [content flip];
                NSString * data = [CUtils byteBufferToString:content];
                CFormattedContent * fc = [[CFormattedContent alloc] initWithFormat:CFormattedContentText
                                                                           content:@{ @"text": data }];
                [_formattedContents addObject:fc];
                [content clear];

                phaseEmoji = TRUE;
                ++i;
            }
            else if (next == '@') {
                // 记录之前缓存里的文本数据
                [content flip];
                NSString * data = [CUtils byteBufferToString:content];
                CFormattedContent * fc = [[CFormattedContent alloc] initWithFormat:CFormattedContentText
                                                                           content:@{ @"text": data }];
                [_formattedContents addObject:fc];
                [content clear];

                phaseAt = TRUE;
                ++i;
            }
        }
        else if (c == ']') {
            if (phaseEmoji) {
                phaseEmoji = FALSE;
                [string flip];
                NSString * data = [CUtils byteBufferToString:string];
                NSDictionary * emojiResult = [self parseEmoji:data];
                [string clear];
                
                CFormattedContent * fc = [[CFormattedContent alloc] initWithFormat:CFormattedContentEmoji
                                                                           content:emojiResult];
                [_formattedContents addObject:fc];
            }
            else if (phaseAt) {
                phaseAt = FALSE;
                [string flip];
                NSString * data = [CUtils byteBufferToString:string];
                NSDictionary * atResult = [self parseAt:data];
                [string clear];

                CFormattedContent * fc = [[CFormattedContent alloc] initWithFormat:CFormattedContentAt
                                                                           content:atResult];
                [_formattedContents addObject:fc];
            }
        }
        else {
            if (!phaseEmoji && !phaseAt) {
                [content put:c];
            }
            else {
                [string put:c];
            }
        }
    }

    if (content.position > 0) {
        [content flip];
        NSString * data = [CUtils byteBufferToString:content];
        CFormattedContent * fc = [[CFormattedContent alloc] initWithFormat:CFormattedContentText
                                                                   content:@{ @"text": data }];
        [_formattedContents addObject:fc];
    }
    [content clear];

    // 生成平滑文本
    NSMutableString * plain = [[NSMutableString alloc] init];
    for (CFormattedContent * fc in _formattedContents) {
        if ([fc.format isEqualToString:CFormattedContentText]) {
            NSString * text = [fc.content valueForKey:@"text"];
            [plain appendString:text];
        }
        else if ([fc.format isEqualToString:CFormattedContentEmoji]) {
            [plain appendString:@"["];
            NSString * text = [fc.content valueForKey:@"desc"];
            [plain appendString:text];
            [plain appendString:@"]"];
        }
        else if ([fc.format isEqualToString:CFormattedContentAt]) {
            [plain appendString:@" @"];
            NSString * text = [fc.content valueForKey:@"name"];
            [plain appendString:text];
            [plain appendString:@" "];
        }
    }

    _plaintext = [NSString stringWithString:plain];
}

- (NSDictionary *)parseEmoji:(NSString *)input {
    // Format: [ desc # code ]
    NSInteger index = [input lastIndexOfChar:'#'];
    NSDictionary * result = @{@"desc": [input substringToIndex:index],
                              @"code": [input substringFromIndex:index + 1]};
    return result;
}

- (NSDictionary *)parseAt:(NSString *)input {
    // Format: [ name # id ]
    NSInteger index = [input lastIndexOfChar:'#'];
    NSDictionary * result = @{@"name": [input substringToIndex:index],
                              @"id": [input substringFromIndex:index + 1]};
    return result;
}

@end
