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

#import "CubeContactsHeaderView.h"

@interface CubeContactsHeaderView ()

@property (nonatomic, strong) UILabel * titleLabel;

@end


@implementation CubeContactsHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        UIView * bgView = [[UIView alloc] init];
        bgView.tkThemebackgroundColors = @[[UIColor colorGrayBG], [UIColor colorDarkBG]];
        [self setBackgroundView:bgView];

        self.titleLabel = self.contentView.addLabel(1001)
            .font([UIFont systemFontOfSize:15])
            .textColor([UIColor grayColor])
            .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make){
                make.left.mas_equalTo(10);
                make.centerY.mas_equalTo(0);
                make.right.mas_lessThanOrEqualTo(-15);
            })
            .view;
    }
    return self;
}

+ (CGFloat)viewHeightByDataModel:(id)dataModel {
    return 22.0f;
}

- (void)setViewDataModel:(id)dataModel {
    self.title = dataModel;
}

#pragma mark - Setters

- (void)setTitle:(NSString *)title {
    _title = title;
    [self.titleLabel setText:title];
}

@end
