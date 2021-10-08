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

#import "CubeSettingViewController.h"
#import "CubeSettingItemTemplate.h"
#import "CubeAccountSettingViewController.h"

typedef NS_ENUM(NSInteger, CubeSettingSectionType) {
    CubeSettingSectionTypeAccount = 0,
    CubeSettingSectionTypeNomal,
    CubeSettingSectionTypeAbout,
    CubeSettingSectionTypeExit
};

@implementation CubeSettingViewController

- (void)loadView {
    [super loadView];
    [self setTitle:@"设置"];
    [self.collectionView setBackgroundColor:[UIColor colorGrayBG]];

    [self buildView];
}

#pragma mark - Private

- (void)buildView {
    @weakify(self);
    self.clear();

    // 账号与安全
    NSInteger sectionTag = CubeSettingSectionTypeAccount;
    self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(15, 0, 0, 0));
    self.addCell(CELL_ST_ITEM_NORMAL)
        .toSection(sectionTag)
        .withDataModel([CubeSettingItem itemWithTitle:@"账号与安全"])
        .selectedAction(^ (id data) {
            @strongify(self);
            CubeAccountSettingViewController * accountSettingVC = [[CubeAccountSettingViewController alloc] init];
            PushVC(accountSettingVC);
        });
    

    // 一般性配置
    sectionTag = CubeSettingSectionTypeNomal;
    self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(20, 0, 0, 0));
    
    // 新消息通知
    self.addCell(CELL_ST_ITEM_NORMAL).toSection(sectionTag).withDataModel([CubeSettingItem itemWithTitle:@"新消息通知"]).selectedAction(^ (id data) {
        // TODO
    });

    [self reloadView];
}

@end
