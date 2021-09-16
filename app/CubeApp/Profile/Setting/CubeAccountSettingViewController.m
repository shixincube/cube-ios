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

#import "CubeAccountSettingViewController.h"
#import "CubeSettingItem.h"
#import "CubeSettingItemTemplate.h"
#import "CubeAccount.h"
#import "CubeAccountHelper.h"
#import "CubeUIUtility.h"

typedef NS_ENUM(NSInteger, CubeAccountSettingSectionType) {
    CubeAccountSettingSectionTypeAccount,
    CubeAccountSettingSectionTypeLock,
    CubeAccountSettingSectionTypeSafe,
    CubeAccountSettingSectionTypeHelp,
};

@implementation CubeAccountSettingViewController

- (void)loadView {
    [super loadView];

    [self setTitle:@"账号与安全"];
    [self.view setBackgroundColor:[UIColor colorGrayBG]];

    [self buildView];
}

#pragma mark - Private

- (void)buildView {
    self.clear();

    CubeAccount * account = [CubeAccountHelper sharedInstance].currentAccount;
    
    NSInteger sectionTag = CubeAccountSettingSectionTypeAccount;
    self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(15, 0, 0, 0));

    // 账号名
    CubeSettingItem * accountNameItem = [CubeSettingItem itemWithTitle:@"账号名"];
    accountNameItem.subTitle = account.accountName;
    self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(accountNameItem).selectedAction(^ (id data) {
        [CubeUIUtility showInfoHint:@"🚧 开发中"];
    });
    
    // 手机号码
    CubeSettingItem * phoneItem = [CubeSettingItem itemWithTitle:@"手机号码"];
    if (account.phoneNumber.length > 0) {
        phoneItem.subTitle = account.phoneNumber;
        phoneItem.rightImageName = @"ProfileLockOn";
    }
    else {
        phoneItem.subTitle = @"未设置";
        phoneItem.rightImageName = @"ProfileLockOff";
    }
    self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(phoneItem).selectedAction(^ (id data) {
        // TODO 修改手机号码
        [CubeUIUtility showInfoHint:@"🚧 开发中"];
    });


    // 密码
    sectionTag = CubeAccountSettingSectionTypeLock;
    self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
    
    CubeSettingItem * passwordItem = [CubeSettingItem itemWithTitle:@"密码"];
    self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(passwordItem).selectedAction(^ (id data) {
        // TODO
        [CubeUIUtility showInfoHint:@"🚧 开发中"];
    });
    
    
    // 安全性配置
    sectionTag = CubeAccountSettingSectionTypeSafe;
    self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
    
    // 登录设备管理
    self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel([CubeSettingItem itemWithTitle:@"登录设备管理"]).selectedAction(^ (id data) {
        // TODO
        [CubeUIUtility showInfoHint:@"🚧 开发中"];
    });

    [self reloadView];
}

@end
