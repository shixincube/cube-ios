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

#import "CubeContactsHelper.h"
#import "CubeContactsCategory.h"
#import "CubeAccountHelper.h"
#import "CubeAccount.h"

#define DEFAULT_CONTACTS_ZONE @"contacts"

@interface CubeContactsHelper () {
    CContactZone * _contactsZone;
}

@end

@implementation CubeContactsHelper

+ (CubeContactsHelper *)sharedInstance {
    static CubeContactsHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[CubeContactsHelper alloc] init];
    });
    return helper;
}

- (instancetype)init {
    if (self = [super init]) {
        _groupedContactsData = [[NSMutableArray alloc] init];
        _sectionHeaders = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, nil];
    }
    return self;
}

- (void)resetContactsList {
    @weakify(self);
    [[CEngine sharedInstance].contactService getContactZone:DEFAULT_CONTACTS_ZONE handleSuccess:^(CContactZone * zone) {
        @strongify(self);
        self->_contactsZone = zone;
        [self processContacts];
    } handleFailure:^(CError * _Nullable error) {
        if (error.code == CContactServiceStateNotFindContactZone) {
            // 没有找到默认的联系人分区，创建新分区
            if (CUBE_APP_DEMO) {
                // 获取内置的演示数据
                [[CubeAccountHelper sharedInstance] getBuildinAccounts:^(NSArray<__kindof CubeAccount *> * accountList) {
                    NSMutableArray * contactIdList = [[NSMutableArray alloc] initWithCapacity:accountList.count];
                    for (CubeAccount * account in accountList) {
                        [contactIdList addObject:[NSNumber numberWithUnsignedInteger:account.identity]];
                    }

                    // 创建默认联系人分区
                    [[CEngine sharedInstance].contactService createContactZone:DEFAULT_CONTACTS_ZONE displayName:nil contactIdList:contactIdList handleSuccess:^(CContactZone *zone) {
                        self->_contactsZone = zone;
                        [self processContacts];
                    } handleFailure:^(CError * _Nullable error) {
                        NSLog(@"CubeContactsHelper#resetContactsList create contact zone error : %ld", error.code);
                    }];
                }];
            }
            else {
                NSArray * contactIdList = @[ [NSNumber numberWithUnsignedInteger:[CubeAccountHelper sharedInstance].currentAccount.identity] ];
                // 创建默认联系人分区
                [[CEngine sharedInstance].contactService createContactZone:DEFAULT_CONTACTS_ZONE displayName:nil contactIdList:contactIdList handleSuccess:^(CContactZone *zone) {
                    self->_contactsZone = zone;
                    [self processContacts];
                } handleFailure:^(CError * _Nullable error) {
                    NSLog(@"CubeContactsHelper#resetContactsList create contact zone error : %ld", error.code);
                }];
            }
        }
        else {
            NSLog(@"CubeContactsHelper#resetContactsList error : %ld", error.code);
        }
    }];

    // TODO 搜索标签 Zone
}

- (void)processContacts {
    NSArray * sortedArray = _contactsZone.orderedParticipants;

    // 分组
    NSMutableArray<__kindof CubeContactsCategory *> * contactsData = [[NSMutableArray alloc] init];
    NSMutableArray<__kindof NSString *> * sectionHeaders = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, nil];

    char lastChar = '1';
    CubeContactsCategory * currentCategory = nil;
    CubeContactsCategory * otherCategory = [[CubeContactsCategory alloc] init];
    otherCategory.tagName = @"#";
    otherCategory.tag = 27;
    for (CContactZoneParticipant * participant in sortedArray) {
        NSString * namePinyin = [participant.contact getPriorityName].pinyin;
        if (nil == namePinyin || namePinyin.length == 0) {
            [otherCategory addParticipant:participant];
            continue;
        }

        char c = toupper([namePinyin characterAtIndex:0]);
        if (!isalpha(c)) {
            // 不是字母，分到 # 组
            [otherCategory addParticipant:participant];
        }
        else if (c != lastChar) {
            // 切换组
            if (currentCategory && currentCategory.count > 0) {
                [contactsData addObject:currentCategory];
                [sectionHeaders addObject:currentCategory.tagName];
            }
            lastChar = c;
            currentCategory = [[CubeContactsCategory alloc] initWithTagNameCharacter:c];
            [currentCategory addParticipant:participant];
        }
        else {
            [currentCategory addParticipant:participant];
        }
    }
    
    if (currentCategory && currentCategory.count > 0) {
        [contactsData addObject:currentCategory];
        [sectionHeaders addObject:currentCategory.tagName];
    }

    if (otherCategory.count > 0) {
        [contactsData addObject:otherCategory];
        [sectionHeaders addObject:otherCategory.tagName];
    }
    
    [self.groupedContactsData removeAllObjects];
    [self.groupedContactsData addObjectsFromArray:contactsData];
    [self.sectionHeaders removeAllObjects];
    [self.sectionHeaders addObjectsFromArray:sectionHeaders];
    
    if (self.dataChangedBlock) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataChangedBlock(self.groupedContactsData, self.sectionHeaders, self.contactsCount);
        });
    }
}

- (void)processTagZone {
    // 从服务器查询所有标签分区
}

#pragma mark - Getters

- (NSUInteger)contactsCount {
    return (_contactsZone) ? _contactsZone.count : 0;
}

@end
