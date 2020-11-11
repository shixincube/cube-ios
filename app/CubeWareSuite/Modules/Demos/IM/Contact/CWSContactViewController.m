//
//  CWSContactViewController.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CWSContactViewController.h"

@interface CWSContactViewController ()

@end

@implementation CWSContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)setupNavigationItems{
    [super setupNavigationItems];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem qmui_itemWithImage:UIImageMake(@"icon_nav_about") target:self action:@selector(handleSignOutEvent)];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    CContact *current = [[CEngine shareEngine] contactService].currentContact;
    if (!current) {
        [self _showInputIdAlert];
    }
    else{
        self.title = [NSString stringWithFormat:@"当前账号:%ld",current.contactId];
    }
}


- (void)handleSignOutEvent{
    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:NULL];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"登出" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        [self currentContactSignOut];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [action2.button setImage:[[UIImageMake(@"icon_emotion") qmui_imageResizedInLimitedSize:CGSizeMake(22, 22) resizingMode:QMUIImageResizingModeScaleToFill] qmui_imageWithTintColor:UIColor.cws_tintColor] forState:UIControlStateNormal];
    action2.button.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 8);
    QMUIAlertController *alertController = [[QMUIAlertController alloc] initWithTitle:@"退出联系人登录" message:@"点击确定以登出联系人" preferredStyle:QMUIAlertControllerStyleActionSheet];
    NSMutableDictionary *titleAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetTitleAttributes];
    titleAttributs[NSForegroundColorAttributeName] = UIColorWhite;
    alertController.sheetTitleAttributes = titleAttributs;
    NSMutableDictionary *messageAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetMessageAttributes];
    messageAttributs[NSForegroundColorAttributeName] = UIColorWhite;
    alertController.sheetMessageAttributes = messageAttributs;
    alertController.sheetHeaderBackgroundColor = UIColor.cws_tintColor;
    alertController.sheetSeparatorColor = alertController.sheetButtonBackgroundColor;
    
    NSMutableDictionary *buttonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetButtonAttributes];
    buttonAttributes[NSForegroundColorAttributeName] = alertController.sheetHeaderBackgroundColor;
    alertController.sheetButtonAttributes = buttonAttributes;
    
    NSMutableDictionary *cancelButtonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.sheetCancelButtonAttributes];
    cancelButtonAttributes[NSForegroundColorAttributeName] = buttonAttributes[NSForegroundColorAttributeName];
    alertController.sheetCancelButtonAttributes = buttonAttributes;
    
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}

- (void)_showInputIdAlert{
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"设置你的联系人账号id" message:@"请设置你的联系人账号id用以登入" preferredStyle:QMUIAlertControllerStyleAlert];

    NSMutableDictionary *titleAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertTitleAttributes];
    titleAttributs[NSForegroundColorAttributeName] = UIColorWhite;
    alertController.alertTitleAttributes = titleAttributs;
    NSMutableDictionary *messageAttributs = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertMessageAttributes];
    messageAttributs[NSForegroundColorAttributeName] = UIColorMakeWithRGBA(255, 255, 255, 0.75);
    alertController.alertMessageAttributes = messageAttributs;
    alertController.alertHeaderBackgroundColor = UIColor.cws_tintColor;
    alertController.alertSeparatorColor = alertController.alertButtonBackgroundColor;
    alertController.alertTitleMessageSpacing = 7;

    NSMutableDictionary *buttonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertButtonAttributes];
    buttonAttributes[NSForegroundColorAttributeName] = alertController.alertHeaderBackgroundColor;
    alertController.alertButtonAttributes = buttonAttributes;

    NSMutableDictionary *cancelButtonAttributes = [[NSMutableDictionary alloc] initWithDictionary:alertController.alertCancelButtonAttributes];
    cancelButtonAttributes[NSForegroundColorAttributeName] = buttonAttributes[NSForegroundColorAttributeName];
    alertController.alertCancelButtonAttributes = cancelButtonAttributes;

    QMUIAlertAction *action1 = [QMUIAlertAction actionWithTitle:@"取消" style:QMUIAlertActionStyleCancel handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    QMUIAlertAction *action2 = [QMUIAlertAction actionWithTitle:@"确定" style:QMUIAlertActionStyleDefault handler:^(__kindof QMUIAlertController * _Nonnull aAlertController, QMUIAlertAction * _Nonnull action) {
        NSString *input = alertController.textFields.lastObject.text;
        if (!input.length) {
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            self.title = [NSString stringWithFormat:@"当前账号:%@",input];
            [self currentContactSignIn:input];
        }
    }];

    [alertController addTextFieldWithConfigurationHandler:^(QMUITextField * _Nonnull textField) {
        textField.placeholder = @"id";
        textField.keyboardType = UIKeyboardTypeNumberPad;
    }];

    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController showWithAnimated:YES];
}


#pragma mark - contact api

- (void)currentContactSignIn:(NSString *)contactId{
    // 联系人账号登陆
    CContactService *contact = [CEngine shareEngine].contactService;
    CAuthService *auth = [CEngine shareEngine].authService;
    CContact *me = [[CContact alloc] initWithId:[contactId intValue] domain:auth.token.domain];
    me.name = @"wowowo1";
    CDevice *device = [[CDevice alloc] initWithName:@"iOS" platform:@"ipod gold"];
    [me addDevice:device];
    [contact setCurrentContact:me];
}

- (void)currentContactSignOut{
    CContactService *contact = [CEngine shareEngine].contactService;
    [contact signOut];
}

@end
