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

@end


@implementation CubeMessageBar

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor colorGrayForMessageBar];
        [self loadImage];
        
        [self addSubview:self.voiceButton];

        [self buildMasonry];

        self.status = CubeMessageBarStatusInitial;
    }
    return self;
}

#pragma mark - Event Response

- (void)voiceButtonTouchUp:(UIButton *)sender {
    
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

@end
