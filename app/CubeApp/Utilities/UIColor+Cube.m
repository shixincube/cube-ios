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

#import "UIColor+Cube.h"
#import "CubeShortcutMacros.h"

@implementation UIColor (Cube)

#pragma mark - 文本颜色
+ (UIColor *)colorTextBlack {
    return [UIColor blackColor];
}

+ (UIColor *)colorTextWhite {
    return RGBAColor(240, 240, 240, 1.0);
}

+ (UIColor *)colorTextGray {
    return [UIColor grayColor];
}

+ (UIColor *)colorTextLightGray {
    return RGBAColor(160, 160, 160, 1.0);
}

#pragma mark - 灰色
+ (UIColor *)colorGrayBG {
    return RGBAColor(239, 239, 244, 1.0);
}

+ (UIColor *)colorGrayCharcoalBG {
    return RGBAColor(235, 235, 235, 1.0);
}

+ (UIColor *)colorGrayLine {
    return [UIColor colorWithWhite:0.5 alpha:0.3];
}

+ (UIColor *)colorGrayForChatBar {
    return RGBAColor(245, 245, 247, 1.0);
}

+ (UIColor *)colorGrayForMoment {
    return RGBAColor(243, 243, 245, 1.0);
}

#pragma mark - 主题色
+ (UIColor *)colorThemeBlue {
    return RGBAColor(40, 125, 246, 1.0f);
}

+ (UIColor *)colorThemeBlueHighlighted {
    return RGBAColor(9, 84, 230, 1.0f);
}

#pragma mark - 蓝色
+ (UIColor *)colorBlueMoment {
    return RGBAColor(74, 99, 141, 1.0);
}

#pragma mark - 黑色
+ (UIColor *)colorBlackForNavBar {
    return RGBAColor(20, 20, 20, 1.0);
}

+ (UIColor *)colorBlackBG {
    return RGBAColor(46, 49, 50, 1.0);
}

+ (UIColor *)colorBlackAlphaScannerBG {
    return [UIColor colorWithWhite:0 alpha:0.6];
}

+ (UIColor *)colorBlackForAddMenu {
    return RGBAColor(71, 70, 73, 1.0);
}

+ (UIColor *)colorBlackForAddMenuHL {
    return RGBAColor(65, 64, 67, 1.0);
}


#pragma mark - 红色
+ (UIColor *)colorRedForButton {
    return RGBColor(228, 68, 71);
}

+ (UIColor *)colorRedForButtonHL {
    return RGBColor(205, 62, 64);
}

@end
