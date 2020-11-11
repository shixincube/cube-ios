//
//  CToken.h
//  CServiceSuite
//
//  Created by Ashine on 2020/10/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPrimaryDescription.h"
#import "CJsonable.h"

NS_ASSUME_NONNULL_BEGIN

@interface CAuthToken : NSObject <CJsonable>

@property (nonatomic , copy) NSString *code;

@property (nonatomic , copy) NSString *domain;

@property (nonatomic , copy) NSString *appKey;

@property (nonatomic , assign) NSUInteger cid;

@property (nonatomic , assign) NSUInteger issues;

@property (nonatomic , assign) NSUInteger expiry;

@property (nonatomic , assign) BOOL isValid;

@property (nonatomic , strong) CPrimaryDescription *pDescription;

// 使用dialect data初始化
- (instancetype)initWithJson:(NSDictionary *)json;

// 使用jons初始化 请使用 jsonable方式

@end

NS_ASSUME_NONNULL_END
