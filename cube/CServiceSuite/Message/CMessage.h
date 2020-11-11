//
//  CMessage.h
//  CServiceSuite
//
//  Created by Ashine on 2020/10/15.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CEntity.h"
#import "CJsonable.h"
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CMessage : CEntity <CJsonable>

@property (nonatomic , strong) NSDictionary *payload;

@property (nonatomic , assign) int64_t messageId;

@property (nonatomic , strong) NSString *domain;

@property (nonatomic , assign) long from;

@property (nonatomic , assign) long to;

@property (nonatomic , assign) long source;

@property (nonatomic , assign) long localTS;

@property (nonatomic , assign) long remoteTS;

@property (nonatomic , assign) int64_t state;

- (instancetype)initWithPayload:(NSDictionary *)payload;

- (void)clone:(CMessage *)src;


@end

NS_ASSUME_NONNULL_END
