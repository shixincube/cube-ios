//
//  CWSThemeManager.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/4.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CWSThemeProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface CWSThemeManager : NSObject

@property(class, nonatomic, readonly, nullable) NSObject<CWSThemeProtocol> *currentTheme;

@end


@interface UIColor (CWSTheme)

@property(class, nonatomic, strong, readonly) UIColor *cws_backgroundColor;
@property(class, nonatomic, strong, readonly) UIColor *cws_backgroundColorLighten;
@property(class, nonatomic, strong, readonly) UIColor *cws_backgroundColorHighlighted;
@property(class, nonatomic, strong, readonly) UIColor *cws_tintColor;
@property(class, nonatomic, strong, readonly) UIColor *cws_titleTextColor;
@property(class, nonatomic, strong, readonly) UIColor *cws_mainTextColor;
@property(class, nonatomic, strong, readonly) UIColor *cws_descriptionTextColor;
@property(class, nonatomic, strong, readonly) UIColor *cws_placeholderColor;
@property(class, nonatomic, strong, readonly) UIColor *cws_codeColor;
@property(class, nonatomic, strong, readonly) UIColor *cws_separatorColor;
@property(class, nonatomic, strong, readonly) UIColor *cws_gridItemTintColor;

@end

@interface UIImage (CWSTheme)
@property(class, nonatomic, strong, readonly) UIImage *cws_searchBarTextFieldBackgroundImage;
@property(class, nonatomic, strong, readonly) UIImage *cws_searchBarBackgroundImage;
@end

@interface UIVisualEffect (CWSTheme)
@property(class, nonatomic, strong, readonly) UIVisualEffect *cws_standardBlurEffect;
@end

NS_ASSUME_NONNULL_END
