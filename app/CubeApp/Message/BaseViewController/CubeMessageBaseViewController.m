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

#import "CubeMessageBaseViewController.h"
#import "CubePreference.h"
#import "CubeMessageBaseViewController+EventDelegate.h"
#import "CubeMessageBaseViewController+PanelViewDelegate.h"

@implementation CubeMessageBaseViewController

- (void)loadView {
    [super loadView];

    [CEngine sharedInstance].messagingService.eventDelegate = self;

    [self.view addSubview:self.messagePanelView];

    // TODO chat bar

//    if (SAFEAREA_INSETS_BOTTOM > 0) {
//        self.view.addView(1001).backgroundColor()
//    }

    [self buildMasonry];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // TODO load keyboard
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.view layoutIfNeeded];
}

#pragma mark - Private

- (void)buildMasonry {
    [self.messagePanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
}

- (void)resetView {
    NSString * bgImageName = nil;
    if (_contact) {
        bgImageName = [CubePreference messagePanelBackgroundWithContact:_contact];
    }

    // TODO

    if (nil == bgImageName) {
        [self.view setBackgroundColor:[UIColor colorGrayCharcoalBG]];
    }
    else {
        
    }

    [self resetPanelView];
}

#pragma mark - Setters

- (void)setContact:(CContact *)contact {
    _group = nil;

    if (_contact && _contact.identity == contact.identity) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messagePanelView scrollToBottomWithAnimation:NO];
        });
        return;
    }

    _contact = contact;
    [self.navigationItem setTitle:[contact getPriorityName]];
    [self resetView];
}

- (void)setGroup:(CGroup *)group {
    _contact = nil;
    
    _group = group;
}

#pragma mark - Getters

- (CubeMessagePanelView *)messagePanelView {
    if (nil == _messagePanelView) {
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height - 44.0;
        CGRect frame = CGRectMake(0, 0, width, height);
        _messagePanelView = [[CubeMessagePanelView alloc] initWithFrame:frame];
        _messagePanelView.contact = self.contact;
        _messagePanelView.group = self.group;
        _messagePanelView.delegate = self;
    }
    return _messagePanelView;
}

@end
