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
#import "CubeAccountExplorer.h"
#import <Cube/Cube.h>

@interface CubeTabBarController () {
    
    CubeAccountExplorer * _explorer;

}

- (void)setup:(void (^)(void))completion;

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

    return self;
}

- (void)loadView {
    [super loadView];

    _explorer = [[CubeAccountExplorer alloc] init];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self setup:^ {
            NSLog(@"Setup completed");
        }];
    });
}

- (void)setup:(void (^)(void))completion {
    __block BOOL gotAccount = NO;
    __block BOOL gotConfig = NO;
    __block BOOL tipError = NO;

    void (^process)(NSError * error) = ^(NSError * error) {
        if (gotAccount && gotConfig) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completion();
            });
            return;
        }

        if (error && !tipError) {
            tipError = YES;
            NSLog(@"Setup error: %ld", error.code);
            dispatch_async(dispatch_get_main_queue(), ^{
                [CubeUIUtility showErrorHint:@"服务器维护，请稍候再试"];
            });
        }
    };

    // 获取账号数据
    if ([CubeAccountHelper sharedInstance].currentAccount) {
        gotAccount = YES;
        process(nil);
    }
    else {
        [_explorer getAccountWithToken:[CubeAccountHelper sharedInstance].tokenCode success:^(id data) {
            gotAccount = YES;
            process(nil);
        } failure:^(NSError *error) {
            process(error);
        }];
    }

    // 获取配置数据
    if ([CubeAccountHelper sharedInstance].engineConfig) {
        gotConfig = YES;
        process(nil);
    }
    else {
        [_explorer getEngineConfigWithSuccess:^(id data) {
            gotConfig = YES;
            process(nil);
        } failure:^(NSError *error) {
            process(error);
        }];
    }
}

- (UINavigationController *)addNavigationController:(UIViewController *)viewController {
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:viewController];
    return navCtrl;
}

@end
