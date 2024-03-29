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

#import "CubeMessageBaseViewController+PanelViewDelegate.h"
#import "CubeMessageBaseViewController+MessageBar.h"

@implementation CubeMessageBaseViewController (PanelViewDelegate)

#pragma mark - Public

- (void)appendToShowMessage:(CMessage *)message {
    [self.messagePanelView addMessage:message];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.messagePanelView scrollToBottomWithAnimation:YES];
    });
}

- (void)resetPanelView {
    [self.messagePanelView reset];
    // TODO
}

#pragma mark - Delegate

- (void)messagePanelViewDidTouched:(CubeMessagePanelView *)panelView {
    [self dismissKeyboards];
}

- (void)getMessages:(CubeMessagePanelView *)panelView
  fromBeginningTime:(NSDate *)beginningTime
              count:(NSUInteger)count
          completed:(void (^)(NSDate *, NSArray *, BOOL))completed {
    NSLog(@"CubeMessageBaseViewController#getMessages");

    [[CEngine sharedInstance].messagingService queryMessages:panelView.conversation
                                                   beginning:[beginningTime timeIntervalSince1970Mills] limit:count
                                                  completion:^(NSArray<__kindof CMessage *> *array, BOOL hasMore) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completed(beginningTime, array, hasMore);
        });
    }];
}


- (void)messagePanelView:(CubeMessagePanelView *)panelView
        didDeleteMessage:(CMessage *)message {
    
}


- (void)messagePanelView:(CubeMessagePanelView *)panelView
   didClickContactAvatar:(CContact *)contact {
    
}


- (void)messagePanelView:(CubeMessagePanelView *)panelView
         didClickMessage:(CMessage *)message {
    
}


- (void)messagePanelView:(CubeMessagePanelView *)panelView
   didDoubleClickMessage:(CMessage *)message {
    
}


@end
