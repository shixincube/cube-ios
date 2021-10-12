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

#import "CubeContactsViewController.h"
#import "CubeContactsListController.h"
#import "CubeSearchController.h"
#import "CubeContactsSearchResultViewController.h"
#import "CubeContactsHelper.h"

@interface CubeContactsViewController ()

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) CubeContactsListController * listController;

/*!
 * @brief 页脚显示联系人总数。
 */
@property (nonatomic, strong) UILabel * footerLabel;

@property (nonatomic, strong) CubeSearchController * searchController;

@end

@implementation CubeContactsViewController

- (instancetype)init {
    if (self = [super init]) {
        [self configTabBarItem:@"联系人" image:@"TabBarContact" imageHL:@"TabBarContactHL"];
    }
    return self;
}

- (void)loadView {
    [super loadView];

    [self buildView];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadData];
}

#pragma mark - Private

- (void)buildView {
    self.navigationItem.title = @"联系人";

    @weakify(self);

    self.tableView = self.view.addTableView(101)
        .backgroundColor([UIColor colorGrayBG])
        .separatorStyle(UITableViewCellSeparatorStyleNone)
        .tableHeaderView(self.searchController.searchBar)
        .tableFooterView(self.footerLabel)
        .estimatedRowHeight(0).estimatedSectionFooterHeight(0).estimatedSectionHeaderHeight(0)
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        })
        .view;

    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setSectionIndexColor:[UIColor colorBlackForNavBar]];

    self.listController = [[CubeContactsListController alloc] initWithHostView:self.tableView pushAction:^(__kindof UIViewController *viewController) {
        @strongify(self);
        PushVC(viewController);
    }];
}

- (void)loadData {
    [self.listController resetListWithContactsData:[CubeContactsHelper sharedInstance].groupedContactsData sectionHeaders:[CubeContactsHelper sharedInstance].sectionHeaders];
    self.footerLabel.text = [NSString stringWithFormat:@"%ld %@",
                             [CubeContactsHelper sharedInstance].contactsCount,
                             @"位联系人"];
    [self.tableView reloadData];

    @weakify(self);
    // 监听数据
    [CubeContactsHelper sharedInstance].dataChangedBlock = ^(NSMutableArray * contacts, NSMutableArray * headers, NSInteger count) {
        @strongify(self);
        [self.listController resetListWithContactsData:contacts sectionHeaders:headers];
        self.footerLabel.text = [NSString stringWithFormat:@"%ld %@",
                                 [CubeContactsHelper sharedInstance].contactsCount,
                                 @"位联系人"];
        [self.tableView reloadData];
    };
}

#pragma mark - Getters

- (CubeSearchController *)searchController {
    if (!_searchController) {
        CubeContactsSearchResultViewController * searchResultVC = [[CubeContactsSearchResultViewController alloc] init];
        @weakify(self);
        [searchResultVC setItemSelectedAction:^(CubeContactsSearchResultViewController *searchResultVC, CContact *contactModel) {
            @strongify(self);
            [self.searchController setActive:NO];
//            CubeContactDetailViewController *detailVC = [[CubeContactDetailViewController alloc] initWithUserModel:contactModel];
//            PushVC(detailVC);
        }];
        _searchController = [CubeSearchController controllerWithSearchResultsController:searchResultVC];
    }

    return _searchController;
}

- (UILabel *)footerLabel {
    if (!_footerLabel) {
        _footerLabel= [[UILabel alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50.0f)];
        [_footerLabel setTextAlignment:NSTextAlignmentCenter];
        [_footerLabel setFont:[UIFont systemFontOfSize:17.0f]];
        [_footerLabel setTextColor:[UIColor grayColor]];
    }
    return _footerLabel;
}

@end
