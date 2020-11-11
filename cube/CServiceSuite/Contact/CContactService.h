//
//  CContactService.h
//  CServiceSuite
//
//  Created by Ashine on 2020/10/12.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <CServiceSuite/CServiceSuite.h>
#import "CContact.h"

NS_ASSUME_NONNULL_BEGIN

@interface CContactService : CModule

@property (nonatomic ,class , readonly) NSString *mName;

///  当前有效的在线联系人
@property (nonatomic , strong) CContact *currentContact;

@property (nonatomic , strong) NSMutableDictionary *contacts;

@property (nonatomic , strong) NSMutableDictionary *groups;


- (void)signIn:(CContact *)contact;

- (void)signOut;

@end

NS_ASSUME_NONNULL_END
