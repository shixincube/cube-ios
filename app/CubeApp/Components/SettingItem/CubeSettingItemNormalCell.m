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

#import "CubeSettingItemNormalCell.h"

@interface CubeSettingItemNormalCell ()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UILabel * rightLabel;

@property (nonatomic, strong) UIImageView * rightImageView;

- (void)buildView;

@end


@implementation CubeSettingItemNormalCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildView];
    }
    
    return self;
}

#pragma mark - Setters

- (void)setItem:(CubeSettingItem *)item {
    [super setItem:item];
    
    [self.titleLabel setText:item.title];
    [self.rightLabel setText:item.subTitle];
    
    if (item.rightImageName) {
        [self.rightImageView setImage:[UIImage imageNamed:item.rightImageName]];
    }
    else if (item.rightImageURL) {
        // TODO Image URL
    }
    else {
        [self.rightImageView setImage:nil];
    }
    
    [self.rightLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(item.showDisclosureIndicator ? -30.0f : -15.0f);
    }];
}

#pragma mark - Private

- (void)buildView {
    self.titleLabel = self.contentView.addLabel(1)
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
        }).view;
    
    self.rightLabel = self.contentView.addLabel(2)
        .textColor([UIColor grayColor])
        .font([UIFont systemFontOfSize:15.0f])
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.right.mas_equalTo(-30);
            make.centerY.mas_equalTo(self.titleLabel);
            make.left.mas_greaterThanOrEqualTo(self.titleLabel.mas_right).mas_offset(20);
        }).view;
    
    self.rightImageView = self.addImageView(3)
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.right.mas_equalTo(self.rightLabel.mas_left).mas_offset(-2);
            make.centerY.mas_equalTo(0);
        }).view;
    
    [self.titleLabel setContentCompressionResistancePriority:500 forAxis:UILayoutConstraintAxisHorizontal];
    [self.rightLabel setContentCompressionResistancePriority:200 forAxis:UILayoutConstraintAxisHorizontal];
}

@end
