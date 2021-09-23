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

#import "CubeMessageCellMenuView.h"

@interface CubeMessageCellMenuView ()

@property (nonatomic, strong) UIMenuController * menuController;

@end

@implementation CubeMessageCellMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor clearColor]];
        self.menuController = [UIMenuController sharedMenuController];

        UITapGestureRecognizer * tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        [self addGestureRecognizer:tapGR];
    }
    
    return self;
}

- (void)showInView:(UIView *)view withMessageType:(CMessageType)messageType targetRect:(CGRect)targetRect actionBlock:(void (^)(CubeMessageMenuItemType))actionBlock {
    _isShow = YES;

    [self setFrame:view.bounds];
    [view addSubview:self];
    [self setActionBlock:actionBlock];
    [self setMessageType:messageType];

    if (@available(iOS 13.0, *)) {
        [self.menuController showMenuFromView:self rect:targetRect];
    }
    else {
        [self.menuController setTargetRect:targetRect inView:self];
        [self.menuController setMenuVisible:YES animated:YES];
    }
    [self becomeFirstResponder];
}

- (void)dismiss {
    _isShow = NO;
    
    if (self.actionBlock) {
        self.actionBlock(CubeMessageMenuItemTypeDismiss);
    }

    if (@available(iOS 13.0, *)) {
        [self.menuController hideMenuFromView:self];
    }
    else {
        [self.menuController setMenuVisible:NO animated:YES];
    }

    [self removeFromSuperview];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - Setters

- (void)setMessageType:(CMessageType)messageType {
    UIMenuItem * copy = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(respondCopyAction:)];
    UIMenuItem * delete = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(respondDeleteAction:)];
    UIMenuItem * recall = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(respondRecallAction:)];
    [self.menuController setMenuItems:@[copy, delete, recall]];
}

#pragma mark - Event Response

- (void)respondCopyAction:(UIMenuController *)sender {
    [self touchMenu:CubeMessageMenuItemTypeCopy];
}

- (void)respondDeleteAction:(UIMenuController *)sender {
    [self touchMenu:CubeMessageMenuItemTypeDelete];
}

- (void)respondRecallAction:(UIMenuController *)sender {
    [self touchMenu:CubeMessageMenuItemTypeRecall];
}

#pragma mark - Private

- (void)touchMenu:(CubeMessageMenuItemType)type {
    _isShow = NO;

    [self removeFromSuperview];

    if (self.actionBlock) {
        self.actionBlock(type);
    }
}

@end
