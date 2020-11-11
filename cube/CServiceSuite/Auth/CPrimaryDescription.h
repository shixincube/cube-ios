//
//  CPrimaryDescription.h
//  CServiceSuite
//
//  Created by Ashine on 2020/10/10.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJsonable.h"

NS_ASSUME_NONNULL_BEGIN

@interface CPrimaryDescription : NSObject 

@property (nonatomic , copy) NSString *address;

@property (nonatomic , strong) NSDictionary *primaryContent;

- (instancetype)initWithAddress:(NSString *)address primaryContent:(NSDictionary *)primaryContent;

- (instancetype)initWithJson:(NSDictionary *)json;

- (NSDictionary *)toJson;

@end

NS_ASSUME_NONNULL_END
