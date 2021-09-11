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

#import "CubeTabBarController.h"
#import "CubeConversationViewController.h"
#import "CubeAccount.h"
#import "CubeAccountHelper.h"

@interface CubeTabBarController ()

- (void)loginAndGetAccount:(void (^)(CubeAccount * account))completion;

- (UINavigationController *)addNavigationController:(UIViewController *)viewController;

@end

@implementation CubeTabBarController

- (instancetype)init {
    if (self = [super init]) {
        [self.tabBar setBackgroundColor:[UIColor colorGrayBG]];
        [self.tabBar setTintColor:[UIColor colorBlueDefault]];

        CubeConversationViewController * conversationVC = [[CubeConversationViewController alloc] init];
//        CubeContactsViewController *contactsVC = [[CubeContactsViewController alloc] init];
//        CubeDiscoverViewController *discoverVC = [[CubeDiscoverViewController alloc] init];
//        CubeProfileViewController *profileVC = [[CubeProfileViewController alloc] init];

        NSArray *data = @[
            [self addNavigationController:conversationVC]
        ];
        [self setViewControllers:data];
    }

    if (![[CubeAccountHelper sharedInstance] hasLogin]) {
        NSLog(@"Login with token");
        // 登录
        [self loginAndGetAccount:^(CubeAccount *account) {
            NSLog(@"");
        }];
    }

    return self;
}

- (void)loadView {
    [super loadView];
}

- (void)loginAndGetAccount:(void (^)(CubeAccount *))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        completion(nil);
    });
}

- (UINavigationController *)addNavigationController:(UIViewController *)viewController {
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:viewController];
    return navCtrl;
}

@end
