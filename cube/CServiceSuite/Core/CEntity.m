//
//  CEntity.m
//  CServiceSuite
//
//  Created by Ashine on 2020/10/12.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CEntity.h"
#import "CKernel.h"
#import "CJsonableUtil.h"

@implementation CEntity

-(instancetype)initWithLifeSpan:(NSTimeInterval)lifeSpan{
    if (self = [super init]) {
        self.timestamp = [[NSDate date] timeIntervalSince1970] * 1000;
        self.expiry = self.timestamp + lifeSpan ? lifeSpan : 10 * 60 * 1000; //  if lifespan is null ,expire this entity after 10minus.
    }
    return self;
}

- (BOOL)overdue{
    return self.expiry > [[NSDate date] timeIntervalSince1970] * 1000;
}

-(BOOL)update:(id)item data:(id)data{
    
    NSAssert(self.moduleName, @"entity can't update item with nil module name.");
    NSAssert(self.entityName, @"entity can't update item with nil entity name.");
    NSAssert(self.entityId, @"entity can't update item with nil entityId.");
    NSAssert(item, @"entity can't update item with nil item.");
    
    CCellPipeline *cell = (CCellPipeline *)[[CKernel shareKernel] getPipeline:CCellPipeline.pName];
    NSAssert(cell, @"entity can't update item with nil cell pipeline.");
    
    CPacket *packet = [[CPacket alloc] initWithName:@"UpdateEntity" data:@{
        @"entity":self.entityName,
        @"id":[NSNumber numberWithUnsignedInteger:self.entityId],
        @"item":item,
        @"data":data
    } sn:0];
    
    [cell send:self.moduleName packet:packet response:nil];
    
    return YES;
}


#pragma mark - jsonable

-(NSDictionary *)toJson{
    return [CJsonableUtil translateObjectToJsonObject:self];
}

+(id)fromJson:(NSDictionary *)json{
    return [CJsonableUtil generateObjectOfClass:[self class] fromJsonObject:json];
}

+(NSDictionary *)keysMap{
    return @{@"entityId":@[@"id"]};
}





@end
