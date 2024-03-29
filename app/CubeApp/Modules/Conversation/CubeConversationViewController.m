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

#import "CubeConversationViewController.h"
#import "CubeConversationListController.h"
#import "CubeSearchController.h"
#import "CubeMessageViewController+Conversation.h"
#import "CubeConversation.h"
#import "CubeConversationCell.h"
#import "CubeConversationNoNetCell.h"
#import "CubeMessageViewController.h"
#import "UIFont+Cube.h"

@interface CubeConversationViewController ()

@property (nonatomic, weak) CubeConversation * lastConversation;

@property (nonatomic, weak) CubeConversationCell * lastConversationCell;

@property (nonatomic, strong) UITableView * tableView;

/*! 列表数据控制器。 */
@property (nonatomic, strong) CubeConversationListController * listController;

@property (nonatomic, strong) CubeSearchController * searchController;

@property (nonatomic, weak) CContactService * contactService;

@property (nonatomic, weak) CMessagingService * messagingService;

@end


@implementation CubeConversationViewController

- (instancetype)init {
    if (self = [super init]) {
        [self configTabBarItem:@"消息" image:@"TabBarConversation" imageHL:@"TabBarConversationHL"];
        self.conversations = [[NSMutableArray alloc] init];
    }

    return self;
}

- (void)dealloc {
    [self.conversations removeAllObjects];
    self.conversations = nil;
}

- (void)loadView {
    [super loadView];
    [self setNavTitleWithStatusString:nil];

    self.navigationController.navigationBar.tintColor = [UIColor colorTextBlack];
    self.navigationItem.backButtonTitle = @"";

    // 构建界面
    [self buildView];

    // 初始数据模型
    [self initModel];

    [CEngine sharedInstance].pipelineStateDelegate = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (![[CEngine sharedInstance] isReadyForPipeline]) {
            [self pipelineFaultOccurred:nil kernel:[CEngine sharedInstance].kernel];
        }
    });
}

- (void)viewDidLoad {
    [super viewDidLoad];

    // 事件代理
    self.messagingService.recentEventDelegate = self;

    // 加载数据
    [self loadData];

    [self monitorNetwork];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (nil != self.lastConversationCell) {
        if (nil != self.lastConversation) {
            [self.lastConversationCell setConversation:self.lastConversation];
        }
        [self.lastConversationCell updateRead];
    }
}

#pragma mark - Private

- (void)setNavTitleWithStatusString:(NSString *)statusString {
    NSString * title = (nil != statusString) ? [NSString stringWithFormat:@"消息(%@)", statusString] : @"消息";
    [self.navigationItem setNormalTitle:title];
}

- (void)buildView {
    // 列表
    self.tableView = self.view.addTableView(1)
        .backgroundColor([UIColor whiteColor])
        .tableFooterView([[UIView alloc] init])
        .separatorStyle(UITableViewCellSeparatorStyleNone)
        .masonry(^ (__kindof UIView *senderView, MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        })
        .view;

#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_14_5
    if (@available(iOS 15.0, *)) {
        self.tableView.sectionHeaderTopPadding = 0;
    }
#endif
}

- (void)initModel {
    @weakify(self);
    self.listController = [[CubeConversationListController alloc] initWithHostView:self.tableView badgeStatusChangeAction:^(NSString *badge) {
        @strongify(self);
        [self.tabBarItem setBadgeValue:badge];
    }];

    // 网络状态提醒
    self.listController.addSection(CubeConversationSectionTagAlert);

    // 置顶文章
    self.listController.addSection(CubeConversationSectionTagTopArticle);
    
    // 播放内容
    self.listController.addSection(CubeConversationSectionTagPlay);
    
    // 置顶会话
    self.listController.addSection(CubeConversationSectionTagTopConversation);
    
    // 一般会话
    self.listController.addSection(CubeConversationSectionTagConversation);

    [self.tableView reloadData];
}

- (void)loadData {
    // 从引擎获取最近消息列表
    NSArray * list = [self.messagingService getRecentConversations];
    if (list && list.count > 0) {
        [self.conversations removeAllObjects];

        for (CConversation * conv in list) {
            // 创建 Cube Conversation
            CubeConversation * conversation = [CubeConversation conversationWithConversation:conv];
            [self.conversations addObject:conversation];
        }

        [self updateConvsationModuleWithData:self.conversations];
    }
}

- (void)monitorNetwork {
    [[CNetworkStatusManager sharedInstance] startMonitoring];
    [[CNetworkStatusManager sharedInstance] addDelegate:self];
}

- (void)updateConvsationModuleWithData:(NSArray *)data {
    // 更新会话的 Cell 和 Table View
    @weakify(self);
    self.listController.sectionForTag(CubeConversationSectionTagConversation).clear();

    self.listController.addCells([CubeConversationCell class])
        .toSection(CubeConversationSectionTagConversation)
        .withDataModelArray(data)
        .selectedAction(^ (CubeConversation * conversation) {
            @strongify(self);
            self.lastConversation = conversation;

            NSIndexPath * indexPath = [self.tableView indexPathForSelectedRow];
            self.lastConversationCell = [self.tableView cellForRowAtIndexPath:indexPath];

            [conversation clearUnread];
            [self.listController reloadBadge];

            CubeMessageViewController * messageVC = [[CubeMessageViewController alloc] initWithModel:conversation];
            PushVC(messageVC);
        });

    [self.tableView reloadData];
}

/* FIXME 不需要的方法
 * @brief 找到消息对应的 Conversation ，如果没有找到返回 @c nil 值。
 */
//- (CubeConversation *)findConversation:(CMessage *)message {
//    UInt64 identity = message.source;
//    if (identity == 0) {
//        if (message.selfTyper) {
//            identity = message.to;
//        }
//        else {
//            identity = message.from;
//        }
//    }
//
//    for (CubeConversation * conversation in self.conversations) {
//        if (conversation.identity == identity) {
//            return conversation;
//        }
//    }
//
//    return nil;
//}

- (CubeConversation *)removeConversation:(CConversation *)conversation {
    for (CubeConversation * cc in self.conversations) {
        if (cc.conversation.identity == conversation.identity) {
            [self.conversations removeObject:cc];
            return cc;
        }
    }
    return nil;
}

#pragma mark - Getters

- (CubeSearchController *)searchController {
    if (!_searchController) {
        
    }

    return _searchController;
}

- (CContactService *)contactService {
    if (!_contactService) {
        _contactService = [CEngine sharedInstance].contactService;
    }
    return _contactService;
}

- (CMessagingService *)messagingService {
    if (!_messagingService) {
        _messagingService = [CEngine sharedInstance].messagingService;
    }
    return _messagingService;
}

#pragma mark - Delegate

- (void)conversationUpdated:(CConversation *)conversation service:(CMessagingService *)service {
    CubeConversation * cc = [self removeConversation:conversation];
    if (nil != cc) {
        // 更新之后重新插入
        [cc reset:conversation];
        [self.conversations insertObject:cc atIndex:0];
    }
    else {
        // 没有该会话，创建新会话插入
        cc = [CubeConversation conversationWithConversation:conversation];
        [self.conversations insertObject:cc atIndex:0];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateConvsationModuleWithData:self.conversations];
    });
}

- (void)conversationListUpdated:(NSArray<__kindof CConversation *> *)conversationList service:(CMessagingService *)service {
    [self.conversations removeAllObjects];

    for (CConversation * conv in conversationList) {
        CubeConversation * cc = [CubeConversation conversationWithConversation:conv];
        [self.conversations addObject:cc];
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateConvsationModuleWithData:self.conversations];
    });
}

#pragma mark - Network Status Changed

- (void)networkStatusChanged:(CNetworkStatus)status {
    self.listController.sectionForTag(CubeConversationSectionTagAlert).clear();
    if (status == CNetworkStatusNone) {
        [self setNavTitleWithStatusString:@"未连接"];
        self.listController.addCell([CubeConversationNoNetCell class])
            .toSection(CubeConversationSectionTagAlert)
            .viewTag(CubeConversationCellTagNoNetwork);
    }
    else {
        [self setNavTitleWithStatusString:nil];
    }

    [self.tableView reloadData];
}

- (void)pipelineOpened:(CKernel *)kernel {
    NSLog(@"CubeConversationViewController#pipelineOpened");
    [self setNavTitleWithStatusString:nil];
}

- (void)pipelineClosed:(CKernel *)kernel {
    NSLog(@"CubeConversationViewController#pipelineClosed");
    [self setNavTitleWithStatusString:@"未连接"];
}

- (void)pipelineFaultOccurred:(CError *)error kernel:(CKernel *)kernel {
    [self.navigationItem setLoadingTitle:@"连接中"];
}

@end
