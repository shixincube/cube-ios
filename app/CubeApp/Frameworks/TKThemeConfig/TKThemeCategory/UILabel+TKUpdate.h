//
//  UILabel+TKUpdate.h
//  Pods
//
//  Created by Tkoul on 2020/5/20.
//


#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface UILabel (TKUpdate)
/// 主题设置 在原属性加前缀tkTheme 变更为多主题数组属性。作用参照原属性
@property(nullable,nonatomic,copy)NSArray <UIColor*> *tkThemetextColors;
/// 主题设置 在原属性加前缀tkTheme 变更为多主题数组属性。作用参照原属性
@property(nullable,nonatomic,copy)NSArray <UIColor*> *tkThemeshadowColors;
/// 主题设置 在原属性加前缀tkTheme 变更为多主题数组属性。作用参照原属性
@property(nullable,nonatomic,copy)NSArray <UIColor*> *tkThemehighlightedTextColors;
@end

NS_ASSUME_NONNULL_END
