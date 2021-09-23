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

#import "CubeConversationCell.h"
#import "UIFont+Cube.h"
#import "TLBadge.h"

#define HEIGHT_CONVERSATION_CELL 64.0f

@interface CubeConversationCell ()

/*! @brief 头像/图标。 */
@property (nonatomic, strong) UIImageView * avatarView;

/*! @brief 主题名称，一般就是标签名。 */
@property (nonatomic, strong) UILabel * nameLabel;

/*! @brief 描述信息。 */
@property (nonatomic, strong) UILabel * detailLabel;

/*! @brief 更新时间。 */
@property (nonatomic, strong) UILabel * timeLabel;

/*! @brief 免打扰标识。 */
@property (nonatomic, strong) UIImageView * remindImageView;

/*! @brief 提示气泡。 */
@property (nonatomic, strong) TLBadge * badge;

@end


@implementation CubeConversationCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildView];
    }

    return self;
}

- (void)markAsUnread {
    
}

- (void)markAsRead {
    
}

#pragma mark - Override

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (self.bottomSeperatorStyle == CubeConversationCellSeperatorStyleDefault) {
        self.addSeparator(ZZSeparatorPositionBottom).beginAt(15);
    }
    else {
        self.addSeparator(ZZSeparatorPositionBottom);
    }
}

+ (CGFloat)viewHeightByDataModel:(id)dataModel {
    return HEIGHT_CONVERSATION_CELL;
}

- (void)setViewDataModel:(id)dataModel {
    [self setConversation:dataModel];
}

- (void)onViewPositionUpdatedWithIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count {
    self.bottomSeperatorStyle = (indexPath.row == count - 1) ? CubeConversationCellSeperatorStyleFill : CubeConversationCellSeperatorStyleDefault;
}

#pragma mark - Setters

- (void)setConversation:(CubeConversation *)conversation {
    _conversation = conversation;

    if (conversation.avatarName) {
        [self.avatarView setImage:[UIImage imageNamed:conversation.avatarName]];
    }
    
    [self.nameLabel setText:conversation.displayName];
    [self.detailLabel setText:conversation.content];
//    self
}

- (void)setBottomSeperatorStyle:(CubeConversationCellSeperatorStyle)bottomSeperatorStyle {
    _bottomSeperatorStyle = bottomSeperatorStyle;
    [self setNeedsDisplay];
}

#pragma mark - Private

- (void)buildView {
    // 头像/图标
    self.avatarView = self.contentView.addImageView(1001)
        .cornerRadius(3.0f)
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        })
        .view;
    [self.avatarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.avatarView.mas_height);
    }];

    // 主题名称
    self.nameLabel = self.contentView.addLabel(1002)
        .font([UIFont fontConversationName])
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarView.mas_right).mas_offset(10);
            make.top.mas_equalTo(self.avatarView).mas_offset(1.5);
            make.right.mas_lessThanOrEqualTo(self.timeLabel.mas_left).mas_offset(-5);
        })
        .view;
    [self.nameLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    
    // 时间
    self.timeLabel = self.contentView.addLabel(1003)
        .font([UIFont fontConversationTime])
        .textColor([UIColor colorTextLightGray])
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.top.mas_equalTo(self.avatarView).mas_offset(2);
            make.right.mas_equalTo(self.contentView).mas_offset(-9.5);
        })
        .view;
    [self.timeLabel setContentCompressionResistancePriority:300 forAxis:UILayoutConstraintAxisHorizontal];
    
    // 免打扰标识
    self.remindImageView = self.contentView.addImageView(1004)
        .alpha(0.4)
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.right.mas_equalTo(self.timeLabel);
            make.bottom.mas_equalTo(self.avatarView);
        })
        .view;
    [self.remindImageView setContentCompressionResistancePriority:310 forAxis:UILayoutConstraintAxisHorizontal];
    
    // 描述信息
    self.detailLabel = self.contentView.addLabel(2001)
        .font([UIFont fontConversationDetail])
        .textColor([UIColor colorTextGray])
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.top.mas_equalTo(self.nameLabel.mas_bottom).mas_offset(4);
            make.left.mas_equalTo(self.nameLabel);
            make.right.mas_lessThanOrEqualTo(self.remindImageView.mas_left);
        })
        .view;
    [self.detailLabel setContentCompressionResistancePriority:110 forAxis:UILayoutConstraintAxisHorizontal];
    
    // 气泡
    self.badge = [[TLBadge alloc] init];
    [self.contentView addSubview:self.badge];
    [self.badge mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.avatarView.mas_right).mas_offset(-1.5);
        make.centerY.mas_equalTo(self.avatarView.mas_top).mas_offset(1.5);
    }];

    [self layoutIfNeeded];
}

@end
