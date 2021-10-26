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

#import "UIScrollView+Extensions.h"

@implementation UIScrollView (Extensions)

#pragma mark - Content Offset
- (CGFloat)offsetX {
    return self.contentOffset.x;
}
- (void)setOffsetX:(CGFloat)offsetX {
    [self setOffsetX:offsetX animated:NO];
}
- (void)setOffsetX:(CGFloat)offsetX animated:(BOOL)animated {
    CGPoint point = self.contentOffset;
    point.x = offsetX;
    [self setContentOffset:point animated:animated];
}

- (CGFloat)offsetY {
    return self.contentOffset.y;
}
- (void)setOffsetY:(CGFloat)offsetY {
    [self setOffsetY:offsetY animated:NO];
}
- (void)setOffsetY:(CGFloat)offsetY animated:(BOOL)animated {
    CGPoint point = self.contentOffset;
    point.y = offsetY;
    [self setContentOffset:point animated:animated];
}

#pragma mark - Content Size
- (CGFloat)contentWidth {
    return self.contentSize.width;
}
- (void)setContentWidth:(CGFloat)contentWidth {
    CGSize size = self.contentSize;
    size.width = contentWidth;
    [self setContentSize:size];
}

- (CGFloat)contentHeight {
    return self.contentSize.height;
}
- (void)setContentHeight:(CGFloat)contentHeight {
    CGSize size = self.contentSize;
    size.height = contentHeight;
    [self setContentSize:size];
}

#pragma mark - Scroll

- (void)scrollToTopWithAnimation:(BOOL)animation {
    [self setOffsetY:0 animated:animation];
}

- (void)scrollToBottomWithAnimation:(BOOL)animation {
    CGFloat viewHeight = self.frame.size.height;
    if (self.contentHeight > viewHeight) {
        CGFloat offsetY = self.contentHeight - viewHeight;
        [self setOffsetY:offsetY animated:animation];
    }
}

- (void)scrollToLeftWithAnimation:(BOOL)animation {
    [self setOffsetX:0 animated:animation];
}

- (void)scrollToRightWithAnimation:(BOOL)animation {
    CGFloat viewWidth = self.frame.size.width;
    if (self.contentWidth > viewWidth) {
        CGFloat offsetX = self.contentWidth - viewWidth;
        [self setOffsetX:offsetX animated:animation];
    }
}

@end
