//
//  CWSMessageViewController.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CWSMessageViewController.h"

@interface CWSMessageViewController ()



@end


@implementation CWSMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self _showInputIdAlert];
}

#pragma mark - input id
- (void)_showInputIdAlert{
    QMUIAlertController *alertController = [QMUIAlertController alertControllerWithTitle:@"请输入" message:@"发送消息到目的id" preferredStyle:QMUIAlertControllerStyleAlert];
       
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
               self.title = input;
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




@end


