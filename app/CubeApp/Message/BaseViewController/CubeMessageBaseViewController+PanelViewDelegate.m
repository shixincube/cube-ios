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

#import "CubeMessageBaseViewController+PanelViewDelegate.h"

@implementation CubeMessageBaseViewController (PanelViewDelegate)

#pragma mark - Public

- (void)resetPanelView {
    [self.messagePanelView reset];
    // TODO
}

#pragma mark - Delegate

- (void)messagePanelViewDidTouched:(CubeMessagePanelView *)panelView {
    
}

- (void)getDataFromBeginningTime:(CubeMessagePanelView *)panelView
                   beginningTime:(NSDate *)beginningTime
                           count:(NSUInteger)count
                       completed:(void (^)(NSDate *, NSArray *, BOOL))completed {
    NSLog(@"CubeMessageBaseViewController#getDataFromBeginningTime");
    
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
