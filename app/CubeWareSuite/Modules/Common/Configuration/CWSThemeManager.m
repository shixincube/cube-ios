//
//  CWSThemeManager.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/4.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CWSThemeManager.h"

@interface CWSThemeManager ()

@property(nonatomic, strong) UIColor *cws_backgroundColor;
@property(nonatomic, strong) UIColor *cws_backgroundColorLighten;
@property(nonatomic, strong) UIColor *cws_backgroundColorHighlighted;
@property(nonatomic, strong) UIColor *cws_tintColor;
@property(nonatomic, strong) UIColor *cws_titleTextColor;
@property(nonatomic, strong) UIColor *cws_mainTextColor;
@property(nonatomic, strong) UIColor *cws_descriptionTextColor;
@property(nonatomic, strong) UIColor *cws_placeholderColor;
@property(nonatomic, strong) UIColor *cws_codeColor;
@property(nonatomic, strong) UIColor *cws_separatorColor;
@property(nonatomic, strong) UIColor *cws_gridItemTintColor;

@property(nonatomic, strong) UIImage *cws_searchBarTextFieldBackgroundImage;
@property(nonatomic, strong) UIImage *cws_searchBarBackgroundImage;

@property(nonatomic, strong) UIVisualEffect *cws_standardBlueEffect;

@property(class, nonatomic, strong, readonly) CWSThemeManager *sharedInstance;

@end

@implementation CWSThemeManager

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static CWSThemeManager *instance = nil;
    dispatch_once(&onceToken,^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone{
    return [self sharedInstance];
}

-(instancetype)init{
    if (self = [super init]) {
        self.cws_backgroundColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<CWSThemeProtocol> *theme) {
            return theme.themeBackgroundColor;
        }];
        self.cws_backgroundColorLighten = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<CWSThemeProtocol> * _Nullable theme) {
            return theme.themeBackgroundColorLighten;
        }];
        self.cws_backgroundColorHighlighted = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<CWSThemeProtocol> *theme) {
            return theme.themeBackgroundColorHighlighted;
        }];
        self.cws_tintColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<CWSThemeProtocol> *theme) {
            return theme.themeTintColor;
        }];
        self.cws_titleTextColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<CWSThemeProtocol> *theme) {
            return theme.themeTitleTextColor;
        }];
        self.cws_mainTextColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<CWSThemeProtocol> *theme) {
            return theme.themeMainTextColor;
        }];
        self.cws_descriptionTextColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<CWSThemeProtocol> *theme) {
            return theme.themeDescriptionTextColor;
        }];
        self.cws_placeholderColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<CWSThemeProtocol> *theme) {
            return theme.themePlaceholderColor;
        }];
        self.cws_codeColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<CWSThemeProtocol> *theme) {
            return theme.themeCodeColor;
        }];
        self.cws_separatorColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, NSObject<CWSThemeProtocol> *theme) {
            return theme.themeSeparatorColor;
        }];
        self.cws_gridItemTintColor = [UIColor qmui_colorWithThemeProvider:^UIColor * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<CWSThemeProtocol> * _Nullable theme) {
            return theme.themeGridItemTintColor;
        }];
        
        self.cws_searchBarTextFieldBackgroundImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<CWSThemeProtocol> * _Nullable theme) {
            return [UISearchBar qmui_generateTextFieldBackgroundImageWithColor:theme.themeBackgroundColorHighlighted];
        }];
        self.cws_searchBarBackgroundImage = [UIImage qmui_imageWithThemeProvider:^UIImage * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, __kindof NSObject<NSCopying> * _Nullable identifier, __kindof NSObject<CWSThemeProtocol> * _Nullable theme) {
            return [UISearchBar qmui_generateBackgroundImageWithColor:theme.themeBackgroundColor borderColor:nil];
        }];
        
        self.cws_standardBlueEffect = [UIVisualEffect qmui_effectWithThemeProvider:^UIVisualEffect * _Nonnull(__kindof QMUIThemeManager * _Nonnull manager, NSString * _Nullable identifier, NSObject<CWSThemeProtocol> * _Nullable theme) {
            return [UIBlurEffect effectWithStyle:[identifier isEqualToString:CWSThemeIdentifierDark] ? UIBlurEffectStyleDark : UIBlurEffectStyleLight];
        }];
    }
    return self;
}

+ (NSObject<CWSThemeProtocol> *)currentTheme {
    return QMUIThemeManagerCenter.defaultThemeManager.currentTheme;
}

@end

@implementation UIColor (CWSTheme)

+ (UIColor *)cws_backgroundColor {
    return CWSThemeManager.sharedInstance.cws_backgroundColor;
}

+ (UIColor *)cws_backgroundColorLighten {
    return CWSThemeManager.sharedInstance.cws_backgroundColorLighten;
}

+ (UIColor *)cws_backgroundColorHighlighted {
    return CWSThemeManager.sharedInstance.cws_backgroundColorHighlighted;
}

+ (UIColor *)cws_tintColor {
    return CWSThemeManager.sharedInstance.cws_tintColor;
}

+ (UIColor *)cws_titleTextColor {
    return CWSThemeManager.sharedInstance.cws_titleTextColor;
}

+ (UIColor *)cws_mainTextColor {
    return CWSThemeManager.sharedInstance.cws_mainTextColor;
}

+ (UIColor *)cws_descriptionTextColor {
    return CWSThemeManager.sharedInstance.cws_descriptionTextColor;
}

+ (UIColor *)cws_placeholderColor {
    return CWSThemeManager.sharedInstance.cws_placeholderColor;
}

+ (UIColor *)cws_codeColor {
    return CWSThemeManager.sharedInstance.cws_codeColor;
}

+ (UIColor *)cws_separatorColor {
    return CWSThemeManager.sharedInstance.cws_separatorColor;
}

+ (UIColor *)cws_gridItemTintColor {
    return CWSThemeManager.sharedInstance.cws_gridItemTintColor;
}

@end


@implementation UIImage (CWSTheme)

+ (UIImage *)cws_searchBarTextFieldBackgroundImage {
    return CWSThemeManager.sharedInstance.cws_searchBarTextFieldBackgroundImage;
}

+ (UIImage *)cws_searchBarBackgroundImage {
    return CWSThemeManager.sharedInstance.cws_searchBarBackgroundImage;
}

@end

@implementation UIVisualEffect (CWSTheme)

+ (UIVisualEffect *)cws_standardBlurEffect {
    return CWSThemeManager.sharedInstance.cws_standardBlueEffect;
}

@end
