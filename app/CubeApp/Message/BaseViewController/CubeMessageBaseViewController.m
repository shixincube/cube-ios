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

    if (SAFEAREA_INSETS_BOTTOM > 0) {
//        self.view.addView(1001).backgroundColor()
    }

    [self buildMasonry];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // TODO load keyboard
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - Private

- (void)buildMasonry {
    [self.messagePanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];

    [self.view layoutIfNeeded];
}

- (void)resetView {
    NSString * bgImageName = nil;
    if (_partner) {
        bgImageName = [CubePreference messagePanelBackgroundWithContact:_partner];
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

- (void)setPartner:(CContact *)partner {
    _group = nil;

    if (_partner && _partner.identity == partner.identity) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messagePanelView scrollToBottomWithAnimation:NO];
        });
        return;
    }

    _partner = partner;
    [self.navigationItem setTitle:[partner getPriorityName]];
    [self resetView];
}

#pragma mark - Getters

- (CubeMessagePanelView *)messagePanelView {
    if (nil == _messagePanelView) {
        _messagePanelView = [[CubeMessagePanelView alloc] init];
        _messagePanelView.delegate = self;
    }
    return _messagePanelView;
}

@end
