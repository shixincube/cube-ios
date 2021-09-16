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

#import "CubeMenuItemCell.h"

#define WIDTH_ICON_RIGHT        31
#define EGDE_RIGHT_IMAGE        13
#define EGDE_SUB_TITLE          8

@implementation CubeMenuItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        [self setSelectedBackgroundColor:[UIColor colorGrayLine]];

        [self buildView];
    }

    return self;
}

- (void)setMenuItem:(CubeMenuItem *)menuItem {
    _menuItem = menuItem;

    if (menuItem.iconName) {
        [self.iconView setImage:[UIImage imageNamed:menuItem.iconName]];
    }
    else if (menuItem.iconURL) {
        // TODO 读取网络图片
    }

    // 标题
    [self.titleLabel setText:menuItem.title];

    // 气泡
    [self.badgeView setHidden:YES];
    if (menuItem.badge) {
        [self.badgeView setHidden:NO];
        [self.badgeView setBadgeValue:menuItem.badge];
        [self.badgeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(menuItem.badgeSize);
        }];
    }
    else {
        [self.badgeView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(0);
        }];
    }

    // 详情描述
    [self.detailLabel setText:menuItem.subTitle];

    // 右图
    [self.rightBadgeView setHidden:YES];
    if (menuItem.rightIconName) {
        [self.rightImageView setHidden:NO];
        [self.rightImageView setImage:[UIImage imageNamed:menuItem.rightIconName]];
        
        if (menuItem.subTitle) {
            [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.indicatorView.mas_left).mas_offset(-WIDTH_ICON_RIGHT - EGDE_RIGHT_IMAGE - EGDE_SUB_TITLE);
            }];
        }

        // 图片上方气泡
        if (menuItem.showRightIconBadge) {
            [self.rightBadgeView setHidden:NO];
        }
    }
    else {
        [self.rightImageView setHidden:YES];
        if (menuItem.subTitle) {
            [self.detailLabel mas_updateConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(self.indicatorView.mas_left).mas_offset(- EGDE_RIGHT_IMAGE);
            }];
        }
    }
}

#pragma mark - Private

-(void)buildView {
    // 主图标
    self.iconView = self.addImageView(1)
        .masonry(^(__kindof UIView *senderView, MASConstraintMaker *make) {
            make.left.mas_equalTo(15);
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(25);
        }).view;

    // 标题
    self.titleLabel = self.addLabel(2)
        .masonry(^(__kindof UIView *senderView, MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(self.iconView.mas_right).mas_offset(15);
            make.right.mas_lessThanOrEqualTo(-15);
        }).view;
    
    // 气泡
    [self.contentView addSubview:self.badgeView];
    [self.badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(15);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(18);
    }];

    // 指示器图标
    self.indicatorView = self.addImageView(5)
        .image(CImage(@"CellIndicator"))
        .masonry(^(__kindof UIView *senderView, MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(8, 13));
            make.right.mas_equalTo(-15);
        }).view;
    
    // 右侧图
    [self.contentView addSubview:self.rightImageView];
    [self.rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.indicatorView.mas_left).mas_offset(-EGDE_RIGHT_IMAGE);
        make.centerY.mas_equalTo(0);
        make.size.mas_equalTo(WIDTH_ICON_RIGHT);
    }];
    
    // 详细描述
    self.detailLabel = self.addLabel(6)
        .font([UIFont systemFontOfSize:14])
        .textColor([UIColor grayColor])
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.left.mas_greaterThanOrEqualTo(self.badgeView.mas_right).mas_offset(15);
            make.right.mas_equalTo(self.indicatorView.mas_left).mas_offset(-WIDTH_ICON_RIGHT - EGDE_RIGHT_IMAGE - EGDE_SUB_TITLE);
            make.centerY.mas_equalTo(self.iconView);
        }).view;
    
    [self.detailLabel setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.titleLabel setContentCompressionResistancePriority:600 forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - Protocol

+ (CGFloat)viewHeightByDataModel:(id)dataModel {
    return 44.0f;
}

- (void)setViewDataModel:(id)dataModel {
    [self setMenuItem:dataModel];
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

#pragma mark - Getters

-(TLBadge *)badgeView {
    if (!_badgeView) {
        _badgeView = [[TLBadge alloc] initWithFrame:CGRectMake(0, 0, 0, 18)];
    }

    return _badgeView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [[UIImageView alloc] init];

        [_rightImageView addSubview:self.rightBadgeView];
        [self.rightBadgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(_rightImageView.mas_right);
            make.centerY.mas_equalTo(_rightImageView.mas_top).mas_offset(1);
            make.size.mas_equalTo(8);
        }];
    }

    return _rightImageView;
}

- (TLBadge *)rightBadgeView {
    if (!_rightBadgeView) {
        _rightBadgeView = [[TLBadge alloc] initWithFrame:CGRectMake(0, 0, 0, 18)];
        [_rightBadgeView setBadgeValue:@""];
    }

    return _rightBadgeView;
}

@end
