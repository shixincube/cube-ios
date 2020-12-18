//
//  CEngine.h
//  CServiceSuite
//
//  Created by Ashine on 2020/9/1.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

// TODO: condition
//#import "CMessageService.h"

@class CContactService;
@class CMessageService;
@class CAuthService;
@class CConferenceService;

#import "CKernel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CEngine : NSObject

+ (instancetype)shareEngine;

- (void)startWithConfig:(CKernelConfig *)config;


- (CContactService *)contactService;
- (CMessageService *)messageService;
- (CAuthService *)authService;
- (CConferenceService *)confereneceService;

@end

NS_ASSUME_NONNULL_END
