//
//  CWSUIHelper.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/7.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

// Helper for qmui interface
//  detail info please read qmui.

NS_ASSUME_NONNULL_BEGIN

@interface CWSUIHelper : NSObject
+ (void)forceInterfaceOrientationPortrait;
@end


@interface CWSUIHelper (QMUIMoreOperationAppearance)
+ (void)customMoreOperationAppearance;
@end

@interface CWSUIHelper (QMUIAlertControllerAppearance)
+ (void)customAlertControllerAppearance;
@end

@interface CWSUIHelper (QMUIDialogViewControllerAppearance)
+ (void)customDialogViewControllerAppearance;
@end

@interface CWSUIHelper (QMUIEmotionView)
+ (void)customEmotionViewAppearance;
@end

@interface CWSUIHelper (QMUIImagePicker)
+ (void)customImagePickerAppearance;
@end

@interface CWSUIHelper (QMUIPopupContainerView)
+ (void)customPopupAppearance;
@end

@interface CWSUIHelper (UITabBarItem)
+ (UITabBarItem *)tabBarItemWithTitle:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage tag:(NSInteger)tag;
@end


@interface CWSUIHelper (Button)
+ (QMUIButton *)generateDarkFilledButton;
+ (QMUIButton *)generateLightBorderedButton;
@end

@interface CWSUIHelper (Emotion)
+ (NSArray<QMUIEmotion *> *)qmuiEmotions;

/// 用于主题更新后，更新表情 icon 的颜色
+ (void)updateEmotionImages;
@end

@interface CWSUIHelper (SavePhoto)
+ (void)showAlertWhenSavedPhotoFailureByPermissionDenied;
@end

@interface CWSUIHelper (Calculate)
+ (NSString *)humanReadableFileSize:(long long)size;
@end

@interface CWSUIHelper (Theme)
+ (UIImage *)navigationBarBackgroundImageWithThemeColor:(UIColor *)color;
@end

@interface NSString (Code)
- (void)enumerateCodeStringUsingBlock:(void (^)(NSString *codeString, NSRange codeRange))block;
@end





NS_ASSUME_NONNULL_END
