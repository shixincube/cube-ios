//
//  CMessageService.h
//  CServiceSuite
//
//  Created by Ashine on 2020/9/2.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CModule.h"
#import "CContact.h"
#import "CMessage.h"


@interface CMessageService : CModule

@property (nonatomic , class , readonly) NSString *mName;

- (void)sendToContact:(CContact *)contact message:(CMessage *)message;

//- (void)sendToGroup

@end

