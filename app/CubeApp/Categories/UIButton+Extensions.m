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

#import "UIButton+Extensions.h"

@implementation UIButton (Extensions)

- (void)setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state {
    [self setBackgroundImage:[UIImage imageWithColor:backgroundColor] forState:state];
}

- (void)setImage:(UIImage *)image imageHighlighted:(UIImage *)imageHighlighted {
    [self setImage:image forState:UIControlStateNormal];
    [self setImage:imageHighlighted forState:UIControlStateHighlighted];
}

- (CGSize)setButtonImagePosition:(CubeButtonImagePosition)position spacing:(CGFloat)spacing {
    CGSize imageSize = self.imageView.image.size;
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : self.titleLabel.font}];

    CGSize buttonSize = CGSizeZero;
    if (position == CubeButtonImagePositionLeft || position == CubeButtonImagePositionRight) {
        if (position == CubeButtonImagePositionLeft) {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, -spacing/2, 0, spacing/2);
            self.titleEdgeInsets = UIEdgeInsetsMake(0, spacing/2, 0, -spacing/2);
        }
        else {
            self.imageEdgeInsets = UIEdgeInsetsMake(0, titleSize.width + spacing/2, 0, -(titleSize.width + spacing/2));
            self.titleEdgeInsets = UIEdgeInsetsMake(0, -(imageSize.height + spacing/2), 0, imageSize.height + spacing/2);
        }
        buttonSize.width = imageSize.width + titleSize.width + spacing;
        buttonSize.height = MAX(imageSize.height, titleSize.height);
    }
    else {
        CGFloat imageOffsetX = titleSize.width > imageSize.width ? (titleSize.width - imageSize.width) / 2.0 : 0;
        CGFloat imageOffsetY = imageSize.height / 2;
        
        
        CGFloat titleOffsetXR = titleSize.width > imageSize.width ? 0 : (imageSize.width - titleSize.width) / 2.0;
        CGFloat titleOffsetX = imageSize.width + titleOffsetXR;
        CGFloat titleOffsetY = titleSize.height / 2;

        if (position == CubeButtonImagePositionTop) {
            self.imageEdgeInsets = UIEdgeInsetsMake(-imageOffsetY, imageOffsetX, imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(titleOffsetY, -titleOffsetX, -titleOffsetY, -titleOffsetXR);
        }
        else {
            self.imageEdgeInsets = UIEdgeInsetsMake(imageOffsetY, imageOffsetX, -imageOffsetY, -imageOffsetX);
            self.titleEdgeInsets = UIEdgeInsetsMake(-titleOffsetY, -titleOffsetX, titleOffsetY, -titleOffsetXR);
        }
        buttonSize.width = MAX(imageSize.width, titleSize.width);
        buttonSize.height = imageSize.height + titleSize.height + spacing;
    }

    return buttonSize;
}

@end
