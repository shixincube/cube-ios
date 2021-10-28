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

#ifndef CubeMessagePanelView_h
#define CubeMessagePanelView_h

#import <UIKit/UIKit.h>
#import "CubeMessagePanelViewDelegate.h"
#import "CubeMessageCellMenuView.h"
#import "CubeTextMessageCell.h"

@interface CubeMessagePanelView : UIView

@property (nonatomic, strong) NSMutableArray * data;

@property (nonatomic, strong, readonly) UITableView * tableView;

/*! @brief 禁用下拉刷新。 */
@property (nonatomic, assign) BOOL disablePullToRefresh;

/*! @brief 禁用长安菜单。 */
@property (nonatomic, assign) BOOL disableLongPressMenu;

@property (nonatomic, strong) CubeMessageCellMenuView * menuView;

@property (nonatomic, assign) id<CubeMessagePanelViewDelegate> delegate;

@property (nonatomic, weak) CConversation * conversation;

- (instancetype)initWithFrame:(CGRect)frame;

/*!
 * @brief 重置当前 View 。
 */
- (void)reset;

- (void)addMessage:(CMessage *)message;

- (void)deleteMessage:(CMessage *)message;

- (void)deleteMessage:(CMessage *)message withAnimation:(BOOL)animation;

- (void)updateMessage:(CMessage *)message;

- (void)reloadData;


/*!
 * @brief 滚动到底部。
 * @param animation 是否执行动画。
 */
- (void)scrollToBottomWithAnimation:(BOOL)animation;

@end

#endif /* CubeMessagePanelView_h */
