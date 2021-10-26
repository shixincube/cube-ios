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

#import "CubeContactsSearchResultViewController.h"
#import "CubeContactsItemModel.h"
#import "CubeContactsItemCell.h"
#import "CubeContactsHeaderView.h"

@interface CubeContactsSearchResultViewController ()

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) ZZFLEXAngel * tableViewAngel;

@property (nonatomic, strong) NSMutableArray * contactsData;

@end

@implementation CubeContactsSearchResultViewController

- (void)loadView {
    [super loadView];
    [self setStatusBarStyle:UIStatusBarStyleDefault];

    self.tableView = self.view.addTableView(1)
        .backgroundColor([UIColor colorGrayBG]).separatorStyle(UITableViewCellSeparatorStyleNone)
        .tableFooterView([UIView new])
        .estimatedRowHeight(0).estimatedSectionFooterHeight(0).estimatedSectionHeaderHeight(0)
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        })
        .view;

    self.tableViewAngel = [[ZZFLEXAngel alloc] initWithHostView:self.tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // TODO
    self.contactsData = [[NSMutableArray alloc] init];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(nonnull UISearchController *)searchController {
    @weakify(self);

    // 查找数据
    NSString * searchText = [searchController.searchBar.text lowercaseString];
    NSMutableArray * data = [[NSMutableArray alloc] init];
    for (CContact * contact in self.contactsData) {
        // TODO
    }

    self.tableViewAngel.clear();
    if (data.count > 0) {
        self.tableViewAngel.addSection(0);
        self.tableViewAngel.setHeader([CubeContactsHeaderView class]).toSection(0).withDataModel(@"联系人");
        self.tableViewAngel.addCells([CubeContactsItemCell class]).toSection(0).withDataModelArray(data).selectedAction(^ (CubeContactsItemModel * model) {
            @strongify(self);
            if (self.itemSelectedAction) {
                self.itemSelectedAction(self, model.customData);
            }
        });
    }

    [self.tableView reloadData];
}

- (void)itemTouchUp:(void (^)(__kindof UIViewController *, id))itemTouchUpBlock { 
    
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder { 
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection { 
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    
}

- (CGSize)sizeForChildContentContainer:(nonnull id<UIContentContainer>)container withParentContainerSize:(CGSize)parentSize { 
    return parentSize;
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container { 
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator { 
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator { 
    
}

- (void)setNeedsFocusUpdate { 
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context { 
    return NO;
}

- (void)updateFocusIfNeeded { 
    
}

@end
