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

#import "CubeMessageBaseCell.h"
#import "NSDate+Cube.h"
#import "CubeAccount.h"
#import "CubeAppUtil.h"

#define     TIMELABEL_HEIGHT    20.0f
#define     TIMELABEL_SPACE_Y   10.0f

#define     NAMELABEL_HEIGHT    14.0f
#define     NAMELABEL_SPACE_X   12.0f
#define     NAMELABEL_SPACE_Y   1.0f

#define     AVATAR_WIDTH        40.0f
#define     AVATAR_SPACE_X      8.0f
#define     AVATAR_SPACE_Y      12.0f

#define     MSGBG_SPACE_X       5.0f
#define     MSGBG_SPACE_Y       1.0f


@implementation CubeMessageBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;

        [self.contentView addSubview:self.timeLabel];
        [self.contentView addSubview:self.avatarButton];
        [self.contentView addSubview:self.nameLabel];
        [self.contentView addSubview:self.messageBackgroundView];

        [self makeConstraints];
    }
    return self;
}

- (void)updateMessage:(CMessage *)message {
    [self setMessage:message];
}

#pragma mark - Private

- (void)makeConstraints {
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.contentView).mas_offset(TIMELABEL_SPACE_Y);
        make.centerX.mas_equalTo(self.contentView);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.avatarButton).mas_equalTo(-NAMELABEL_SPACE_Y);
        make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-NAMELABEL_SPACE_X);
    }];

    // 默认是自己
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).mas_offset(-AVATAR_SPACE_X);
        make.width.and.height.mas_equalTo(AVATAR_WIDTH);
        make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(AVATAR_SPACE_Y);
    }];

    [self.messageBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-MSGBG_SPACE_X);
        make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(-MSGBG_SPACE_Y);
    }];
}

#pragma mark - Event Response

- (void)avatarButtonTouchUp:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(messageCellDidClickAvatarForContact:)]) {
        [_delegate messageCellDidClickAvatarForContact:self.message.sender];
    }
}

- (void)longPressBackgroundView:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan) {
        return;
    }
    
    [self.messageBackgroundView setHighlighted:YES];

    if (_delegate && [_delegate respondsToSelector:@selector(messageCellDidLongPress:targetRect:)]) {
        CGRect rect = self.messageBackgroundView.frame;
        rect.size.height -= 10;     // 背景图片底部空白区域
        [_delegate messageCellDidLongPress:self.message targetRect:rect];
    }
}

- (void)doubleTapBackgroundView:(UIGestureRecognizer*)gestureRecognizer {
    if (_delegate && [_delegate respondsToSelector:@selector(messageCellDidDoubleClick:)]) {
        [_delegate messageCellDidDoubleClick:self.message];
    }
}

#pragma mark - Setters

- (void)setMessage:(CMessage *)message {
    if (_message && _message.identity == message.identity) {
        return;
    }

    [self.timeLabel setText:[NSString stringWithFormat:@"  %@  ", [message.date messageTimeInfo]]];
    [self.nameLabel setText:[message.sender getPriorityName]];
    
    NSString * avatar = [CubeAppUtil explainAvatarName:[CubeAccount getAvatar:message.sender.context]];
    [self.avatarButton setImage:[UIImage imageNamed:avatar] forState:UIControlStateNormal];

    // 是否显示时间
    if (nil == _message || _message.type != message.type) {
        BOOL showTime = NO;
        if (message.type == CMessageTypeFile) {
            showTime = YES;
        }
        [self.timeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(showTime ? TIMELABEL_HEIGHT : 0);
            make.top.mas_equalTo(self.contentView).mas_offset(showTime ? TIMELABEL_SPACE_Y : 0);
        }];
    }

    BOOL showNameLabel = [message isFromGroup] ? YES : NO;

    // 位置调整
    if (nil == _message || _message.selfTyper != message.selfTyper) {
        // 头像
        [self.avatarButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.width.and.height.mas_equalTo(AVATAR_WIDTH);
            make.top.mas_equalTo(self.timeLabel.mas_bottom).mas_offset(AVATAR_SPACE_Y);
            if (message.selfTyper) {
                make.right.mas_equalTo(self.contentView).mas_offset(-AVATAR_SPACE_X);
            }
            else {
                make.left.mas_equalTo(self.contentView).mas_offset(AVATAR_SPACE_X);
            }
        }];

        // 用户名
        [self.nameLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarButton).mas_equalTo(-NAMELABEL_SPACE_Y);
            if (message.selfTyper) {
                make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-NAMELABEL_SPACE_X);
            }
            else {
                make.left.mas_equalTo(self.avatarButton.mas_right).mas_equalTo(NAMELABEL_SPACE_X);
            }
        }];

        // 背景
        [self.messageBackgroundView mas_remakeConstraints:^(MASConstraintMaker *make) {
            if (message.selfTyper) {
                make.right.mas_equalTo(self.avatarButton.mas_left).mas_offset(-MSGBG_SPACE_X);
            }
            else {
                make.left.mas_equalTo(self.avatarButton.mas_right).mas_offset(MSGBG_SPACE_X);
            }
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(showNameLabel ? showNameLabel : -MSGBG_SPACE_Y);
        }];
    }

    [self.nameLabel setHidden:!showNameLabel];
    [self.nameLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(showNameLabel ? NAMELABEL_HEIGHT : 0);
    }];

    // 赋值
    _message = message;
}

#pragma mark - Getters

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        [_timeLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [_timeLabel setTextColor:[UIColor whiteColor]];
        [_timeLabel setBackgroundColor:[UIColor grayColor]];
        [_timeLabel setAlpha:0.7f];
        [_timeLabel.layer setMasksToBounds:YES];
        [_timeLabel.layer setCornerRadius:5.0f];
    }
    return _timeLabel;
}

- (UIButton *)avatarButton {
    if (!_avatarButton) {
        _avatarButton = [[UIButton alloc] init];
        [_avatarButton.layer setMasksToBounds:YES];
        [_avatarButton.layer setBorderWidth:BORDER_WIDTH_1PX];
        [_avatarButton.layer setBorderColor:[UIColor colorWithWhite:0.7 alpha:1.0].CGColor];
        [_avatarButton addTarget:self action:@selector(avatarButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _avatarButton;
}

- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] init];
        [_nameLabel setTextColor:[UIColor grayColor]];
        [_nameLabel setFont:[UIFont systemFontOfSize:12.0f]];
    }
    return _nameLabel;
}

- (UIImageView *)messageBackgroundView {
    if (!_messageBackgroundView) {
        _messageBackgroundView = [[UIImageView alloc] init];
        [_messageBackgroundView setUserInteractionEnabled:YES];

        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressBackgroundView:)];
        [_messageBackgroundView addGestureRecognizer:longPressGR];

        UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapBackgroundView:)];
        [tapGR setNumberOfTapsRequired:2];
        [_messageBackgroundView addGestureRecognizer:tapGR];
    }
    return _messageBackgroundView;
}

@end
