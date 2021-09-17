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

#import "CubeSearchController.h"

@interface CubeSearchController ()

- (instancetype)initWithController:(UIViewController<CubeSearchResultsProtocol> *)searchResultsController;

@end

@implementation CubeSearchController

+ (CubeSearchController *)controllerWithSearchResultsController:(UIViewController<CubeSearchResultsProtocol> *)searchResultsController {
    CubeSearchController * controller = [[CubeSearchController alloc] initWithController:searchResultsController];
    [controller setSearchResultsUpdater:searchResultsController];
    return controller;
}

- (instancetype)initWithController:(UIViewController<CubeSearchResultsProtocol> *)searchResultsController {
    if (self = [super initWithSearchResultsController:searchResultsController]) {
        [self setDelegate:searchResultsController];
        self.definesPresentationContext = YES;

        searchResultsController.edgesForExtendedLayout = UIRectEdgeNone;

        // Search Bar
        [self.searchBar setPlaceholder:@"搜索"];
        [self.searchBar setFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [self.searchBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorGrayBG]]];
        [self.searchBar setBarTintColor:[UIColor colorGrayBG]];
        [self.searchBar setTintColor:[UIColor colorBlueDefault]];
        [self.searchBar setDelegate:searchResultsController];
        [self.searchBar setTranslucent:NO];
        
        UITextField * tf = [[self.searchBar.subviews firstObject].subviews lastObject];
        [tf.layer setMasksToBounds:YES];
        [tf.layer setBorderWidth:BORDER_WIDTH_1PX];
        [tf.layer setBorderColor:[UIColor colorGrayLine].CGColor];
        [tf.layer setCornerRadius:5.0f];
        
        for (UIView *view in self.searchBar.subviews[0].subviews) {
            if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
                UIView *bg = [[UIView alloc] init];
                [bg setBackgroundColor:[UIColor colorGrayBG]];
                [view addSubview:bg];
                [bg mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.mas_equalTo(0);
                }];

                UIView *line = [[UIView alloc] init];
                [line setBackgroundColor:[UIColor colorGrayLine]];
                [view addSubview:line];
                [line mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.and.right.and.bottom.mas_equalTo(0);
                    make.height.mas_equalTo(BORDER_WIDTH_1PX);
                }];
                break;
            }
        }
    }
    
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.statusBarStyle;
    }
    else {
        return [UIApplication sharedApplication].statusBarStyle;
    }
}

- (BOOL)prefersStatusBarHidden {
    if (@available(iOS 13.0, *)) {
        return [UIApplication sharedApplication].windows.firstObject.windowScene.statusBarManager.isStatusBarHidden;
    }
    else {
        return [UIApplication sharedApplication].isStatusBarHidden;
    }
}

@end
