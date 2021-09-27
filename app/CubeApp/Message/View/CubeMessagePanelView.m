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

#import "CubeMessagePanelView.h"
#import "CubeMessagePanelView+Delegate.h"

#define PAGE_MESSAGE_COUNT 15

@interface CubeMessagePanelView ()

@property (nonatomic, strong) MJRefreshNormalHeader * refreshHeader;

@property (nonatomic, strong) NSDate * currentDate;

@end

@implementation CubeMessagePanelView

@synthesize tableView = _tableView;
@synthesize menuView = _menuView;
@synthesize data = _data;


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.tableView];
        self.disablePullToRefresh = NO;
        // 初始化 Table View
        [self registerCellClassForTableView:self.tableView];

        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];

        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchTableView:)];
        [self.tableView addGestureRecognizer:tapGR];

//        [self.tableView addObserver:self forKeyPath:@"bounds" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    }

    return self;
}

- (void)dealloc {
//    [self.menuView dismiss];
//    [self.tableView removeObserver:self forKeyPath:@"bounds"];
}

- (void)reset {
    [self.data removeAllObjects];
    [self.tableView reloadData];

    self.currentDate = [NSDate date];

    if (!self.disablePullToRefresh) {
        [self.tableView setMj_header:self.refreshHeader];
    }
    
    CWeakSelf(self);
    [self tryToRefreshMoreRecord:^(NSInteger count, BOOL hasMore) {
        if (!hasMore) {
            weak_self.tableView.mj_header = nil;
        }

        if (count > 0) {
            [weak_self.tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weak_self.tableView scrollToBottomWithAnimation:NO];
            });
        }
    }];
}

- (void)addMessage:(CMessage *)message {
    [self.data addObject:message];
    [self.tableView reloadData];
}

- (void)deleteMessage:(CMessage *)message {
    [self deleteMessage:message withAnimation:NO];
}

- (void)deleteMessage:(CMessage *)message withAnimation:(BOOL)animation {
    if (nil == message) {
        return;
    }
    
    NSInteger index = [self.data indexOfObject:message];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagePanelView:didDeleteMessage:)]) {
        [self.delegate messagePanelView:self didDeleteMessage:message];
    }
    
    [self.data removeObject:message];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:animation ? UITableViewRowAnimationAutomatic : UITableViewRowAnimationNone];
}

- (void)updateMessage:(CMessage *)message {
    NSArray * visibleCells = [self.tableView visibleCells];
    for (id cell in visibleCells) {
        if ([cell isKindOfClass:[CubeMessageBaseCell class]]) {
            CubeMessageBaseCell * cbc = (CubeMessageBaseCell *)cell;
            if (cbc.message.identity == message.identity) {
                [cbc updateMessage:message];
                return;
            }
        }
    }
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)scrollToBottomWithAnimation:(BOOL)animation {
    [self.tableView scrollToBottomWithAnimation:animation];
}

#pragma mark - Event Response

- (void)didTouchTableView:(UIGestureRecognizer*)gestureRecognizer {
    if (self.delegate && [self.delegate respondsToSelector:@selector(messagePanelViewDidTouched:)]) {
        [self.delegate messagePanelViewDidTouched:self];
    }
}

#pragma mark - Private Methods

- (void)tryToRefreshMoreRecord:(void (^)(NSInteger count, BOOL hasMore))complete {
    CWeakSelf(self);

    if (self.delegate && [self.delegate respondsToSelector:@selector(getDataFromBeginningTime:beginningTime:count:completed:)]) {
        [self.delegate getDataFromBeginningTime:self
                                  beginningTime:self.currentDate
                                          count:PAGE_MESSAGE_COUNT
                                      completed:^(NSDate * date, NSArray * array, BOOL hasMore) {
            if (array.count > 0) {
                weak_self.currentDate = [array[0] date];
                [weak_self.data insertObjects:array atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, array.count)]];
                complete(array.count, hasMore);
            }
            else {
                complete(0, hasMore);
            }
        }];
    }
}

#pragma mark - Setters

- (void)setData:(NSMutableArray *)data {
    _data = data;
    [self.tableView reloadData];
}

- (void)setDisablePullToRefresh:(BOOL)disablePullToRefresh {
    if (disablePullToRefresh) {
        [self.tableView setMj_header:nil];
    }
    else {
        [self.tableView setMj_header:self.refreshHeader];
    }
}

#pragma mark - Getters

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)]];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
    }
    return _tableView;
}

- (CubeMessageCellMenuView *)menuView {
    if (!_menuView) {
        _menuView = [[CubeMessageCellMenuView alloc] init];
    }
    return _menuView;
}

- (NSMutableArray *)data {
    if (!_data) {
        _data = [[NSMutableArray alloc] init];
    }
    return _data;
}

- (MJRefreshNormalHeader *)refreshHeader {
    if (!_refreshHeader) {
        CWeakSelf(self);
        _refreshHeader = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weak_self tryToRefreshMoreRecord:^(NSInteger count, BOOL hasMore) {
                // 结束刷新效果
                [weak_self.tableView.mj_header endRefreshing];

                if (!hasMore) {
                    weak_self.tableView.mj_header = nil;
                }

                if (count > 0) {
                    [weak_self.tableView reloadData];
                    [weak_self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
                }
            }];
        }];
        
        _refreshHeader.lastUpdatedTimeLabel.hidden = YES;
        _refreshHeader.stateLabel.hidden = YES;
    }
    return _refreshHeader;
}

@end
