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

#import "CubeConversationNoNetCell.h"

@interface CubeConversationNoNetCell ()

@property (nonatomic, strong) UILabel * titleLabel;

@property (nonatomic, strong) UIImageView * iconView;

- (void)buildView;

@end

@implementation CubeConversationNoNetCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        [self.contentView setBackgroundColor:RGBAColor(255, 223, 224, 1)];

        [self buildView];
    }

    return self;
}

+ (CGFloat)viewHeightByDataModel:(id)dataModel {
    return 45.0f;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.addSeparator(ZZSeparatorPositionBottom);
}

#pragma mark - Private

- (void)buildView {
    self.iconView = self.addImageView(1)
        .image(CImage(@"ConvExclamationMark"))
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.size.mas_equalTo(40);
            make.left.mas_equalTo(10);
            make.centerY.mas_equalTo(0);
        })
        .view;

    self.titleLabel = self.contentView.addLabel(2)
        .text(@"当前网络不可用，请检查你的网络设置")
        .font([UIFont systemFontOfSize:14])
        .textColor([UIColor grayColor])
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.left.mas_equalTo(self.iconView.mas_right).mas_offset(10);
            make.right.mas_lessThanOrEqualTo(-15);
            make.centerY.mas_equalTo(0);
        })
        .view;
}

@end
