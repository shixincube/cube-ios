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

#import "CubeAccountViewController.h"
#import "CubeLoginViewController.h"

#define HEIGHT_BUTTON  50
#define EDGE_BUTTON    35

/*!
 * 按钮标签枚举
 */
typedef NS_ENUM(NSInteger, CubeAccountButtonTag) {
    CubeAccountButtonTagRegister,
    CubeAccountButtonTagLogin,
    CubeAccountButtonTagTest
};


@implementation CubeAccountViewController

- (void)loadView {
    [super loadView];

    UIImage * image = [UIImage imageNamed:@"AccountBG"];
    self.view.addImageView(1).image(image).masonry(^(__kindof UIView *sender, MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    });

    UIButton * (^createButton)(NSString *title, UIColor *bgColor, NSInteger tag) = ^UIButton * (NSString *title, UIColor *bgColor, NSInteger tag) {
        UIButton * button = UIButton.zz_create(tag)
            .backgroundColor(bgColor)
            .title(title)
            .titleFont([UIFont systemFontOfSize:19])
            .cornerRadius(5.0f)
            .view;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        return button;
    };

    // 注册按钮
    UIButton *registerButton = createButton(@"注 册", [UIColor redColor], CubeAccountButtonTagRegister);
    [self.view addSubview:registerButton];
    [registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(EDGE_BUTTON);
        make.bottom.mas_equalTo(-EDGE_BUTTON * 2);
        make.width.mas_equalTo((SCREEN_WIDTH - EDGE_BUTTON * 3) / 2);
        make.height.mas_equalTo(HEIGHT_BUTTON);
    }];
    
    // 登录按钮
    UIButton *loginButton = createButton(@"登 录", [UIColor colorGreenDefault], CubeAccountButtonTagLogin);
    [self.view addSubview:loginButton];
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-EDGE_BUTTON);
        make.size.and.bottom.mas_equalTo(registerButton);
    }];
}


#pragma mark - Event Response

- (void)buttonClicked:(UIButton *)sender {
    if (sender.tag == CubeAccountButtonTagRegister) {
        
    }
    else if (sender.tag == CubeAccountButtonTagLogin) {
        CubeLoginViewController * loginVC = [[CubeLoginViewController alloc] init];
//        CWeakSelf(self);
//        CWeakSelf(loginVC);
        // TODO
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

@end
