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

#import "CubeProfileInfoViewController.h"
#import "CubeAccount.h"
#import "CubeAccountHelper.h"
#import "CubeProfileInfoAvatarCell.h"
#import "CubeAppUtil.h"
#import "CubeSettingItemTemplate.h"

typedef NS_ENUM(NSInteger, CubeProfileInfoVCSectionType) {
    CubeProfileInfoVCSectionTypeBase,
    CubeProfileInfoVCSectionTypeSafe,
    CubeProfileInfoVCSectionTypeMore,
};

@interface CubeProfileInfoViewController ()

- (void)buildView;

@end

@implementation CubeProfileInfoViewController

- (void)loadView {
    [super loadView];

    [self setTitle:@"个人信息"];
    [self.view setBackgroundColor:[UIColor colorGrayBG]];
    
    [self buildView];
}

#pragma mark - Private

- (void)buildView {
    self.clear();

    CubeAccount * account = [CubeAccountHelper sharedInstance].currentAccount;

    NSInteger sectionTag = CubeProfileInfoVCSectionTypeBase;
    self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(15, 0, 0, 0));

    // 头像
    CubeSettingItem * avatar = [CubeSettingItem itemWithTitle:@"头像"];
    avatar.rightImageName = [CubeAppUtil explainAvatarName:account.avatar];
    self.addCell([CubeProfileInfoAvatarCell class]).toSection(sectionTag).withDataModel(avatar).selectedAction(^ (id data) {
        // Nothing
    });
    
    // 名字
    CubeSettingItem * nickname = [CubeSettingItem itemWithTitle:@"名字"];
    nickname.subTitle = account.displayName;
    self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(nickname).selectedAction(^ (id data) {
        // Nothing
    });

    // 魔方号
    CubeSettingItem * cubeId = [CubeSettingItem itemWithTitle:@"魔方号"];
    cubeId.showDisclosureIndicator = NO;
    cubeId.subTitle = [NSString stringWithFormat:@"%lu", account.identity];
    self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(cubeId).selectedAction(^ (id data) {
        // Nothing
    });
    
    // 更多
    CubeSettingItem * more = [CubeSettingItem itemWithTitle:@"更多"];
    self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(more).selectedAction(^ (id data) {
        // Nothing
    });
    
    
    // 安全屋
    
    sectionTag = CubeProfileInfoVCSectionTypeSafe;
    self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 40, 0));
    
    // 我的安全屋
    CubeSettingItem * safeHouse = [CubeSettingItem itemWithTitle:@"我的安全屋"];
    self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel(safeHouse).selectedAction(^ (id data) {
        // Nothing
    });

    [self reloadView];
}

@end
