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

#ifndef CubeSettingItem_h
#define CubeSettingItem_h

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, CubeSettingItemType) {
    CubeSettingItemTypeDefalut = 0,
    CubeSettingItemTypeTitleButton,
    CubeSettingItemTypeSwitch,
    CubeSettingItemTypeOther
};

@interface CubeSettingItem : NSObject

/*!
 * @brief 主标题。
 */
@property (nonatomic, strong) NSString * title;

/*!
 * @brief 副标题
 */
@property (nonatomic, strong) NSString * subTitle;

/*!
 * @brief 右图片(本地)
 */
@property (nonatomic, strong) NSString * rightImageName;

/*!
 * @brief 右图片(网络)
 */
@property (nonatomic, strong) NSString * rightImageURL;

/*!
 * @brief 是否显示箭头（默认YES）
 */
@property (nonatomic, assign) BOOL showDisclosureIndicator;

/*!
 * @brief 停用高亮（默认NO）
 */
@property (nonatomic, assign) BOOL disableHighlight;

/*!
 * @brief Cell 类型，默认 CubeSettingItemTypeDefalut
 */
@property (nonatomic, assign) CubeSettingItemType type;


+ (CubeSettingItem *) itemWithTitle:(NSString *)title;

- (NSString *) cellClassName;

@end

#endif /* CubeSettingItem_h */
