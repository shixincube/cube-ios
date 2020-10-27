//
//  CWSCommonUI.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/7.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CWSCommonUI.h"

NSString *const CWSSelectedThemeIdentifier = @"selectedThemeIdentifier";
NSString *const CWSThemeIdentifierDefault = @"Default";
NSString *const CWSThemeIdentifierGrapefruit = @"Grapefruit";
NSString *const CWSThemeIdentifierGrass = @"Grass";
NSString *const CWSThemeIdentifierPinkRose = @"Pink Rose";
NSString *const CWSThemeIdentifierDark = @"Dark";

const CGFloat CWSButtonSpacingHeight = 72;

@implementation CWSCommonUI

+ (void)renderGlobalAppearances {
    [CWSUIHelper customMoreOperationAppearance];
    [CWSUIHelper customAlertControllerAppearance];
    [CWSUIHelper customDialogViewControllerAppearance];
    [CWSUIHelper customImagePickerAppearance];
    [CWSUIHelper customEmotionViewAppearance];
    [CWSUIHelper customPopupAppearance];
    
    UISearchBar *searchBar = [UISearchBar appearance];
    searchBar.searchTextPositionAdjustment = UIOffsetMake(4, 0);
    
    QMUILabel *label = [QMUILabel appearance];
    label.highlightedBackgroundColor = TableViewCellSelectedBackgroundColor;
}

@end

@implementation CWSCommonUI (ThemeColor)

static NSArray<UIColor *> *themeColors = nil;
+ (UIColor *)randomThemeColor {
    if (!themeColors) {
        themeColors = @[UIColorTheme1,
                        UIColorTheme2,
                        UIColorTheme3,
                        UIColorTheme4,
                        UIColorTheme5,
                        UIColorTheme6,
                        UIColorTheme7,
                        UIColorTheme8,
                        UIColorTheme9,
                        UIColorTheme10];
    }
    return themeColors[arc4random() % themeColors.count];
}

@end

@implementation CWSCommonUI (Layer)

+ (CALayer *)generateSeparatorLayer {
    CALayer *layer = [CALayer layer];
    [layer qmui_removeDefaultAnimations];
    layer.backgroundColor = UIColorSeparator.CGColor;
    return layer;
}

@end

