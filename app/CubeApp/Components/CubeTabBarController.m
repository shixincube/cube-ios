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

#import "CubeTabBarController.h"
#import "CubeConversationViewController.h"
#import "CubeFilesViewController.h"
#import "CubeContactsViewController.h"
#import "CubeProfileViewController.h"
#import "CubeAccount.h"
#import "CubeAccountHelper.h"
#import "CubeContactsHelper.h"
#import "CubeExplorer.h"
#import <Cube/Cube.h>

@interface CubeTabBarController () {
    
    CubeExplorer * _explorer;

}

- (void)setup;

- (UINavigationController *)addNavigationController:(UIViewController *)viewController;

@end

@implementation CubeTabBarController

- (instancetype)init {
    if (self = [super init]) {
        [self.tabBar setBackgroundColor:[UIColor colorGrayBG]];
        [self.tabBar setTintColor:[UIColor colorThemeBlue]];

        CubeConversationViewController * conversationVC = [[CubeConversationViewController alloc] init];
        CubeFilesViewController * filesVC = [[CubeFilesViewController alloc] init];
        CubeContactsViewController * contactsVC = [[CubeContactsViewController alloc] init];
        CubeProfileViewController *profileVC = [[CubeProfileViewController alloc] init];

        NSArray *data = @[
            [self addNavigationController:conversationVC],
            [self addNavigationController:filesVC],
            [self addNavigationController:contactsVC],
            [self addNavigationController:profileVC]
        ];
        [self setViewControllers:data];
    }

    return self;
}

- (void)loadView {
    [super loadView];

    _explorer = [CubeAccountHelper sharedInstance].explorer;

    CubeAccount * current = [CubeAccountHelper sharedInstance].currentAccount;
    NSDictionary * config = [CubeAccountHelper sharedInstance].engineConfig;
    if (current && config) {
        [self setup];
    }
    else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [self requestData:^ {
                NSLog(@"Request data completed");
                // 启动引擎
                [self setup];
            }];
        });
    }
}

#pragma mark - Private

- (void)setup {
    CubeAccount * current = [CubeAccountHelper sharedInstance].currentAccount;
    NSDictionary * config = [CubeAccountHelper sharedInstance].engineConfig;

    CKernelConfig * kernelConfig = [CKernelConfig configWithAddress:[config valueForKey:@"address"]
                                                             domain:[config valueForKey:@"domain"]
                                                             appKey:[config valueForKey:@"appKey"]];

    // 以阻塞方式进行启动
    BOOL result = [[CEngine sharedInstance] startWithConfig:kernelConfig timeoutInMilliseconds:5000];
    if (!result) {
        // 启动失败
        [CubeUIUtility showErrorHint:@"启动引擎失败"];
        return;
    }

    NSLog(@"Cube Engine started");

    // 签入当前账号，该方法为阻塞调用
    CSelf * ownerAccount = [[CEngine sharedInstance] signInWithId:current.identity
                                                          andName:current.displayName
                                                       andContext:[current toDesensitizingJSON]];
    if (nil == ownerAccount) {
        NSLog(@"SignIn failure");
        return;
    }

    // 签入成功
    [CubeAccountHelper sharedInstance].owner = ownerAccount;
    NSLog(@"SignIn : %ld", current.identity);

    // 与引擎关联事件
    [[CubeAccountHelper sharedInstance] injectEngineEvent];

    // 启动即时消息模块
    [[CEngine sharedInstance].messagingService start];

    // 异步初始化联系人数据
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[CubeContactsHelper sharedInstance] resetContactsList];
    });
}

- (void)requestData:(void (^)(void))completion {
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
    [_explorer getAccountWithToken:[CubeAccountHelper sharedInstance].tokenCode success:^(id data) {
        gotAccount = YES;
        process(nil);
    } failure:^(NSError *error) {
        process(error);
    }];

    // 获取配置数据
    [_explorer getEngineConfigWithSuccess:^(id data) {
        gotConfig = YES;
        process(nil);
    } failure:^(NSError *error) {
        process(error);
    }];
}

- (UINavigationController *)addNavigationController:(UIViewController *)viewController {
    UINavigationController *navCtrl = [[UINavigationController alloc] initWithRootViewController:viewController];
    return navCtrl;
}

@end
