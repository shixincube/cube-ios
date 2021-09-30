/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Shixin Cube Team.
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

#import "CubeConversationListController.h"
#import "CubeUIUtility.h"
#import "ZZFLEXAngel+Private.h"
#import "ZZFLEXSectionModel.h"
#import "CubeConversation.h"


@implementation CubeConversationListController

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView badgeStatusChangeAction:(void (^)(NSString *))badgeStatusChangeAction {
    if (self = [super initWithHostView:hostView]) {
        self.badgeStatusChangeAction = badgeStatusChangeAction;
    }
    
    return self;
}

- (void)reloadBadge {
    if (!self.badgeStatusChangeAction) {
        return;
    }

    
}

#pragma mark - Delegate

- (UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZZFLEXSectionModel * sectionModel = [self sectionModelAtIndex:indexPath.section];
    if (sectionModel.sectionTag == CubeConversationSectionTagConversation
        || sectionModel.sectionTag == CubeConversationSectionTagConversation) {
        @weakify(self);
        CubeConversation * conversation = self.dataModel.atIndexPath(indexPath);
        UIContextualAction * deleteAction = [UIContextualAction contextualActionWithStyle:UIContextualActionStyleDestructive title:@"删除" handler:^(UIContextualAction * action, __kindof UIView * sourceView, void (^ completionHandler)(BOOL)) {
            @strongify(self);
            [self tableView:tableView deleteItemAtIndexPath:indexPath];
            completionHandler(YES);
        }];
        // 背景色
        deleteAction.backgroundColor = [UIColor redColor];

        UISwipeActionsConfiguration * config = [UISwipeActionsConfiguration configurationWithActions:@[deleteAction]];
        return config;
    }
    
    return nil;
}

#pragma mark - Private

- (void)tableView:(UITableView *)tableView deleteItemAtIndexPath:(NSIndexPath *)indexPath {
    ZZFLEXSectionModel * sectionModel = [self sectionModelAtIndex:indexPath.section];
    ZZFLEXViewModel * viewModel = [sectionModel objectAtIndex:indexPath.row];
    CubeConversation * conversation = viewModel.dataModel;

    if (!conversation) {
        [CubeUIUtility showErrorHint:@"获取会话时发生错误"];
        return;
    }
    
    // TODO
}

@end
