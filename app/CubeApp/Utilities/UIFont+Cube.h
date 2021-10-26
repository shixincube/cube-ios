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

#ifndef UIFont_Cube_h
#define UIFont_Cube_h

#import <UIKit/UIKit.h>

@interface UIFont (Cube)

#pragma mark - Common

+ (UIFont *)fontNavBarTitle;


#pragma mark - Conversation

+ (UIFont *)fontConversationName;
+ (UIFont *)fontConversationDetail;
+ (UIFont *)fontConversationTime;


#pragma mark - Contacts

+ (UIFont *)fontContactsName;

#pragma mark - Profile

+ (UIFont *)fontProfileNikename;
+ (UIFont *)fontProfileUsername;


#pragma mark - Setting

+ (UIFont *)fontSettingHeaderAndFooterTitle;


#pragma mark - Chat

+ (UIFont *)fontTextMessageText;

@end

#endif /* UIFont_Cube_h */
