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

#import "CubeBaseKeyboard.h"
#import "CubeMessageBarDefinition.h"

@implementation CubeBaseKeyboard

- (instancetype)init {
    if (self = [super init]) {
        _isShow = NO;
    }
    return self;
}

- (void)showWithAnimation:(BOOL)animation {
    [self showInView:[UIApplication sharedApplication].windows[0] withAnimation:animation];
}

- (void)showInView:(UIView *)view withAnimation:(BOOL)animation {
    if (_isShow) {
        return;
    }
    
    _isShow = YES;
    
    if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(messageKeyboardWillShow:animated:)]) {
        [self.keyboardDelegate messageKeyboardWillShow:self animated:animation];
    }
    
    [view addSubview:self];
    
    CGFloat keyboardHeight = [self keyboardHeight];
    [self mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.mas_equalTo(view);
        make.height.mas_equalTo(keyboardHeight);
        make.bottom.mas_equalTo(view).mas_offset(keyboardHeight);
    }];
    [view layoutIfNeeded];
    
    if (animation) {
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(view);
            }];
            [view layoutIfNeeded];
            if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(messageKeyboard:didChangeHeight:)]) {
                [self.keyboardDelegate messageKeyboard:self didChangeHeight:view.height - self.y];
            }
        } completion:^(BOOL finished) {
            if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(messageKeyboardDidShow:animated:)]) {
                [self.keyboardDelegate messageKeyboardDidShow:self animated:animation];
            }
        }];
    }
    else {
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(view);
        }];
        [view layoutIfNeeded];
        if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(messageKeyboardDidShow:animated:)]) {
            [self.keyboardDelegate messageKeyboardDidShow:self animated:animation];
        }
    }
}

- (void)dismissWithAnimation:(BOOL)animation {
    if (!_isShow) {
        if (!animation) {
            
        }
        return;
    }
    
    _isShow = NO;
    
    if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(messageKeyboardWillDismiss:animated:)]) {
        [self.keyboardDelegate messageKeyboardWillDismiss:self animated:animation];
    }
    if (animation) {
        CGFloat keyboardHeight = [self keyboardHeight];
        [UIView animateWithDuration:0.3 animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self.superview).mas_offset(keyboardHeight);
            }];
            [self.superview layoutIfNeeded];
            if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(messageKeyboard:didChangeHeight:)]) {
                [self.keyboardDelegate messageKeyboard:self didChangeHeight:self.superview.height - self.y];
            }
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
            if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(messageKeyboardDidDismiss:animated:)]) {
                [self.keyboardDelegate messageKeyboardDidDismiss:self animated:animation];
            }
        }];
    }
    else {
        [self removeFromSuperview];
        if (self.keyboardDelegate && [self.keyboardDelegate respondsToSelector:@selector(messageKeyboardDidDismiss:animated:)]) {
            [self.keyboardDelegate messageKeyboardDidDismiss:self animated:animation];
        }
    }
}

- (void)reset {
    // Nothing
}

#pragma mark - CubeKeyboardProtocol

- (CGFloat)keyboardHeight {
    return HEIGHT_MESSAGEBAR_KEYBOARD + SAFEAREA_INSETS_BOTTOM;
}

@end
