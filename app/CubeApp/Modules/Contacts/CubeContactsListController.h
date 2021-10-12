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

#ifndef CubeContactsListController_h
#define CubeContactsListController_h

#import <UIKit/UIKit.h>

@class CubeContactsCategory;

typedef NS_ENUM(NSInteger, CubeContactsSectionType) {
    CubeContactsSectionTypeFuncation = -1,
    CubeContactsSectionTypeEnterprise = -2,
};

typedef NS_ENUM(NSInteger, CubeContactsCellType) {
    CubeContactsCellTypeNew = -1,
    CubeContactsCellTypeGroup = -2,
    CubeContactsCellTypeTag = -3,
    CubeContactsCellTypeOther = -4
};

@interface CubeContactsListController : ZZFLEXAngel <UITableViewDelegate>

@property (nonatomic, copy) void (^pushAction)(__kindof UIViewController * viewController);

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView pushAction:(void (^)(__kindof UIViewController * viewController))pushAction;

- (void)resetListWithContactsData:(NSArray<__kindof CubeContactsCategory *> *)contactsData sectionHeaders:(NSArray<__kindof NSString *> *)sectionHeaders;

@end

#endif /* CubeContactsListController_h */
