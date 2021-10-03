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

#import "CubeMessageBar.h"
#import "CubeVoiceRecordingButton.h"

@interface CubeMessageBar () <UITextViewDelegate> {
    UIImage * kVoiceImage;
    UIImage * kVoiceImageHL;
    UIImage * kEmojiImage;
    UIImage * kEmojiImageHL;
    UIImage * kMoreImage;
    UIImage * kMoreImageHL;
    UIImage * kKeyboardImage;
    UIImage * kKeyboardImageHL;
}

//@property (nonatomic, strong) UIButton * modeButton;

@property (nonatomic, strong) UIButton * voiceButton;

@property (nonatomic, strong) UITextView * textView;

@property (nonatomic, strong) CubeVoiceRecordingButton * recordButton;

@property (nonatomic, strong) UIButton * emojiButton;

@property (nonatomic, strong) UIButton * moreButton;

@property (nonatomic, strong) NSString * draft;

@end


@implementation CubeMessageBar

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorGrayForMessageBar];
        [self loadImage];
        
        [self addSubview:self.voiceButton];
        [self addSubview:self.textView];
        [self addSubview:self.recordButton];
        [self addSubview:self.emojiButton];
        [self addSubview:self.moreButton];

        [self buildMasonry];

        self.status = CubeMessageBarStatusInitial;
        
        self.draft = @"";
    }
    return self;
}

- (void)sendCurrentText {
    if (self.textView.text.length > 0) {
        if (_delegate && [_delegate respondsToSelector:@selector(messageBar:sendText:)]) {
            [_delegate messageBar:self sendText:self.textView.text];
        }
    }
    
    self.textView.text = @"";
    [self reloadTextViewWithAnimation:YES];
}

- (void)addEmojiString:(NSString *)emojiString {
    NSString * text = [NSString stringWithFormat:@"%@%@", self.textView.text, emojiString];
    self.textView.text = text;
    [self reloadTextViewWithAnimation:YES];
}

- (void)deleteLastCharacter {
    if ([self textView:self.textView shouldChangeTextInRange:NSMakeRange(self.textView.text.length - 1, 1) replacementText:@""]){
        [self.textView deleteBackward];
    }
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(context, 0.5);
    CGContextSetStrokeColorWithColor(context, [UIColor colorGrayLine].CGColor);
    CGContextBeginPath(context);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, SCREEN_WIDTH, 0);
    CGContextStrokePath(context);
}

- (BOOL)isFirstResponder {
    if (self.status == CubeMessageBarStatusEmoji
        || self.status == CubeMessageBarStatusKeyboard
        || self.status == CubeMessageBarStatusMore) {
        return YES;
    }

    return NO;
}

- (BOOL)resignFirstResponder {
    [self.moreButton setImage:kMoreImage imageHighlighted:kMoreImageHL];
    [self.emojiButton setImage:kEmojiImage imageHighlighted:kMoreImageHL];

    if (self.status == CubeMessageBarStatusKeyboard) {
        [self.textView resignFirstResponder];
        self.status = CubeMessageBarStatusInitial;

        if (self.delegate && [self.delegate respondsToSelector:@selector(messageBar:changeStatusFrom:to:)]) {
            [self.delegate messageBar:self changeStatusFrom:self.status to:CubeMessageBarStatusInitial];
        }
    }

    return [super resignFirstResponder];
}

#pragma mark - UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    self.activity = YES;
    
    if (self.status != CubeMessageBarStatusKeyboard) {
        if (_delegate && [_delegate respondsToSelector:@selector(messageBar:changeStatusFrom:to:)]) {
            [_delegate messageBar:self changeStatusFrom:self.status to:CubeMessageBarStatusKeyboard];
        }

        if (self.status == CubeMessageBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImage imageHighlighted:kEmojiImageHL];
        }
        else if (self.status == CubeMessageBarStatusMore) {
            [self.moreButton setImage:kMoreImage imageHighlighted:kMoreImageHL];
        }

        self.status = CubeMessageBarStatusKeyboard;
    }

    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@""]) {
        [self sendCurrentText];
        return NO;
    }
    else if (textView.text.length > 0 && [text isEqualToString:@""]) {
        if ([textView.text characterAtIndex:range.location] == ']') {
            NSUInteger location = range.location;
            NSUInteger length = range.length;
            while (location != 0) {
                location --;
                length ++ ;
                char c = [textView.text characterAtIndex:location];
                if (c == '[') {
                    textView.text = [textView.text stringByReplacingCharactersInRange:NSMakeRange(location, length) withString:@""];
                    [self reloadTextViewWithAnimation:YES];
                    return NO;
                }
                else if (c == ']') {
                    return YES;
                }
            }
        }
    }

    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self reloadTextViewWithAnimation:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    [self reloadTextViewWithAnimation:YES];
}

#pragma mark - Event Response

- (void)voiceButtonTouchUp:(UIButton *)sender {
    [self.textView resignFirstResponder];
    
    if (self.status == CubeMessageBarStatusVoice) {
        // 转为输入文本
        if (self.draft.length > 0) {
            self.textView.text = self.draft;
            self.draft = @"";
            [self reloadTextViewWithAnimation:YES];
        }

        if (_delegate && [_delegate respondsToSelector:@selector(messageBar:changeStatusFrom:to:)]) {
            [_delegate messageBar:self changeStatusFrom:self.status to:CubeMessageBarStatusKeyboard];
        }
        [self.voiceButton setImage:kVoiceImage imageHighlighted:kVoiceImageHL];
        [self.textView becomeFirstResponder];
        self.textView.hidden = NO;
        self.recordButton.hidden = YES;
        self.status = CubeMessageBarStatusKeyboard;
    }
    else {
        // 转为语音录制
        if (self.textView.text.length > 0) {
            self.draft = self.textView.text;
            self.textView.text = @"";
            [self reloadTextViewWithAnimation:YES];
        }

        if (_delegate && [_delegate respondsToSelector:@selector(messageBar:changeStatusFrom:to:)]) {
            [_delegate messageBar:self changeStatusFrom:self.status to:CubeMessageBarStatusVoice];
        }
        
        if (self.status == CubeMessageBarStatusKeyboard) {
            [self.textView resignFirstResponder];
        }
        else if (self.status == CubeMessageBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImage imageHighlighted:kEmojiImageHL];
        }
        else if (self.status == CubeMessageBarStatusMore) {
            [self.moreButton setImage:kMoreImage imageHighlighted:kMoreImageHL];
        }
        
        self.recordButton.hidden = NO;
        self.textView.hidden = YES;
        [self.voiceButton setImage:kKeyboardImage imageHighlighted:kKeyboardImageHL];
        self.status = CubeMessageBarStatusVoice;
    }
}

- (void)emojiButtonTouchUp:(UIButton *)sender {
    if (self.status == CubeMessageBarStatusEmoji) {
        // 转入文本输入
        if (_delegate && [_delegate respondsToSelector:@selector(messageBar:changeStatusFrom:to:)]) {
            [_delegate messageBar:self changeStatusFrom:self.status to:CubeMessageBarStatusKeyboard];
        }
        [self.emojiButton setImage:kEmojiImage imageHighlighted:kEmojiImageHL];
        [self.textView becomeFirstResponder];
        self.status = CubeMessageBarStatusKeyboard;
    }
    else {
        // 转入表情输入
        if (_delegate && [_delegate respondsToSelector:@selector(messageBar:changeStatusFrom:to:)]) {
            [_delegate messageBar:self changeStatusFrom:self.status to:CubeMessageBarStatusEmoji];
        }
        
        if (self.status == CubeMessageBarStatusVoice) {
            [self.voiceButton setImage:kVoiceImage imageHighlighted:kVoiceImageHL];
            self.recordButton.hidden = YES;
            self.textView.hidden = NO;
        }
        else if (self.status == CubeMessageBarStatusMore) {
            [self.moreButton setImage:kMoreImage imageHighlighted:kMoreImageHL];
        }
        
        [self.emojiButton setImage:kKeyboardImage imageHighlighted:kKeyboardImageHL];
        [self.textView resignFirstResponder];
        self.status = CubeMessageBarStatusEmoji;
    }
}

- (void)moreButtonTouchUp:(UIButton *)sender {
    if (self.status == CubeMessageBarStatusMore) {
        // 转入文本输入
        if (_delegate && [_delegate respondsToSelector:@selector(messageBar:changeStatusFrom:to:)]) {
            [_delegate messageBar:self changeStatusFrom:self.status to:CubeMessageBarStatusKeyboard];
        }
        [self.moreButton setImage:kMoreImage imageHighlighted:kMoreImageHL];
        [self.textView becomeFirstResponder];
        self.status = CubeMessageBarStatusKeyboard;
    }
    else {
        // 转入更多面板
        if (_delegate && [_delegate respondsToSelector:@selector(messageBar:changeStatusFrom:to:)]) {
            [_delegate messageBar:self changeStatusFrom:self.status to:CubeMessageBarStatusMore];
        }
        if (self.status == CubeMessageBarStatusVoice) {
            [self.voiceButton setImage:kVoiceImage imageHighlighted:kVoiceImageHL];
            self.recordButton.hidden = YES;
            self.textView.hidden = NO;
        }
        else if (self.status == CubeMessageBarStatusEmoji) {
            [self.emojiButton setImage:kEmojiImage imageHighlighted:kEmojiImageHL];
        }

        [self.moreButton setImage:kKeyboardImage imageHighlighted:kKeyboardImageHL];
        [self.textView resignFirstResponder];
        self.status = CubeMessageBarStatusMore;
    }
}

#pragma mark - Private

- (void)loadImage {
    kVoiceImage = CImage(@"ToolInputVoice");
    kVoiceImageHL = CImage(@"ToolInputVoiceHL");
    kEmojiImage = CImage(@"ToolEmotion");
    kEmojiImageHL = CImage(@"ToolEmotionHL");
    kMoreImage = CImage(@"ToolMore");
    kMoreImageHL = CImage(@"ToolMoreHL");
    kKeyboardImage = CImage(@"ToolInputKeyboard");
    kKeyboardImageHL = CImage(@"ToolInputKeyboardHL");
}

- (void)buildMasonry {
    [self.voiceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.top.mas_equalTo(self).mas_offset(7);
        make.bottom.mas_equalTo(self).mas_offset(-7);
        make.width.mas_equalTo(38);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self).mas_offset(7);
        make.bottom.mas_equalTo(self).mas_offset(-7);
        make.left.mas_equalTo(self.voiceButton.mas_right).mas_offset(4);
        make.right.mas_equalTo(self.emojiButton.mas_left).mas_offset(-4);
        make.height.mas_equalTo(HEIGHT_MESSAGEBAR_TEXTVIEW);
    }];
    
    [self.recordButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.textView);
        make.size.mas_equalTo(self.textView);
    }];

    [self.moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.width.mas_equalTo(self.voiceButton);
        make.right.mas_equalTo(self).mas_offset(-1);
    }];

    [self.emojiButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.and.width.mas_equalTo(self.voiceButton);
        make.right.mas_equalTo(self.moreButton.mas_left);
    }];
}

- (void)setActivity:(BOOL)activity {
    _activity = activity;
    if (activity) {
        self.textView.textColor = [UIColor blackColor];
    }
    else {
        self.textView.textColor = [UIColor grayColor];
    }
}

- (void)reloadTextViewWithAnimation:(BOOL)animation {
    CGFloat textHeight = [self.textView sizeThatFits:CGSizeMake(self.textView.width, MAXFLOAT)].height;
    CGFloat height = textHeight > HEIGHT_MESSAGEBAR_TEXTVIEW ? textHeight : HEIGHT_MESSAGEBAR_TEXTVIEW;
    height = (textHeight <= HEIGHT_MAX_MESSAGEBAR_TEXTVIEW ? textHeight : HEIGHT_MAX_MESSAGEBAR_TEXTVIEW);
    [self.textView setScrollEnabled:textHeight > height];
    if (height != self.textView.height) {
        if (animation) {
            [UIView animateWithDuration:0.2 animations:^{
                [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                    make.height.mas_equalTo(height);
                }];
                if (self.superview) {
                    [self.superview layoutIfNeeded];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(messageBar:didChangeTextViewHeight:)]) {
                    [self.delegate messageBar:self didChangeTextViewHeight:self.textView.height];
                }
            } completion:^(BOOL finished) {
                if (textHeight > height) {
                    [self.textView setContentOffset:CGPointMake(0, textHeight - height) animated:YES];
                }
                if (self.delegate && [self.delegate respondsToSelector:@selector(messageBar:didChangeTextViewHeight:)]) {
                    [self.delegate messageBar:self didChangeTextViewHeight:height];
                }
            }];
        }
        else {
            [self.textView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_equalTo(height);
            }];
            if (self.superview) {
                [self.superview layoutIfNeeded];
            }
            if (self.delegate && [self.delegate respondsToSelector:@selector(messageBar:didChangeTextViewHeight:)]) {
                [self.delegate messageBar:self didChangeTextViewHeight:height];
            }
            if (textHeight > height) {
                [self.textView setContentOffset:CGPointMake(0, textHeight - height) animated:YES];
            }
        }
    }
    else if (textHeight > height) {
        if (animation) {
            CGFloat offsetY = self.textView.contentSize.height - self.textView.height;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.textView setContentOffset:CGPointMake(0, offsetY) animated:YES];
            });
        }
        else {
            [self.textView setContentOffset:CGPointMake(0, self.textView.contentSize.height - self.textView.height) animated:NO];
        }
    }
}

#pragma mark - Getters

- (UIButton *)voiceButton {
    if (!_voiceButton) {
        _voiceButton = [[UIButton alloc] init];
        [_voiceButton setImage:kVoiceImage imageHighlighted:kVoiceImageHL];
        [_voiceButton addTarget:self action:@selector(voiceButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.font = [UIFont systemFontOfSize:16.0f];
        _textView.returnKeyType = UIReturnKeySend;
        _textView.layer.masksToBounds = YES;
        _textView.layer.cornerRadius = 4.0f;
        _textView.layer.borderWidth = BORDER_WIDTH_1PX;
        _textView.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.3].CGColor;
        _textView.delegate = self;
        _textView.scrollsToTop = NO;
    }
    return _textView;
}

- (CubeVoiceRecordingButton *)recordButton {
    if (!_recordButton) {
        _recordButton = [[CubeVoiceRecordingButton alloc] init];
        _recordButton.hidden = YES;
        CWeakSelf(self);
        [_recordButton setTouchBeginAction:^{
            if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(messageBarStartRecording:)]) {
                [weak_self.delegate messageBarStartRecording:weak_self];
            }
        } willTouchCancelAction:^(BOOL cancel) {
            if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(messageBarWillCancelRecording:cancel:)]) {
                [weak_self.delegate messageBarWillCancelRecording:weak_self cancel:cancel];
            }
        } touchEndAction:^{
            if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(messageBarFinishedRecoding:)]) {
                [weak_self.delegate messageBarFinishedRecoding:weak_self];
            }
        } touchCancelAction:^{
            if (weak_self.delegate && [weak_self.delegate respondsToSelector:@selector(messageBarDidCancelRecording:)]) {
                [weak_self.delegate messageBarDidCancelRecording:weak_self];
            }
        }];
    }
    return _recordButton;
}

- (UIButton *)emojiButton {
    if (!_emojiButton) {
        _emojiButton = [[UIButton alloc] init];
        [_emojiButton setImage:kEmojiImage imageHighlighted:kEmojiImageHL];
        [_emojiButton addTarget:self action:@selector(emojiButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _emojiButton;
}

- (UIButton *)moreButton {
    if (!_moreButton) {
        _moreButton = [[UIButton alloc] init];
        [_moreButton setImage:kMoreImage imageHighlighted:kMoreImageHL];
        [_moreButton addTarget:self action:@selector(moreButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _moreButton;
}

- (NSString *)currentText {
    return self.textView.text;
}

@end
