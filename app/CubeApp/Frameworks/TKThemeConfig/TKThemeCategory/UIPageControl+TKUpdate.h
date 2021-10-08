//
//  UIPageControl+TKUpdate.h
//  Pods
//
//  Created by Tkoul on 2020/5/26.
//
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIPageControl (TKUpdate)
/// 主题设置 在原属性加前缀tkTheme 变更为多主题数组属性。作用参照原属性
@property(nullable, nonatomic,copy) NSArray <UIColor*>  *tkThemePageIndicatorTintColors;
/// 主题设置 在原属性加前缀tkTheme 变更为多主题数组属性。作用参照原属性
@property(nullable, nonatomic,copy) NSArray <UIColor*>  *tkThemeCurrentPageIndicatorTintColors;
@end

NS_ASSUME_NONNULL_END
