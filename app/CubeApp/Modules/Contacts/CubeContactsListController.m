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

#import "CubeContactsListController.h"
#import "CubeContactsItemModel.h"
#import "CubeContactsItemCell.h"

@interface CubeContactsListController ()

@property (nonatomic, strong) NSArray * sectionHeaders;

@end

@implementation CubeContactsListController

- (instancetype)initWithHostView:(__kindof UIScrollView *)hostView pushAction:(void (^)(__kindof UIViewController *))pushAction {
    if (self = [super initWithHostView:hostView]) {
        self.pushAction = pushAction;
    }
    return self;
}

- (void)resetListWithContactsData:(NSArray *)contactsData sectionHeaders:(NSArray *)sectionHeaders {
    self.sectionHeaders = sectionHeaders;

    @weakify(self);
    self.clear();

    // 功能段
    self.addSection(CubeContactsSectionTypeFuncation);
    CubeContactsItemModel * newContactModel = [CubeContactsItemModel modelWithTag:CubeContactsCellTypeNew imageName:@"ContactsNewContact" imageURL:nil title:@"新的朋友" subTitle:nil customData:nil];
    CubeContactsItemModel * groupModel = [CubeContactsItemModel modelWithTag:CubeContactsCellTypeNew imageName:@"ContactsGroup" imageURL:nil title:@"群组" subTitle:nil customData:nil];
    CubeContactsItemModel * tagModel = [CubeContactsItemModel modelWithTag:CubeContactsCellTypeNew imageName:@"ContactsTag" imageURL:nil title:@"标签" subTitle:nil customData:nil];
    NSArray * funcationData = @[newContactModel, groupModel, tagModel];
    self.addCells([CubeContactsItemCell class])
        .toSection(CubeContactsSectionTypeFuncation)
        .withDataModelArray(funcationData)
        .selectedAction(^ (CubeContactsItemModel * model) {
        @strongify(self);
        if (model.tag == CubeContactsCellTypeNew) {
            
        }
        else if (model.tag == CubeContactsCellTypeGroup) {
            
        }
        else if (model.tag == CubeContactsCellTypeTag) {
            
        }
    });
}

#pragma mark - Delegate

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionHeaders;
}

@end
