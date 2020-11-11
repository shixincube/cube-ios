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
}

-(void)didSelectCellWithTitle:(NSString *)title{
    UIViewController *vc = nil;
    if ([title isEqualToString:@"Message"]) {
        if (![[CEngine shareEngine] contactService].currentContact) {
            [self _showAlertToSignIn];
            return;
        }
        
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


- (void)_showAlertToSignIn{
    UIView *parentView = self.view;
    [QMUITips showInfo:@"您的联系人账户未登入" detailText:@"请去联系人模块设置账户登入" inView:parentView hideAfterDelay:2];
}

@end
