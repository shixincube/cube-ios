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

#import "CubeSettingItemBaseCell.h"

@implementation CubeSettingItemBaseCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        self.arrowView = self.addImageView(10)
            .image([UIImage imageNamed:@"ArrowRight"])
            .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
                make.centerY.mas_equalTo(0);
                make.size.mas_equalTo(CGSizeMake(8, 13));
                make.right.mas_equalTo(-15);
            }).view;
    }

    return self;
}

#pragma mark - Setters

- (void)setItem:(CubeSettingItem *)item {
    _item = item;

    [self setSelectedBackgroundColor:item.disableHighlight ? nil : [UIColor colorGrayLine]];
    [self.arrowView setHidden:!item.showDisclosureIndicator];
}

#pragma mark - Protocol

+ (CGFloat)viewHeightByDataModel:(id)dataModel {
    return 44.0f;
}

- (void)setViewDataModel:(id)dataModel {
    [self setItem:dataModel];
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

@end
