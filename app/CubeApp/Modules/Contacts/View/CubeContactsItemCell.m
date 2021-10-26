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

#import "CubeContactsItemCell.h"

@interface CubeContactsItemCell ()

@property (nonatomic, strong) UIImageView * avatarView;

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * subTitleLabel;

@end


@implementation CubeContactsItemCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self buildView];
    }
    return self;
}

#pragma mark - Override

+ (CGFloat)viewHeightByDataModel:(id)dataModel {
    return 55.0f;
}

- (void)setViewDataModel:(id)dataModel {
    self.model = dataModel;
}

- (void)onViewPositionUpdatedWithIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count {
    if (indexPath.row == count - 1) {
        self.removeSeparator(ZZSeparatorPositionBottom);
    }
    else {
        self.addSeparator(ZZSeparatorPositionBottom).beginAt(10);
    }
}

#pragma mark - Private

- (void)buildView {
    self.avatarView = self.contentView.addImageView(1001)
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.left.top.mas_equalTo(10);
            make.bottom.mas_equalTo(-10);
        }).view;
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.avatarView.mas_height);
    }];

    self.titleLabel = self.contentView.addLabel(1002)
        .font([UIFont systemFontOfSize:17.0f])
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.left.mas_equalTo(self.avatarView.mas_right).mas_offset(10);
            make.centerY.mas_equalTo(self.avatarView);
            make.right.mas_lessThanOrEqualTo(-20);
        })
        .view;

    self.subTitleLabel = self.contentView.addLabel(3)
        .font([UIFont systemFontOfSize:14.0f])
        .textColor([UIColor grayColor])
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.left.mas_equalTo(self.titleLabel);
            make.top.mas_equalTo(self.titleLabel.mas_bottom).mas_offset(2);
            make.right.mas_lessThanOrEqualTo(-20);
        })
        .view;
}

#pragma mark - Setters

- (void)setModel:(CubeContactsItemModel *)model {
    _model = model;

    if (model.imageURL) {
        UIImage *placeholder = model.placeholderImage ? model.placeholderImage : CImage(@"AvatarDefault");
        [self.avatarView setImageWithURL:CURL(model.imageURL) placeholderImage:placeholder];
    }
    else if (model.imageName) {
        [self.avatarView setImage:CImage(model.imageName)];
    }

    self.titleLabel.text = model.title;
    self.subTitleLabel.text = model.subTitle;

    if (model.subTitle.length > 0) {
        if (self.subTitleLabel.isHidden) {
            [self.subTitleLabel setHidden:NO];
            [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(self.avatarView).mas_offset(-9.5);
            }];
        }
    }
    else {
        [self.subTitleLabel setHidden:YES];
        [self.titleLabel mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.avatarView);
        }];
    }
}

@end
