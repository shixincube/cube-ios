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

#ifndef UIButton_Extensions_h
#define UIButton_Extensions_h

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CubeButtonImagePosition) {
    CubeButtonImagePositionLeft = 0,              //图片在左，文字在右，默认
    CubeButtonImagePositionRight = 1,             //图片在右，文字在左
    CubeButtonImagePositionTop = 2,               //图片在上，文字在下
    CubeButtonImagePositionBottom = 3,            //图片在下，文字在上
};

@interface UIButton (Extensions)

/*!
 * @brief 设置Button的背景色。
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

/*!
 * @brief 快捷设置图片。
 */
- (void)setImage:(UIImage *)image imageHighlighted:(UIImage *)imageHighlighted;


/*!
 * @brief 设置 Image 和 Title 图文混排。
 * @param  position    图片的位置，默认left
 * @param  spacing     图片和标题的间隔
 * @return 返回button最小的size
 * @note 注意，需要先设置好image、title、font。网络图片需要下载完成后再调用此方法，或设置同大小的placeholder
 */
- (CGSize)setButtonImagePosition:(CubeButtonImagePosition)position spacing:(CGFloat)spacing;

@end

#endif /* UIButton_Extensions_h */
