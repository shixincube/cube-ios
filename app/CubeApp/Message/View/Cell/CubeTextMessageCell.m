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

#import "CubeTextMessageCell.h"
#import "UIFont+Cube.h"

#define     MSG_SPACE_TOP       14
#define     MSG_SPACE_BTM       20
#define     MSG_SPACE_LEFT      19
#define     MSG_SPACE_RIGHT     22


@interface CubeTextMessageCell ()

@property (nonatomic, strong) UILabel * contentLabel;

@end

@implementation CubeTextMessageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.contentLabel];
    }
    return self;
}

- (void)updateMessage:(CMessage *)message {
    if (self.message && self.message.identity == message.identity) {
        return;
    }
    
    if (![message isKindOfClass:[CHyperTextMessage class]]) {
        return;
    }

    BOOL lastSelfTyper = self.message ? self.message.selfTyper : YES;

    [super updateMessage:message];

    CHyperTextMessage * textMessage = (CHyperTextMessage *)message;

    [self.contentLabel setAttributedText:textMessage.attributedText];
    [self.contentLabel setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];

    [self.messageBackgroundView setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    
    if (lastSelfTyper != message.selfTyper) {
        if (message.selfTyper) {
            [self.messageBackgroundView setImage:[UIImage imageWithColor:[UIColor colorThemeBlue]]];
            [self.messageBackgroundView setHighlightedImage:[UIImage imageWithColor:[UIColor colorThemeBlueHighlighted]]];

            [self.contentLabel setTextColor:[UIColor colorTextWhite]];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.messageBackgroundView).mas_offset(-MSG_SPACE_RIGHT);
                make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP);
            }];
            
            [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.contentLabel).mas_offset(-MSG_SPACE_LEFT);
                make.bottom.mas_equalTo(self.contentLabel).mas_offset(MSG_SPACE_BTM);
            }];
        }
        else {
            [self.messageBackgroundView setImage:[UIImage imageWithColor:[UIColor colorTextGray]]];
            [self.messageBackgroundView setHighlightedImage:[UIImage imageWithColor:[UIColor colorTextLightGray]]];
            
            [self.contentLabel setTextColor:[UIColor colorTextBlack]];
            [self.contentLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_LEFT);
                make.top.mas_equalTo(self.messageBackgroundView).mas_offset(MSG_SPACE_TOP);
            }];

            [self.messageBackgroundView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.contentLabel).mas_offset(MSG_SPACE_RIGHT);
                make.bottom.mas_equalTo(self.contentLabel).mas_offset(MSG_SPACE_BTM);
            }];
        }
    }

    [self.contentLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo([CubeMessageFrame frameWithTextMessage:message label:self.contentLabel showTime:self.showTime showNameLabel:self.showNameLabel].contentSize);
    }];
}

#pragma mark - Getters

- (UILabel *)contentLabel {
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc] init];
        [_contentLabel setFont:[UIFont fontTextMessageText]];
        [_contentLabel setNumberOfLines:0];
    }
    return _contentLabel;
}

@end
