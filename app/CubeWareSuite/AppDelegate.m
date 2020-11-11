//
//  AppDelegate.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/8/27.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "AppDelegate.h"

#import "CWSImViewController.h"
#import "CWSRtcViewController.h"

@interface AppDelegate ()

@end

@interface AppDelegate (CubeWareSuiteSupport)
- (__kindof UIViewController *)_generateControllers;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    //获取沙盒路径

//    NSString *path = NSHomeDirectory();
//    NSLog(@"path = %@", path);
//
//    NSDictionary *environmentInfo = [[NSProcessInfo processInfo] environment];
//    NSLog(@"environment info : %@",environmentInfo);
    
    self.window = [[UIWindow alloc] init];
    
    self.window.rootViewController =  [self _generateControllers];//[CWSImViewController new];//[self _generateControllers];
    
    [self.window makeKeyAndVisible];
    
    [self startEngine];

    return YES;
}


- (void)startEngine{
    CKernelConfig *config = [[CKernelConfig alloc] init];
    config.domain = @"shixincube.com";
    config.appKey = @"shixin-cubeteam-opensource-appkey";
    config.address = @"192.168.1.113";
    [[CEngine shareEngine] startWithConfig:config];
}

#pragma mark - UISceneSession lifecycle

//- (UISceneConfiguration *)application:(UIApplication *)application configurationForConnectingSceneSession:(UISceneSession *)connectingSceneSession options:(UISceneConnectionOptions *)options {
//    // Called when a new scene session is being created.
//    // Use this method to select a configuration to create the new scene with.
//    return [[UISceneConfiguration alloc] initWithName:@"Default Configuration" sessionRole:connectingSceneSession.role];
//}
//
//
//- (void)application:(UIApplication *)application didDiscardSceneSessions:(NSSet<UISceneSession *> *)sceneSessions {
//    // Called when the user discards a scene session.
//    // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
//    // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
//}

@end



@implementation AppDelegate (CubeWareSuiteSupport)

- (__kindof UIViewController *)_generateControllers{
    QMUITabBarViewController *tabbarVc = [[QMUITabBarViewController alloc] init];
    
    CWSImViewController *imvc = [CWSImViewController new];
    imvc.hidesBottomBarWhenPushed = NO;
    QMUINavigationController *imnvc = [[QMUINavigationController alloc] initWithRootViewController:imvc];
    imnvc.tabBarItem = [CWSUIHelper tabBarItemWithTitle:@"IM" image:UIImageMake(@"icon_tabbar_im") selectedImage:UIImageMake(@"icon_tabbar_im_selected") tag:0];
    
    CWSRtcViewController *rtcvc = [CWSRtcViewController new];
    rtcvc.hidesBottomBarWhenPushed = NO;
    QMUINavigationController *rtcnvc = [[QMUINavigationController alloc] initWithRootViewController:rtcvc];
    rtcnvc.tabBarItem = [CWSUIHelper tabBarItemWithTitle:@"RTC" image:UIImageMake(@"icon_tabbar_component") selectedImage:UIImageMake(@"icon_tabbar_component_selected") tag:1];
    
    tabbarVc.viewControllers = @[imnvc,rtcnvc];
    return tabbarVc;
}

@end
