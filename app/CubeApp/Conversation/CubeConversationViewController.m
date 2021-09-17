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

#import "CubeConversationViewController.h"
#import "CubeSearchController.h"

@interface CubeConversationViewController ()

@property (nonatomic, strong) UITableView * tableView;

@property (nonatomic, strong) CubeSearchController * searchController;

@end


@implementation CubeConversationViewController

- (instancetype)init {
    if (self = [super init]) {
        [self configTabBarItem:@"消息" image:@"TabBarConversation" imageHL:@"TabBarConversationHL"];
    }

    return self;
}

- (void)loadView {
    [super loadView];
    [self setNavTitleWithStatusString:nil];

    // 构建界面
    [self buildView];
}

#pragma mark - Private

- (void)setNavTitleWithStatusString:(NSString *)statusString {
    NSString * title = (nil != statusString) ? [NSString stringWithFormat:@"消息(%@)", statusString] : @"消息";
    [self.navigationItem setTitle:title];
}

- (void)buildView {
    // 列表
    self.tableView = self.view.addTableView(1)
        .backgroundColor([UIColor whiteColor])
        .view;
//        .tableHeaderView(self.ser)
}

#pragma mark - Getters

- (CubeSearchController *)searchController {
    if (!_searchController) {
        
    }
    
    return _searchController;
}

@end
