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

#import "CubeProfileHeaderCell.h"
#import "CubeAccount.h"
#import "CubeAppUtil.h"

#define INFO_SPACE_X 14.0f
#define INFO_SPACE_Y 12.0f

@interface CubeProfileHeaderCell ()

@property (nonatomic, strong) UIImageView * avatarImageView;

@property (nonatomic, strong) UILabel * nikenameLabel;

@property (nonatomic, strong) UILabel * cubeIdLabel;

@property (nonatomic, strong) UIImageView * indicatorView;

- (void)makeMasonry;

@end


@implementation CubeProfileHeaderCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setSelectedBackgroundColor:[UIColor colorGrayLine]];
        [self.contentView addSubview:self.avatarImageView];
        [self.contentView addSubview:self.nikenameLabel];
        [self.contentView addSubview:self.cubeIdLabel];
        [self.contentView addSubview:self.indicatorView];

        [self makeMasonry];
    }

    return self;
}

#pragma mark - Private

- (void)makeMasonry {
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(INFO_SPACE_X);
        make.top.mas_equalTo(INFO_SPACE_Y);
        make.bottom.mas_equalTo(-INFO_SPACE_Y);
        make.width.mas_equalTo(self.avatarImageView.mas_height);
    }];

    [self.nikenameLabel setContentCompressionResistancePriority:100 forAxis:UILayoutConstraintAxisHorizontal];
    [self.nikenameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.avatarImageView.mas_right).mas_offset(INFO_SPACE_Y);
        make.bottom.mas_equalTo(self.avatarImageView.mas_centerY).mas_offset(-3.5);
    }];
    
    [self.cubeIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.nikenameLabel);
        make.top.mas_equalTo(self.avatarImageView.mas_centerY).mas_offset(5.0);
    }];

    [self.indicatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(8, 13));
        make.right.mas_equalTo(-15);
    }];
}

#pragma mark - Protocol

+ (CGFloat)viewHeightByDataModel:(id)dataModel {
    return 90;
}

- (void)setViewDataModel:(id)dataModel {
    [self setAccount:dataModel];
}

- (void)onViewPositionUpdatedWithIndexPath:(NSIndexPath *)indexPath sectionItemCount:(NSInteger)count {
    if (indexPath.row == 0) {
        self.addSeparator(ZZSeparatorPositionTop);
    }
    else {
        self.removeSeparator(ZZSeparatorPositionTop);
    }
    
    if (indexPath.row == count - 1) {
        self.addSeparator(ZZSeparatorPositionBottom);
    }
    else {
        self.addSeparator(ZZSeparatorPositionBottom).beginAt(15);
    }
}

#pragma mark - Setters

- (void)setAccount:(CubeAccount *)account {
    _account = account;
    
    NSString * avatar = [CubeAppUtil explainAvatarName:account.avatar];
    if (nil != avatar) {
        // 使用默认头像
        [self.avatarImageView setImage:[UIImage imageNamed:avatar]];
    }
    else {
        // TODO 使用网络头像
    }
    
    [self.nikenameLabel setText:account.displayName];
    [self.cubeIdLabel setText:[NSString stringWithFormat:@"%@: %lu", @"魔方号", account.identity]];
}

#pragma mark - Getters

- (UIImageView *)avatarImageView {
    if (!_avatarImageView) {
        _avatarImageView = [[UIImageView alloc] init];
        [_avatarImageView.layer setMasksToBounds:YES];
        [_avatarImageView.layer setCornerRadius:5.0f];
        [_avatarImageView.layer setBorderWidth:BORDER_WIDTH_1PX];
        [_avatarImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
    }

    return _avatarImageView;
}

- (UILabel *)nikenameLabel {
    if (!_nikenameLabel) {
        _nikenameLabel = [[UILabel alloc] init];
        [_nikenameLabel setText:@"昵称"];
        [_nikenameLabel setFont:[UIFont systemFontOfSize:17]];
    }

    return _nikenameLabel;
}

- (UILabel *)cubeIdLabel {
    if (!_cubeIdLabel) {
        _cubeIdLabel = [[UILabel alloc] init];
        [_cubeIdLabel setText:@"魔方号"];
        [_cubeIdLabel setFont:[UIFont systemFontOfSize:14]];
        [_cubeIdLabel setTextColor:[UIColor colorTextGray]];
    }

    return _cubeIdLabel;
}

- (UIImageView *)indicatorView {
    if (!_indicatorView) {
        _indicatorView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"CellIndicator"]];
    }

    return _indicatorView;
}

@end
