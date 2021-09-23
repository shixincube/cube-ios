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

#import "UIFont+Cube.h"

@implementation UIFont (Cube)

+ (UIFont *) fontNavBarTitle {
    return [UIFont boldSystemFontOfSize:17.5f];
}

+ (UIFont *) fontConversationName {
    return [UIFont systemFontOfSize:17.0f];
}

+ (UIFont *) fontConversationDetail {
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *) fontConversationTime {
    return [UIFont systemFontOfSize:12.5f];
}

+ (UIFont *) fontContactsName {
    return [UIFont systemFontOfSize:17.0f];
}

+ (UIFont *) fontProfileNikename {
    return [UIFont systemFontOfSize:17.0f];
}

+ (UIFont *) fontProfileUsername {
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *) fontSettingHeaderAndFooterTitle {
    return [UIFont systemFontOfSize:14.0f];
}

+ (UIFont *) fontTextMessageText {
    CGFloat size = [[NSUserDefaults standardUserDefaults] doubleForKey:@"CHAT_FONT_SIZE"];
    if (size == 0) {
        size = 16.0f;
    }
    return [UIFont systemFontOfSize:size];
}

@end
