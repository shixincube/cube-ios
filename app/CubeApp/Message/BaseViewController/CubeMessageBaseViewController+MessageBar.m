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

#import "CubeMessageBaseViewController+MessageBar.h"
#import "CubeMessageBaseViewController+EventDelegate.h"

@implementation CubeMessageBaseViewController (MessageBar)

#pragma mark - System Keyboard Event

- (void)keyboardWillShow:(NSNotification *)notification {
    if (self.currentStatus != CubeMessageBarStatusKeyboard) {
        return;
    }
    
    [self.messagePanelView scrollToBottomWithAnimation:YES];
}

- (void)keyboardDidShow:(NSNotification *)notification {
    if (self.currentStatus != CubeMessageBarStatusKeyboard) {
        return;
    }

    
}

- (void)keyboardWillHide:(NSNotification *)notification {
    
}

- (void)keyboardFrameWillChange:(NSNotification *)notification {
    
}

#pragma mark - CubeMessageBarDelegate

- (void)messageBar:(CubeMessageBar *)messageBar changeStatusFrom:(CubeMessageBarStatus)fromStatus to:(CubeMessageBarStatus)toStatus {
    if (self.currentStatus == toStatus) {
        return;
    }

    self.lastStatus = fromStatus;
    self.currentStatus = toStatus;
    
    if (CubeMessageBarStatusInitial == toStatus) {
        if (CubeMessageBarStatusMore == fromStatus) {
            
        }
    }
}

- (void)messageBar:(CubeMessageBar *)messageBar didChangeTextViewHeight:(CGFloat)height {
    [self.messagePanelView scrollToBottomWithAnimation:NO];
}

- (void)messageBar:(CubeMessageBar *)messageBar sendText:(NSString *)text {
    [self sendTextMessage:text];
}

- (void)messageBarDidCancelRecording:(CubeMessageBar *)messageBar {
    
}

- (void)messageBarFinishedRecoding:(CubeMessageBar *)messageBar {
    
}

- (void)messageBarStartRecording:(CubeMessageBar *)messageBar {
    
}

- (void)messageBarWillCancelRecording:(CubeMessageBar *)messageBar cancel:(BOOL)cancel {
    
}

@end
