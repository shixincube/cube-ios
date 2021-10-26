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

#import "CubeProfileInfoAvatarCell.h"

@interface CubeProfileInfoAvatarCell ()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * avatarImageView;

- (void)makeMasonry;

@end


@implementation CubeProfileInfoAvatarCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.titleLabel];
        [self.contentView addSubview:self.avatarImageView];

        [self makeMasonry];
    }

    return self;
}

#pragma mark - Protocol

+ (CGFloat)viewHeightByDataModel:(id)dataModel {
    return 85.0f;
}

#pragma mark - Private

- (void)makeMasonry {
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView);
        make.left.mas_equalTo(self.contentView).mas_offset(15);
        make.right.mas_lessThanOrEqualTo(self.avatarImageView.mas_left).mas_offset(-15);
    }];

    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-30);
        make.top.mas_equalTo(self.contentView).mas_offset(9);
        make.bottom.mas_equalTo(self.contentView).mas_equalTo(-9);
        make.width.mas_equalTo(self.avatarImageView.mas_height);
    }];
}

#pragma mark - Setters

- (void)setItem:(CubeSettingItem *)item {
    [super setItem:item];

    [self.titleLabel setText:item.title];

    if (item.rightImageName) {
        [self.avatarImageView setImage:[UIImage imageNamed:item.rightImageName]];
    }
    else if (item.rightImageURL) {
        // TODO
    }
    else {
        [self.avatarImageView setImage:nil];
    }
}

#pragma mark - Getters

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
    }

    return _titleLabel;
}

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView.layer setMasksToBounds:YES];
        [_avatarImageView.layer setCornerRadius:4.0f];
    }

    return _avatarImageView;
}

@end
