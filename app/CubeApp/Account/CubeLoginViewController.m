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

#import "CubeLoginViewController.h"
#import "CubeAppUtil.h"

#define     HEIGHT_ITEM     45.0f
#define     EDGE_LINE       20.0f
#define     WIDTH_TITLE     90.0f
#define     EDGE_DETAIL     15.0f

@interface CubeLoginViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIButton * cancelButton;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * originTitleLabel;
@property (nonatomic, strong) UILabel * originLabel;

@property (nonatomic, strong) UILabel * districtNumberLabel;
@property (nonatomic, strong) UITextField * phoneNumberTextField;

@property (nonatomic, strong) UILabel * passwordTitleLabel;
@property (nonatomic, strong) UITextField * passwordTextField;

@property (nonatomic, strong) UIButton * loginButton;

@property (nonatomic, strong) NSMutableArray * countryArray;

- (void)makeMasonry;

@end


@implementation CubeLoginViewController

- (void)loadView {
    [super loadView];

    self.countryArray = [NSMutableArray arrayWithObjects:@"中国", @"巴基斯坦", @"马来西亚", @"美国", @"英国", nil];

    self.statusBarStyle = UIStatusBarStyleDefault;
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.cancelButton];
    [self.scrollView addSubview:self.titleLabel];
    [self.scrollView addSubview:self.originTitleLabel];
    [self.scrollView addSubview:self.originLabel];
    [self.scrollView addSubview:self.districtNumberLabel];
    [self.scrollView addSubview:self.phoneNumberTextField];
    [self.scrollView addSubview:self.passwordTitleLabel];
    [self.scrollView addSubview:self.passwordTextField];
    [self.scrollView addSubview:self.loginButton];

    [self makeMasonry];
    
    // 键盘控制
    UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapView)];
    [self.scrollView addGestureRecognizer:tapGR];

    [self.scrollView setContentSize:CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + BORDER_WIDTH_1PX)];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self didTapView];
}

#pragma mark - Event Response

- (void)cancelButtonTouchUp:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)loginButtonTouchUp:(UIButton *)sender {
    NSString *phoneNumber = self.phoneNumberTextField.text;
    if (phoneNumber.length != 11 || ![phoneNumber hasPrefix:@"1"]) {
        [CubeUIUtility showErrorHint:@"请输入正确的手机号码"];
        return;
    }
    
    // 密码
    NSString * password = self.passwordTextField.text;
    if (password.length < 8) {
        [CubeUIUtility showErrorHint:@"请输入至少8位的登录密码"];
        return;
    }

    // 密码 MD5
    NSString * passwordMD5 = [CubeAppUtil makeMD5:password];

    [CubeUIUtility showLoading:nil];
    
    CWeakSelf(self);
    [self.explorer loginWithPhoneNumber:phoneNumber password:passwordMD5 success:^(id data) {
        if (weak_self.loginSuccess) {
            weak_self.loginSuccess();
        }
    } failure:^(NSError *error) {
        NSString * hint = [NSString stringWithFormat:@"登录失败: %ld", error.code];
        [CubeUIUtility showErrorHint:hint];

        if (weak_self.loginFailure) {
            weak_self.loginFailure(error);
        }
    }];
}

- (void)didTapView {
    [CubeUIUtility hideLoading];

    [self.phoneNumberTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
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
    
    UIView *(^createLine)(void) = ^UIView *() {
        UIView *view = [[UIView alloc] init];
        view.tkThemebackgroundColors = @[[UIColor colorGrayLine], [UIColor colorDarkGrayLine]];
        return view;
    };

    [self.originTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(EDGE_LINE);
        make.height.mas_equalTo(HEIGHT_ITEM);
        make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_equalTo(55);
        make.width.mas_equalTo(WIDTH_TITLE);
    }];
    [self.originLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.originTitleLabel.mas_right).mas_offset(EDGE_DETAIL);
        make.centerY.mas_equalTo(self.originTitleLabel);
        make.height.mas_equalTo(HEIGHT_ITEM);
        make.right.mas_equalTo(self.view).mas_offset(-EDGE_LINE);
    }];
    
    // 地区和号码的分隔线
    UIView * dnLine = createLine();
    [self.scrollView addSubview:dnLine];
    [dnLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.originTitleLabel.mas_bottom);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(self.scrollView).mas_offset(-EDGE_LINE * 2);
        make.height.mas_equalTo(BORDER_WIDTH_1PX);
    }];
    [self.districtNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(dnLine.mas_bottom);
        make.left.mas_equalTo(dnLine);
        make.height.mas_equalTo(HEIGHT_ITEM);
        make.width.mas_equalTo(WIDTH_TITLE);
    }];
    
    // 区号和号码的分隔线
    UIView * phLine = createLine();
    [self.scrollView addSubview:phLine];
    [phLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.height.mas_equalTo(self.districtNumberLabel);
        make.left.mas_equalTo(self.districtNumberLabel.mas_right);
        make.width.mas_equalTo(BORDER_WIDTH_1PX);
    }];
    [self.phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.originLabel);
        make.centerY.mas_equalTo(self.districtNumberLabel);
        make.height.mas_equalTo(HEIGHT_ITEM);
        make.right.mas_equalTo(self.view).mas_offset(-EDGE_LINE);
    }];
    
    // 密码分隔线
    UIView * pwdLine = createLine();
    [self.scrollView addSubview:pwdLine];
    [pwdLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.districtNumberLabel.mas_bottom);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(self.scrollView).mas_offset(-EDGE_LINE * 2);
        make.height.mas_equalTo(BORDER_WIDTH_1PX);
    }];
    
    [self.passwordTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(pwdLine);
        make.top.mas_equalTo(pwdLine.mas_bottom);
        make.height.mas_equalTo(HEIGHT_ITEM);
        make.width.mas_equalTo(self.districtNumberLabel);
    }];
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.originLabel);
        make.centerY.mas_equalTo(self.passwordTitleLabel);
        make.height.mas_equalTo(HEIGHT_ITEM);
        make.right.mas_equalTo(self.view).mas_offset(-EDGE_LINE);
    }];
    
    UIView * btnLine = createLine();
    [self.scrollView addSubview:btnLine];
    [btnLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.passwordTitleLabel.mas_bottom);
        make.left.mas_equalTo(EDGE_LINE);
        make.width.mas_equalTo(self.scrollView).mas_offset(-EDGE_LINE * 2);
        make.height.mas_equalTo(BORDER_WIDTH_1PX);
    }];

    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(btnLine);
        make.height.mas_equalTo(HEIGHT_ITEM);
        make.top.mas_equalTo(btnLine.mas_bottom).mas_offset(HEIGHT_ITEM);
    }];
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.tkThemebackgroundColors = @[[UIColor colorGrayBG], [UIColor colorDarkBG]];
    }

    return _scrollView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = UIButton.zz_create(1)
            .backgroundColor([UIColor colorThemeBlue])
            .title(@"取消")
            .titleFont([UIFont systemFontOfSize:16])
            .cornerRadius(3.0f)
            .view;
        [_cancelButton addTarget:self action:@selector(cancelButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _cancelButton;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = UILabel.zz_create(2)
            .text(@"使用手机号码登录")
            .font([UIFont systemFontOfSize:28])
            .view;
        _titleLabel.tkThemetextColors = @[[UIColor blackColor], [UIColor colorDarkTextWhite]];
    }
    
    return _titleLabel;
}

- (UILabel *)originTitleLabel {
    if (!_originTitleLabel) {
        _originTitleLabel = UILabel.zz_create(3)
           .text(@"国家/地区")
           .font([UIFont systemFontOfSize:17])
           .view;
        _originTitleLabel.tkThemetextColors = @[[UIColor blackColor], [UIColor colorDarkTextWhite]];
    }

    return _originTitleLabel;
}

- (UILabel *)originLabel {
    if (!_originLabel) {
        _originLabel = UILabel.zz_create(4)
            .text(@"中国")
            .font([UIFont systemFontOfSize:17])
            .view;
        _originLabel.tkThemetextColors = @[[UIColor blackColor], [UIColor colorDarkTextWhite]];
    }

    return _originLabel;
}

- (UILabel *)districtNumberLabel {
    if (!_districtNumberLabel) {
        _districtNumberLabel = UILabel.zz_create(5)
            .text(@"+86")
            .font([UIFont systemFontOfSize:17])
            .view;
        _districtNumberLabel.tkThemetextColors = @[[UIColor blackColor], [UIColor colorDarkTextWhite]];
    }

    return _districtNumberLabel;
}

- (UITextField *)phoneNumberTextField {
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = UITextField.zz_create(6)
            .placeholder(@"请填写手机号码")
            .clearButtonMode(UITextFieldViewModeWhileEditing)
            .keyboardType(UIKeyboardTypePhonePad)
            .view;
        _phoneNumberTextField.tkThemetextColors = @[[UIColor blackColor], [UIColor colorDarkTextWhite]];
        _phoneNumberTextField.tkThemeChangeBlock = ^(id _Nullable itself, NSUInteger themeIndex) {
            UITextField * tf = (UITextField *) itself;
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
            if (0 == themeIndex) {
                attrs[NSForegroundColorAttributeName] = [UIColor colorTextPlaceholder];
            }
            else {
                attrs[NSForegroundColorAttributeName] = [UIColor colorDarkTextPlaceholder];
            }
            NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"请填写手机号码" attributes:attrs];
            tf.attributedPlaceholder = attStr;
        };
    }

    return _phoneNumberTextField;
}

- (UILabel *)passwordTitleLabel {
    if (!_passwordTitleLabel) {
        _passwordTitleLabel = UILabel.zz_create(7)
            .text(@"密码")
            .font([UIFont systemFontOfSize:17])
            .view;
        _passwordTitleLabel.tkThemetextColors = @[[UIColor blackColor], [UIColor colorDarkTextWhite]];
    }

    return _passwordTitleLabel;
}

- (UITextField *)passwordTextField {
    if (!_passwordTextField) {
        _passwordTextField = UITextField.zz_create(8)
            .placeholder(@"请填写密码")
            .clearButtonMode(UITextFieldViewModeWhileEditing)
            .view;
        _passwordTextField.textContentType = UITextContentTypeOneTimeCode;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.tkThemetextColors = @[[UIColor blackColor], [UIColor colorDarkTextWhite]];
        _passwordTextField.tkThemeChangeBlock = ^(id _Nullable itself, NSUInteger themeIndex) {
            UITextField * tf = (UITextField *) itself;
            NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
            attrs[NSFontAttributeName] = [UIFont systemFontOfSize:17];
            if (0 == themeIndex) {
                attrs[NSForegroundColorAttributeName] = [UIColor colorTextPlaceholder];
            }
            else {
                attrs[NSForegroundColorAttributeName] = [UIColor colorDarkTextPlaceholder];
            }
            NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:@"请填写密码" attributes:attrs];
            tf.attributedPlaceholder = attStr;
        };
    }

    return _passwordTextField;
}

- (UIButton *)loginButton {
    if (!_loginButton) {
        _loginButton = UIButton.zz_create(9)
            .masksToBounds(YES)
            .cornerRadius(4.0f)
            .borderWidth(BORDER_WIDTH_1PX)
            .backgroundColor([UIColor colorThemeBlue])
            .titleFont([UIFont systemFontOfSize:16.0f])
            .title(@"登录")
            .view;
        [_loginButton addTarget:self action:@selector(loginButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    }

    return _loginButton;
}

@end
