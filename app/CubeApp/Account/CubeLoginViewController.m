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

#import "CubeLoginViewController.h"

#define     HEIGHT_ITEM     45.0f
#define     EDGE_LINE       20.0f
#define     WIDTH_TITLE     90.0f
#define     EDGE_DETAIL     15.0f

@interface CubeLoginViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIButton * cancelButton;

@property (nonatomic, strong) UILabel * titleLabel;

- (void)makeMasonry;

@end


@implementation CubeLoginViewController

- (void)loadView {
    [super loadView];
    
    self.statusBarStyle = UIStatusBarStyleDefault;
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.cancelButton];
    [self.scrollView addSubview:self.titleLabel];
    
    [self makeMasonry];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - Event Response

- (void)cancelButtonClicked:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Private
   
- (void)makeMasonry {
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(10);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(80);
    }];

    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(NAVBAR_HEIGHT + STATUSBAR_HEIGHT + 10);
        make.centerX.mas_equalTo(0);
        make.width.mas_lessThanOrEqualTo(self.scrollView);
    }];
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
    }

    return _scrollView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = UIButton.zz_create(1)
            .backgroundColor([UIColor colorGreenDefault])
            .title(@"取消")
            .titleFont([UIFont systemFontOfSize:16])
            .cornerRadius(3.0f)
            .view;
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _cancelButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.zz_create(2)
            .text(@"使用手机号码登录")
            .font([UIFont systemFontOfSize:28])
            .view;
    }
    
    return _titleLabel;
}

@end
