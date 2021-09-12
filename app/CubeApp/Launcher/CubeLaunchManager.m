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

#import "CubeLaunchManager.h"
#import "CubeAccountViewController.h"
#import "CubeTabBarController.h"
#import "SceneDelegate.h"
#import "CubeAccountHelper.h"

@interface CubeLaunchManager ()

@property (nonatomic, weak) UIWindowScene * windowScene;

@property (nonatomic, weak) UIWindow * window;

- (void)launch;

- (void)setRootVC:(__kindof UIViewController *)rootVC;

@end

@implementation CubeLaunchManager

+ (CubeLaunchManager *)sharedInstance {
    static CubeLaunchManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CubeLaunchManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)launchInWindowScene:(UIWindowScene *)windowScene {
    self.windowScene = windowScene;

    [self launch];
}

- (void)launchInWindow:(id)window {
    self.window = window;

    [self launch];
}

#pragma mark - Private

- (void)launch {
    NSString * tokenCode = [CubeAccountHelper sharedInstance].tokenCode;
    if (tokenCode) {
        // 有 Token Code，使用 Token Code 进行操作
        CubeTabBarController * tabBarVC = [[CubeTabBarController alloc] init];
        [self setRootVC:tabBarVC];
    }
    else {
        // 未登录
        CubeAccountViewController * accountVC = [[CubeAccountViewController alloc] init];
        @weakify(self);
        [accountVC setLoginSuccess:^ {
            @strongify(self);
            [self launch];
        }];

        [self setRootVC:accountVC];
    }
}

- (void)setRootVC:(__kindof UIViewController *)rootVC {
    _rootVC = rootVC;

    UIWindow * window = nil;
    if (self.window) {
        window = self.window;
    }
    else {
        SceneDelegate * sceneDelegate = (SceneDelegate *)[[UIApplication sharedApplication].connectedScenes allObjects][0].delegate;
        window = sceneDelegate.window;
    }

    [window removeAllSubviews];
    [window setRootViewController:rootVC];
    [window addSubview:rootVC.view];
    [window makeKeyAndVisible];
}

@end
