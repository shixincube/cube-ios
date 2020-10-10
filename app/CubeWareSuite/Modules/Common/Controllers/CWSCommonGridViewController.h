//
//  CWSCommonGridViewController.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/3.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CWSCommonViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface CWSCommonGridViewController : CWSCommonViewController

@property(nonatomic, strong) QMUIOrderedDictionary<NSString *, UIImage *> *dataSource;
@property(nonatomic, strong, readonly) UIScrollView *scrollView;
@property(nonatomic, strong, readonly) QMUIGridView *gridView;

@end

@interface CWSCommonGridViewController (SubClassHook)

- (void)initDataSource;
- (void)didSelectCellWithTitle:(NSString *)title;
@end

NS_ASSUME_NONNULL_END
