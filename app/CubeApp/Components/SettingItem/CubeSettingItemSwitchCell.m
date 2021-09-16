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

#import "CubeSettingItemSwitchCell.h"

@interface CubeSettingItemSwitchCell ()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UISwitch * switchControl;

- (void)buildView;

@end


@implementation CubeSettingItemSwitchCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self buildView];
    }

    return self;
}

#pragma mark - Setters

- (void)setItem:(CubeSettingItem *)item {
    item.showDisclosureIndicator = NO;
    item.disableHighlight = YES;
    
    [super setItem:item];

    [self.titleLabel setText:item.title];
}

#pragma mark - Private

- (void)buildView {
    self.titleLabel = self.contentView.addLabel(1)
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.left.mas_equalTo(15);
            make.right.mas_lessThanOrEqualTo(-80);
        }).view;
    
    self.switchControl = self.contentView.addSwitch(2)
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.centerY.mas_equalTo(0);
            make.right.mas_lessThanOrEqualTo(-15);
        }).view;
}

@end
