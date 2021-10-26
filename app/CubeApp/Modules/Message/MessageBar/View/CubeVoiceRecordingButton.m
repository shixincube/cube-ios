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

#import "CubeVoiceRecordingButton.h"
#import "UIView+Frame.h"

@interface CubeVoiceRecordingButton ()

@property (nonatomic, strong) void (^touchBegin)(void);
@property (nonatomic, strong) void (^touchMove)(BOOL cancel);
@property (nonatomic, strong) void (^touchCancel)(void);
@property (nonatomic, strong) void (^touchEnd)(void);

@end

@implementation CubeVoiceRecordingButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.normalTitle = @"按住 说话";
        self.highlightTitle = @"松开 结束";
        self.cancelTitle = @"松开 取消";
        self.highlightColor = [UIColor colorWithWhite:0.0 alpha:0.1];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 4.0;
        self.layer.borderWidth = BORDER_WIDTH_1PX;
        self.layer.borderColor = [UIColor colorWithWhite:0.0 alpha:0.3].CGColor;

        [self addSubview:self.titleLabel];
        [self buildMasonry];
    }
    return self;
}

- (void)setTouchBeginAction:(void (^)(void))touchBegin willTouchCancelAction:(void (^)(BOOL))willTouchCancel touchEndAction:(void (^)(void))touchEnd touchCancelAction:(void (^)(void))touchCancel {
    self.touchBegin = touchBegin;
    self.touchMove = willTouchCancel;
    self.touchCancel= touchCancel;
    self.touchEnd = touchEnd;
}

#pragma mark - Override Event Response

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = self.highlightColor;
    self.titleLabel.text = self.highlightTitle;
    if (self.touchBegin) {
        self.touchBegin();
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.touchMove) {
        CGPoint curPoint = [[touches anyObject] locationInView:self];
        BOOL moveIn = curPoint.x >= 0 && curPoint.x <= self.width && curPoint.y >= 0 && curPoint.y <= self.height;
        self.titleLabel.text = (moveIn ? self.highlightTitle : self.cancelTitle);
        self.touchMove(!moveIn);
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.normalTitle;

    CGPoint curPoint = [[touches anyObject] locationInView:self];
    BOOL moveIn = curPoint.x >= 0 && curPoint.x <= self.width && curPoint.y >= 0 && curPoint.y <= self.height;
    if (moveIn && self.touchEnd) {
        self.touchEnd();
    }
    else if (!moveIn && self.touchCancel) {
        self.touchCancel();
    }
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.backgroundColor = [UIColor clearColor];
    self.titleLabel.text = self.normalTitle;
    if (self.touchCancel) {
        self.touchCancel();
    }
}

#pragma mark - Private

- (void)buildMasonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - Getters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        [_titleLabel setFont:[UIFont boldSystemFontOfSize:16.0f]];
        [_titleLabel setTextColor:[UIColor colorWithRed:0.3 green:0.3 blue:0.3 alpha:1.0]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setText:self.normalTitle];
    }
    return _titleLabel;
}

@end
