/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Cube Team.
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

#ifndef CubeShortcutMacros_h
#define CubeShortcutMacros_h

#define     IS_IPHONEX              (([UIScreen mainScreen].bounds.size.width == 375.0f && [UIScreen mainScreen].bounds.size.height == 812.0f) || ([UIScreen mainScreen].bounds.size.width == 414.0f && [UIScreen mainScreen].bounds.size.height == 896.0f))

#pragma mark - # 屏幕尺寸
#define     SCREEN_SIZE                 [UIScreen mainScreen].bounds.size
#define     SCREEN_WIDTH                SCREEN_SIZE.width
#define     SCREEN_HEIGHT               SCREEN_SIZE.height

#pragma mark - # 常用控件高度
#define     STATUSBAR_HEIGHT            (IS_IPHONEX ? 44.0f : 20.0f)
#define     TABBAR_HEIGHT               (IS_IPHONEX ? 49.0f + 34.0f : 49.0f)
#define     NAVBAR_HEIGHT               44.0f
#define     SEARCHBAR_HEIGHT            (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0") ? 52.0f : 44.0f)
#define     BORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)

#define     SAFEAREA_INSETS     \
({   \
    UIEdgeInsets edgeInsets = UIEdgeInsetsZero; \
    if (@available(iOS 13.0, *)) {      \
        edgeInsets = [UIApplication sharedApplication].windows[0].safeAreaInsets;     \
    }   \
    else if (@available(iOS 11.0, *)) {    \
        edgeInsets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;    \
    }   \
    edgeInsets;  \
})

#define     SAFEAREA_INSETS_BOTTOM      (SAFEAREA_INSETS.bottom)

//MAKR: 设备类型
#define     IS_IPAD                 [[UIDevice currentDevice].model isEqualToString:@"iPad"]
#define     IS_IPHONE               [[UIDevice currentDevice].model isEqualToString:@"iPhone"]

#pragma mark - # 设备(屏幕)类型
#define     SCRREN_IPHONE4              (SCREEN_HEIGHT >= 480.0f)           // 320 * 480
#define     SCRREN_IPHONE5              (SCREEN_HEIGHT >= 568.0f)           // 320 * 568
#define     SCRREN_IPHONE6              (SCREEN_HEIGHT >= 667.0f)           // 375 * 667
#define     SCRREN_IPHONE6P             (SCREEN_HEIGHT >= 736.0f)           // 414 * 736


#pragma mark - # 系统方法简写
/// 广播中心
#define     CNotificationCenter        [NSNotificationCenter defaultCenter]
/// 用户自定义数据
#define     CUserDefaults              [NSUserDefaults standardUserDefaults]
/// URL
#define     CURL(urlString)            [NSURL URLWithString:urlString]
/// 图片
#define     CImage(imageName)          [UIImage imageNamed:imageName]
#define     CPNG(X)                    [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:X ofType:@"png"]]
#define     CJPG(X)                    [[UIImage alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:X ofType:@"jpg"]]
/// 字符串
#define     CNoNilString(str)          (str.length > 0 ? str : @"")
/// 方法名
#define     CStirngFormSelector(s)     [[NSString alloc] initWithUTF8String:sel_getName(s)]
/// 颜色
#define     RGBColor(r, g, b)           [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0]
#define     RGBAColor(r, g, b, a)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:a]
#define     HexColor(color)             [UIColor colorWithRed:((float)((color & 0xFF0000) >> 16))/255.0 green:((float)((color & 0xFF00) >> 8))/255.0 blue:((float)(color & 0xFF))/255.0 alpha:1.0]
#define     HexAColor(color, a)         [UIColor colorWithRed:((float)((color & 0xFF0000) >> 16))/255.0 green:((float)((color & 0xFF00) >> 8))/255.0 blue:((float)(color & 0xFF))/255.0 alpha:a]

/// 国际化
#define     LOCSTR(str)                 NSLocalizedString(str, nil)


#pragma mark - # 快捷方法
/// PushVC
#define     PushVC(vc)                  {\
            [vc setHidesBottomBarWhenPushed:YES];\
            [self.navigationController pushViewController:vc animated:YES];\
}

/// 方法交换
#define     CExchangeMethod(oldSEL, newSEL) {\
            Method oldMethod = class_getInstanceMethod(self, oldSEL);\
            Method newMethod = class_getInstanceMethod(self, newSEL);\
            method_exchangeImplementations(oldMethod, newMethod);\
}\

#pragma mark - # 多线程
#define     CBackThread(block)         dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)
#define     CMainThread(block)         dispatch_async(dispatch_get_main_queue(), block)
#define     CMainBarrier(block)        dispatch_barrier_async(dispatch_get_main_queue(), block)
#define     CMainAfter(x, block)       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(x * NSEC_PER_SEC)), dispatch_get_main_queue(), block);

#pragma mark - # 循环引用消除
#ifndef weakify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define weakify(object)     autoreleasepool{} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object)     autoreleasepool{} __block __typeof__(object) block##_##object = object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define weakify(object)     try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
        #else
            #define weakify(object)     try{} @finally{} {} __block __typeof__(object) block##_##object = object;
        #endif
    #endif
#endif

#ifndef strongify
    #if DEBUG
        #if __has_feature(objc_arc)
            #define strongify(object)   autoreleasepool{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object)   autoreleasepool{} __typeof__(object) object = block##_##object;
        #endif
    #else
        #if __has_feature(objc_arc)
            #define strongify(object)   try{} @finally{} __typeof__(object) object = weak##_##object;
        #else
            #define strongify(object)   try{} @finally{} __typeof__(object) object = block##_##object;
        #endif
    #endif
#endif
#define     CWeakSelf(type)            __weak typeof(type) weak_##type = type;
#define     CStrongSelf(type)          __strong typeof(type) strong_##type = type;

#pragma mark - # XCode
#define     XCODE_VERSION_8_LATER       __has_include(<UserNotifications/UserNotifications.h>)

#pragma mark - # 系统版本
#define     SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define     SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define     SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define     SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif /* CubeShortcutMacros_h */
