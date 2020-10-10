//
//  CWSImViewController.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/7.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CWSImViewController.h"

// contact
#import "CWSContactViewController.h"

// message
#import "CWSMessageViewController.h"

// file
#import "CWSFileViewController.h"

// whiteboard
#import "CWSWhiteboardViewController.h"

// 
#import "MessageKitViewController.h"

#import <CServiceSuite/CServiceSuite.h>


@interface CWSImViewController ()

@end

@implementation CWSImViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)initDataSource{
    self.dataSource = [[QMUIOrderedDictionary alloc] initWithKeysAndObjects:
                       @"Message",UIImageMake(@"comment3"),
                       @"Contact",UIImageMake(@"contacts2"),
                       @"File",UIImageMake(@"file2"),
                       @"Whiteboard",UIImageMake(@"Report2"),nil];
}

- (void)setupNavigationItems {
    [super setupNavigationItems];
    self.title = @"IM";
//    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:self action:@selector(handleAboutItemEvent)];
}

-(void)didSelectCellWithTitle:(NSString *)title{
    UIViewController *vc = nil;
    if ([title isEqualToString:@"Message"]) {
        
        CKernelConfig *config = [[CKernelConfig alloc] init];
        config.domain = @"shixincube.com";
        config.appKey = @"shixin-cubeteam-opensource-appkey";
        config.address = @"192.168.1.113";
        [[CEngine shareEngine] startWithConfig:config];
        
        return;
        vc = [[CWSMessageViewController alloc] init];
    }
    else if ([title isEqualToString:@"Contact"]){
        vc = [[CWSContactViewController alloc] init];
    }
    else if ([title isEqualToString:@"File"]){
        vc = [[CWSFileViewController alloc] init];
    }
    else if ([title isEqualToString:@"Whiteboard"]){
        vc = [[CWSWhiteboardViewController alloc] init];
    }
    vc.title = title;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
