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

#import "UIView+Extensions.h"

@implementation UIView (Extensions)

- (void)removeAllSubviews {
    for (UIView * view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (void)cornerRadiusWithRoundingCorners:(UIRectCorner)corners radius:(CGFloat)radius {
//    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:CGSizeMake(radius, radius)];
//    CAShapeLayer * maskLayer = [[CAShapeLayer alloc] init];
//    maskLayer.path = maskPath.CGPath;
//    maskLayer.frame = self.bounds;
//    self.layer.mask = maskLayer;

    /*
     kCALayerMinXMinYCorner = 1U << 0,
     kCALayerMaxXMinYCorner = 1U << 1,
     kCALayerMinXMaxYCorner = 1U << 2,
     kCALayerMaxXMaxYCorner = 1U << 3,
     */

    CACornerMask cm = 0;
    if (corners == UIRectCornerAllCorners) {
        cm = kCALayerMinXMinYCorner | kCALayerMaxXMinYCorner | kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
    }
    else {
        if (corners & UIRectCornerTopLeft) {
            if (cm == 0) cm = kCALayerMinXMinYCorner;
            else cm |= kCALayerMinXMinYCorner;
        }

        if (corners & UIRectCornerTopRight) {
            if (cm == 0) cm = kCALayerMaxXMinYCorner;
            else cm |= kCALayerMaxXMinYCorner;
        }

        if (corners & UIRectCornerBottomLeft) {
            if (cm == 0) cm = kCALayerMinXMaxYCorner;
            else cm |= kCALayerMinXMaxYCorner;
        }

        if (corners & UIRectCornerBottomRight) {
            if (cm == 0) cm = kCALayerMaxXMaxYCorner;
            else cm |= kCALayerMaxXMaxYCorner;
        }
    }

    self.clipsToBounds = YES;
    self.layer.cornerRadius = radius;
    self.layer.maskedCorners = cm;
}

@end
