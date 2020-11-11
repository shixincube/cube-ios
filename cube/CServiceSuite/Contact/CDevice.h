//
//  CDevice.h
//  CServiceSuite
//
//  Created by Ashine on 2020/10/12.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJsonable.h"

NS_ASSUME_NONNULL_BEGIN

@interface CDevice : NSObject <CJsonable>

@property (nonatomic , copy) NSString *name;

@property (nonatomic , copy) NSString *platform;

-(instancetype)initWithName:(NSString *)name platform:(NSString *)platform;


@end

NS_ASSUME_NONNULL_END
