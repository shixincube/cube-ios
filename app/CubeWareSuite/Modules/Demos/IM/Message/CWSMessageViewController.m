//
//  CWSMessageViewController.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CWSMessageViewController.h"

#define kwidth [UIScreen mainScreen].bounds.size.width
#define kheight [UIScreen mainScreen].bounds.size.height

static CGFloat const kToolbarHeight = 56;

@interface CWSMessage : NSObject

@property (nonatomic , copy) NSString *senderId;

@property (nonatomic , copy) NSString *content;

@end

@implementation CWSMessage


@end

@interface CWSMessageViewController ()<QMUITableViewDelegate,QMUITableViewDataSource,CObserver>

@property (nonatomic , strong) QMUITableView *messageView;


@property(nonatomic, strong) UIView *toolbarView;
@property (nonatomic , strong) QMUITextField *inputField;
@property (nonatomic , strong) QMUIButton *sendBtn;

@property (nonatomic , strong) NSMutableArray *messages;

@property (nonatomic , copy) NSString *peerContactId;

@end


@implementation CWSMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
-(void)initSubviews{
    [super initSubviews];
    
    [[CEngine shareEngine].messageService attach:self];
    
    [self.view addSubview:self.messageView];
    [self.view addSubview:self.toolbarView];
    
    __weak __typeof(self)weakSelf = self;
    self.inputField.qmui_keyboardWillChangeFrameNotificationBlock = ^(QMUIKeyboardUserInfo *keyboardUserInfo) {
        [QMUIKeyboardManager handleKeyboardNotificationWithUserInfo:keyboardUserInfo showBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
            [weakSelf showToolbarViewWithKeyboardUserInfo:keyboardUserInfo];
        } hideBlock:^(QMUIKeyboardUserInfo *keyboardUserInfo) {
            [weakSelf hideToolbarViewWithKeyboardUserInfo:keyboardUserInfo];
        }];
    };
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
               self.peerContactId = input;
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

- (void)showToolbarViewWithKeyboardUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo{
    if (keyboardUserInfo) {
        [QMUIKeyboardManager animateWithAnimated:YES keyboardUserInfo:keyboardUserInfo animations:^{
            CGRect keyboardRect = [QMUIKeyboardManager convertKeyboardRect:keyboardUserInfo.endFrame toView:self.view];
            CGFloat distanceFromBottom = CGRectGetHeight(CGRectFlatted(self.view.bounds)) - CGRectGetMinY(keyboardRect) - kToolbarHeight;
            self.toolbarView.layer.transform = CATransform3DMakeTranslation(0, - distanceFromBottom - kToolbarHeight, 0);
            self.messageView.frame = CGRectMake(0, 0, kwidth, self.messageView.bounds.size.height - distanceFromBottom -kToolbarHeight);
        } completion:NULL];
    }
}

- (void)hideToolbarViewWithKeyboardUserInfo:(QMUIKeyboardUserInfo *)keyboardUserInfo {
    [UIView animateWithDuration:0.25 delay:0 options:QMUIViewAnimationOptionsCurveOut animations:^{
        self.toolbarView.layer.transform = CATransform3DIdentity;
        self.messageView.frame = CGRectMake(0, 0, kwidth, kheight - kToolbarHeight);
    } completion:NULL];
}

- (BOOL)shouldHideKeyboardWhenTouchInView:(UIView *)view {
    if (view == self.toolbarView) {
        return NO;
    }
    return YES;
}

#pragma mark - tableview delegate & datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _messages.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.01f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *identifier = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = UIFontMake(16);
        cell.textLabel.textColor = TableViewCellTitleLabelColor;
        cell.qmui_separatorInsetsBlock = ^UIEdgeInsets(__kindof UITableView * _Nonnull tableView, __kindof UITableViewCell * _Nonnull aCell) {
//            QMUITableViewCellPosition position = aCell.qmui_cellPosition;
            
            CGFloat defaultRight = 20;
            
            CGRect frame = [aCell convertRect:aCell.textLabel.bounds fromView:aCell.textLabel];
            CGFloat left = CGRectGetMinX(frame);
            CGFloat right = aCell.qmui_accessoryView ? CGRectGetWidth(aCell.bounds) - CGRectGetMinX(aCell.qmui_accessoryView.frame) : defaultRight;
            return UIEdgeInsetsMake(0, left, 0, right);
        };
    }
    
    cell.accessoryType = UITableViewCellAccessoryNone;
    UIFont *font = [UIFont boldSystemFontOfSize:20];
    
    CWSMessage *message = self.messages[indexPath.section];
    
    NSAttributedString *attributeImg = [[NSAttributedString alloc] initWithString:message.senderId attributes:@{NSForegroundColorAttributeName:UIColorGray2,NSFontAttributeName:font}];
    cell.imageView.image = [UIImage qmui_imageWithAttributedString:attributeImg];
    
    NSString *text = message.content;
    cell.textLabel.text = text;
    
    return cell;
}

#pragma mark - btn selector

- (void)sendContent:(UIButton *)sender{
    NSString *content = self.inputField.text;
    
    if (content && ![content isEqualToString:@""]) {
        CWSMessage *message = [CWSMessage new];
        message.senderId = [NSString stringWithFormat:@"%ld",[CEngine shareEngine].contactService.currentContact.contactId];
        message.content = content;
        [self.messages addObject:message];
        self.inputField.text = @"";
        [self.messageView reloadData];
        
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:self.messages.count-1];
        [self.messageView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        [self sendMessage:content];
    }
}

#pragma mark - cube engine send msg

- (void)sendMessage:(NSString *)content{
    if (!content || [content isEqualToString:@""] || !self.peerContactId) {
        return;
    }
    
    CMessageService *messageService = (CMessageService *)[[CKernel shareKernel] getModule:CMessageService.mName];
    CMessage *message = [[CMessage alloc] initWithPayload:@{@"message":content}];
    CContact *contact = [[CContact alloc] initWithId:[self.peerContactId intValue] domain:@"shixincube.com"];
    [messageService sendToContact:contact message:message];
}

#pragma mark - CObserver delegate
-(void)update:(CObserverState *)state{
    NSLog(@"message view controller get update with state : %@",state.data);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        CWSMessage *message = [CWSMessage new];
        message.senderId = [NSString stringWithFormat:@"%d",[state.data[@"data"][@"from"] intValue]];
        message.content = state.data[@"data"][@"payload"][@"message"];
        [self.messages addObject:message];
        
        [self.messageView reloadData];
        NSIndexPath *indexpath = [NSIndexPath indexPathForRow:0 inSection:self.messages.count-1];
        [self.messageView scrollToRowAtIndexPath:indexpath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    });
}

#pragma mark - getter

-(QMUITableView *)messageView{
    if (!_messageView) {
        _messageView = [[QMUITableView alloc] initWithFrame:CGRectMake(0, 0, kwidth, kheight - kToolbarHeight) style:UITableViewStyleInsetGrouped];
        _messageView.dataSource = self;
        _messageView.delegate = self;
    }
    return _messageView;
}

- (QMUITextField *)inputField{
    if (!_inputField) {
        
        CGFloat textFieldInset = 8;
        CGFloat textFieldHeight = kToolbarHeight - textFieldInset * 2;
        CGFloat textFieldWidth = CGRectGetMinX(self.sendBtn.frame) - textFieldInset * 2;
        
        _inputField = [[QMUITextField alloc] initWithFrame:CGRectFlatMake(textFieldInset, textFieldInset, textFieldWidth, textFieldHeight)];
        _inputField.placeholder = @"请输入消息";
        _inputField.font = UIFontMake(15);
        _inputField.backgroundColor = nil;
    }
    return _inputField;
}

-(QMUIButton *)sendBtn{
    if (!_sendBtn) {
        _sendBtn = [[QMUIButton alloc] init];
        _sendBtn.titleLabel.font = UIFontMake(16);
        [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        _sendBtn.frame = CGRectMake(kwidth-100, 0, 100, kToolbarHeight);
        _sendBtn.backgroundColor = UIColorGray3;
        [_sendBtn addTarget:self action:@selector(sendContent:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}

-(UIView *)toolbarView{
    if (!_toolbarView) {
        _toolbarView = [[UIView alloc] init];
        _toolbarView.backgroundColor = UIColorForBackground;
        _toolbarView.qmui_borderColor = UIColorSeparator;
        _toolbarView.qmui_borderPosition = QMUIViewBorderPositionTop;
        _toolbarView.qmui_frameApplyTransform = CGRectFlatMake(0, CGRectGetHeight(self.view.bounds) - kToolbarHeight, CGRectGetWidth(self.view.bounds), kToolbarHeight);
        [_toolbarView addSubview:self.inputField];
        [_toolbarView addSubview:self.sendBtn];
    }
    return _toolbarView;
}

-(NSMutableArray *)messages{
    if (!_messages) {
        _messages = [NSMutableArray array];
    }
    return _messages;
}





@end


