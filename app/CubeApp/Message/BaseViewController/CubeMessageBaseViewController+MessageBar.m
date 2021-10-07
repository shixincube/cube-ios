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

- (void)loadKeyboards {
    self.emojiKeyboard.keyboardDelegate = self;
    self.moreKeyboard.keyboardDelegate = self;
}

- (void)dismissKeyboards {
    if (self.currentStatus == CubeMessageBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:YES];
        self.currentStatus = CubeMessageBarStatusInitial;
    }
    else if (self.currentStatus == CubeMessageBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:YES];
        self.currentStatus = CubeMessageBarStatusInitial;
    }

    [self.messageBar resignFirstResponder];
}

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

    if (self.lastStatus == CubeMessageBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:NO];
    }
    else if (self.lastStatus == CubeMessageBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:NO];
    }
    
    [self.messagePanelView scrollToBottomWithAnimation:YES];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    if (self.currentStatus != CubeMessageBarStatusKeyboard && self.lastStatus != CubeMessageBarStatusKeyboard) {
        return;
    }
    if (self.currentStatus == CubeMessageBarStatusEmoji || self.currentStatus == CubeMessageBarStatusMore) {
        return;
    }
    [self.messageBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(-SAFEAREA_INSETS_BOTTOM);
    }];
    [self.view layoutIfNeeded];
}

- (void)keyboardFrameWillChange:(NSNotification *)notification {
    if (self.currentStatus != CubeMessageBarStatusKeyboard && self.lastStatus != CubeMessageBarStatusKeyboard) {
        return;
    }
    
    CGRect keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (self.lastStatus == CubeMessageBarStatusMore || self.lastStatus == CubeMessageBarStatusEmoji) {
        if (keyboardFrame.size.height <= HEIGHT_MESSAGEBAR_KEYBOARD) {
            return;
        }
    }
    else if (self.currentStatus == CubeMessageBarStatusMore || self.currentStatus == CubeMessageBarStatusEmoji) {
        return;
    }

    [self.messageBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(MIN(-keyboardFrame.size.height, -SAFEAREA_INSETS_BOTTOM));
    }];
    [self.view layoutIfNeeded];
    [self.messagePanelView scrollToBottomWithAnimation:YES];
}

#pragma mark - CubeBaseKeyboard

- (void)messageKeyboardWillShow:(CubeBaseKeyboard *)keyboard animated:(BOOL)animated {
    [self.messagePanelView scrollToBottomWithAnimation:YES];
}

- (void)messageKeyboardDidShow:(CubeBaseKeyboard *)keyboard animated:(BOOL)animated {
    if (self.currentStatus == CubeMessageBarStatusMore && self.lastStatus == CubeMessageBarStatusEmoji) {
        [self.emojiKeyboard dismissWithAnimation:NO];
    }
    else if (self.currentStatus == CubeMessageBarStatusEmoji && self.lastStatus == CubeMessageBarStatusMore) {
        [self.moreKeyboard dismissWithAnimation:NO];
    }
    [self.messagePanelView scrollToBottomWithAnimation:YES];
}

- (void)messageKeyboardWillDismiss:(CubeBaseKeyboard *)keyboard animated:(BOOL)animated {
    // Nothing
}

- (void)messageKeyboardDidDismiss:(CubeBaseKeyboard *)keyboard animated:(BOOL)animated {
    // Nothing
}

- (void)messageKeyboard:(CubeBaseKeyboard *)keyboard didChangeHeight:(CGFloat)height {
    [self.messageBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view).mas_offset(MIN(-height, -SAFEAREA_INSETS_BOTTOM));
    }];
    [self.view layoutIfNeeded];
    [self.messagePanelView scrollToBottomWithAnimation:YES];
}

#pragma mark - CubeMessageBarDelegate

- (void)messageBar:(CubeMessageBar *)messageBar changeStatusFrom:(CubeMessageBarStatus)fromStatus to:(CubeMessageBarStatus)toStatus {
    if (self.currentStatus == toStatus) {
        return;
    }

    self.lastStatus = fromStatus;
    self.currentStatus = toStatus;
    
    if (toStatus == CubeMessageBarStatusInitial) {
        if (fromStatus == CubeMessageBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }
        else if (fromStatus == CubeMessageBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
    }
    else if (toStatus == CubeMessageBarStatusVoice) {
        if (fromStatus == CubeMessageBarStatusMore) {
            [self.moreKeyboard dismissWithAnimation:YES];
        }
        else if (fromStatus == CubeMessageBarStatusEmoji) {
            [self.emojiKeyboard dismissWithAnimation:YES];
        }
    }
    else if (toStatus == CubeMessageBarStatusEmoji) {
        [self.emojiKeyboard showInView:self.view withAnimation:YES];
    }
    else if (toStatus == CubeMessageBarStatusMore) {
        [self.moreKeyboard showInView:self.view withAnimation:YES];
    }
}

- (void)messageBar:(CubeMessageBar *)messageBar didChangeTextViewHeight:(CGFloat)height {
    [self.messagePanelView scrollToBottomWithAnimation:NO];
}

- (void)messageBar:(CubeMessageBar *)messageBar sendText:(NSString *)text {
    [self sendTextMessage:text];
}

- (void)messageBarLoadDraft:(CubeMessageBar *)messageBar completion:(void (^)(CMessageDraft *))completion {
    if (self.contact) {
        [[CEngine sharedInstance].messagingService loadDraftWithContact:self.contact handleSuccess:^(id  _Nullable data) {
            completion(data);
        } handleFailure:^(CError * _Nullable error) {
            completion(nil);
        }];
    }
    else if (self.group) {
        // TODO
    }
}

- (void)messageBarSaveDraft:(CubeMessageBar *)messageBar draft:(CMessageDraft *)draft {
    if (self.contact) {
        [[CEngine sharedInstance].messagingService saveDraft:draft];
    }
    else if (self.group) {
        // TODO
    }
}

- (void)messageBarDeleteDraft:(CubeMessageBar *)messageBar {
    if (self.contact) {
        [[CEngine sharedInstance].messagingService deleteDraftWithContact:self.contact];
    }
    else if (self.group) {
        // TODO
    }
}

- (void)messageBarStartRecording:(CubeMessageBar *)messageBar {
    
}

- (void)messageBarDidCancelRecording:(CubeMessageBar *)messageBar {
    
}

- (void)messageBarFinishedRecoding:(CubeMessageBar *)messageBar {
    
}

- (void)messageBarWillCancelRecording:(CubeMessageBar *)messageBar cancel:(BOOL)cancel {
    
}

#pragma mark - Getters

- (CubeEmojiKeyboard *)emojiKeyboard {
    return [CubeEmojiKeyboard keyboard];
}

- (CubeMoreKeyboard *)moreKeyboard {
    return [CubeMoreKeyboard keyboard];
}

@end
