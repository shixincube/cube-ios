//
//  CPacket.h
//  CServiceSuite
//
//  Created by Ashine on 2020/9/1.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPacket : NSObject


@property (nonatomic , copy) NSString *name;

@property (nonatomic , strong) NSDictionary *data;

@property (nonatomic , assign) int64_t sn;

@property (nonatomic , strong) NSDictionary *state; // 状态信息

- (instancetype)initWithName:(NSString *)name data:(NSDictionary *)data sn:(long)sn;

- (int)getStateCode; //从状态信息获取状态码


@end

NS_ASSUME_NONNULL_END
