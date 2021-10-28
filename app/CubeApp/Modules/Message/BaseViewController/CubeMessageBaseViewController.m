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

#import "CubeMessageBaseViewController.h"
#import "CubePreference.h"
#import "CubeMessageBaseViewController+EventDelegate.h"
#import "CubeMessageBaseViewController+PanelViewDelegate.h"
#import "CubeMessageBaseViewController+MessageBar.h"

@implementation CubeMessageBaseViewController

- (void)loadView {
    [super loadView];

    self.currentStatus = CubeMessageBarStatusInitial;

    [CEngine sharedInstance].messagingService.eventDelegate = self;

    [self.view addSubview:self.messagePanelView];
    [self.view addSubview:self.messageBar];

    if (SAFEAREA_INSETS_BOTTOM > 0) {
        self.view.addView(1001).backgroundColor(self.messageBar.backgroundColor)
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.top.mas_equalTo(self.messageBar.mas_bottom);
        });
    }

    [self buildMasonry];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self loadKeyboards];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.view layoutIfNeeded];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)dealloc {
    [[CubeMoreKeyboard keyboard] dismissWithAnimation:NO];
    [[CubeEmojiKeyboard keyboard] dismissWithAnimation:NO];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Private

- (void)buildMasonry {
    [self.messagePanelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.left.and.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.messageBar.mas_top);
    }];

    [self.messageBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view).mas_offset(-SAFEAREA_INSETS_BOTTOM);
        make.height.mas_greaterThanOrEqualTo(44);
    }];
}

- (void)resetView {
    NSString * bgImageName = nil;
    if (_conversation.type == CConversationTypeContact) {
        bgImageName = [CubePreference messagePanelBackgroundWithContact:_conversation.contact];
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

- (void)setConversation:(CConversation *)conversation {
    if (_conversation.identity == conversation.identity) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.messagePanelView scrollToBottomWithAnimation:NO];
        });
        return;
    }

    _conversation = conversation;
    [self.navigationItem setTitle:_conversation.displayName];
    [self resetView];
}

#pragma mark - Getters

- (CubeMessagePanelView *)messagePanelView {
    if (nil == _messagePanelView) {
        CGFloat width = self.view.frame.size.width;
        CGFloat height = self.view.frame.size.height - 44.0;
        CGRect frame = CGRectMake(0, 0, width, height);
        _messagePanelView = [[CubeMessagePanelView alloc] initWithFrame:frame];
        _messagePanelView.conversation = self.conversation;
        _messagePanelView.delegate = self;
    }
    return _messagePanelView;
}

- (CubeMessageBar *)messageBar {
    if (nil == _messageBar) {
        _messageBar = [[CubeMessageBar alloc] init];
        _messageBar.delegate = self;
    }
    return _messageBar;
}

@end
