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

#import "UINavigationItem+Extensions.h"

static UIView * sRawTitleView = nil;
static NSString * sLoadingTitle = nil;

@implementation UINavigationItem (Extensions)

- (void)setNormalTitle:(NSString *)title {
    if (nil != sRawTitleView) {
        self.titleView = sRawTitleView;
        sRawTitleView = nil;
    }

    sLoadingTitle = nil;

    [self setTitle:title];
}

- (void)setLoadingTitle:(NSString *)title {
    if (nil == sRawTitleView) {
        sRawTitleView = self.titleView;
    }

    if (nil != sLoadingTitle && [sLoadingTitle isEqualToString:title]) {
        // 标题相同，返回
        return;
    }

    sLoadingTitle = title;

    CGFloat indicatorSize = 25.0;
    CGRect viewFrame = self.titleView.frame;
    UIView * view = [[UIView alloc] initWithFrame:viewFrame];

    UILabel * titleView = view.addLabel(1001)
        .text(title)
        .font([UIFont systemFontOfSize:17.0])
        .masonry(^(__kindof UIView *sender, MASConstraintMaker *make) {
            make.centerX.mas_equalTo(0).mas_offset(indicatorSize - 10);
            make.centerY.mas_equalTo(0);
        })
        .view;

    CGRect frame = CGRectMake(0.0, 0.0, indicatorSize, indicatorSize);
    UIActivityIndicatorView * av = [[UIActivityIndicatorView alloc] initWithFrame:frame];
    av.tag = 2001;
    av.color = [UIColor grayColor];
    av.activityIndicatorViewStyle = UIActivityIndicatorViewStyleMedium;
    [view addSubview:av];

    [av mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.right.mas_equalTo(titleView.mas_left).mas_offset(-10);
    }];
    [av startAnimating];

    self.titleView = view;
}

@end
