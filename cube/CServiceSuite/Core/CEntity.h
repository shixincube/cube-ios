//
//  CEntity.h
//  CServiceSuite
//
//  Created by Ashine on 2020/10/12.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJsonable.h"

NS_ASSUME_NONNULL_BEGIN

@interface CEntity : NSObject <CJsonable>

/// 实体 ID
@property (nonatomic , assign) NSUInteger entityId;

/// 实体创建时的时间戳
@property (nonatomic , assign) long timestamp;

/// 实体的有效期
@property (nonatomic , assign) long expiry;

/// 关联的上下文信息
@property (nonatomic , strong) NSDictionary *context;

/// 模块名称
@property (nonatomic , copy) NSString *moduleName;

/// 实体名称
@property (nonatomic , copy) NSString *entityName;



- (instancetype)initWithLifeSpan:(NSTimeInterval )lifeSpan;

- (BOOL)overdue;

- (BOOL)update:(id)item data:(id)data;


@end

NS_ASSUME_NONNULL_END
