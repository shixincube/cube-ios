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

#ifndef UIScrollView_Extensions_h
#define UIScrollView_Extensions_h

#import <UIKit/UIKit.h>

@interface UIScrollView (Extensions)

#pragma mark - Content Offset
@property (nonatomic, assign) CGFloat offsetX;
- (void)setOffsetX:(CGFloat)offsetX animated:(BOOL)animated;

@property (nonatomic, assign) CGFloat offsetY;
- (void)setOffsetY:(CGFloat)offsetY animated:(BOOL)animated;


#pragma mark - Content Size

@property (nonatomic, assign) CGFloat contentWidth;
@property (nonatomic, assign) CGFloat contentHeight;


#pragma mark - Scroll
/*!
 * @brief 滚动到最顶端
 */
- (void)scrollToTopWithAnimation:(BOOL)animation;
/*!
 * @brief 滚动到最底端
 */
- (void)scrollToBottomWithAnimation:(BOOL)animation;
/*!
 * @brief 滚动到最左端
 */
- (void)scrollToLeftWithAnimation:(BOOL)animation;
/*!
 * @brief 滚动到最右端
 */
- (void)scrollToRightWithAnimation:(BOOL)animation;

@end

#endif /* UIScrollView_Extensions_h */
