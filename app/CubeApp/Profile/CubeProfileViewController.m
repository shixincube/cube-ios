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

#import "CubeProfileViewController.h"
#import "CubeProfileHeaderCell.h"
#import "CubeProfileInfoViewController.h"
#import "CubeAccount.h"
#import "CubeAccountHelper.h"


typedef NS_ENUM(NSInteger, CubeProfileSectionTag) {
    CubeProfileSectionTagInfo,
    CubeProfileSectionTagSetting,
};


@interface CubeProfileViewController ()

- (void)configTabBarItem:(NSString *)title image:(NSString *)image imageHL:(NSString *)imageHL;

- (void)buildMenus;

@end

@implementation CubeProfileViewController

- (instancetype)init {
    if (self = [super init]) {
        [self configTabBarItem:@"我的" image:@"TabBarProfile" imageHL:@"TabBarProfileHL"];
    }

    return self;
}

- (void)loadView {
    [super loadView];

    [self.navigationItem setTitle:@"我的"];

//    [self buildMenus];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor colorGrayBG]];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];

    if (!CGRectEqualToRect(self.view.bounds, self.collectionView.frame)) {
        [self.collectionView setFrame:self.view.bounds];
    }
}

#pragma mark - Private

- (void)buildMenus {
    @weakify(self);
    self.clear();
    
    CubeAccount * account = [CubeAccountHelper sharedInstance].currentAccount;

    NSInteger sectionTag = CubeProfileSectionTagInfo;
    self.addSection(sectionTag).sectionInsets(UIEdgeInsetsMake(15, 0, 0, 0));
    self.addCell([CubeProfileHeaderCell class])
        .toSection(sectionTag)
        .withDataModel(account)
        .selectedAction(^ (id data) {
            @strongify(self);
            CubeProfileInfoViewController * infoVC = [[CubeProfileInfoViewController alloc] init];
            PushVC(infoVC);
        });
    
    [self reloadView];
}

- (void)configTabBarItem:(NSString *)title image:(NSString *)image imageHL:(NSString *)imageHL {
    [self.tabBarItem setTitle:title];
    [self.tabBarItem setImage:[UIImage imageNamed:image]];
    [self.tabBarItem setSelectedImage:[UIImage imageNamed:imageHL]];
}

@end
