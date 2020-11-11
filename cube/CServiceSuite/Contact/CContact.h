//
//  CContact.h
//  CServiceSuite
//
//  Created by Ashine on 2020/10/12.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CEntity.h"
#import "CDevice.h"
#import "CJsonable.h"

NS_ASSUME_NONNULL_BEGIN

@interface CContact : CEntity <CJsonable>

@property (nonatomic , assign) long contactId;

@property (nonatomic , copy) NSString *domain;

@property (nonatomic , copy) NSString *name;

@property (nonatomic , strong) NSMutableArray <CDevice *> *devices;

-(instancetype)initWithId:(long)contactId domain:(NSString *)domain;

- (void)addDevice:(CDevice *)device;

- (void)removeDevice:(CDevice *)device;



@end

NS_ASSUME_NONNULL_END
