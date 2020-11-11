//
//  CDevice.m
//  CServiceSuite
//
//  Created by Ashine on 2020/10/12.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CDevice.h"
#import "CJsonableUtil.h"


@implementation CDevice

-(instancetype)initWithName:(NSString *)name platform:(NSString *)platform{
    if (self = [super init]) {
        self.name = name;
        self.platform = platform;
    }
    return self;
}

-(BOOL)isEqual:(id)object{
    if ([object isKindOfClass:[CDevice class]] && [((CDevice *)object).name isEqual:self.name] && [((CDevice *)object).platform isEqual:self.platform]) {
        return YES;
    }
    return NO;
}


#pragma mark - jsonable

-(NSDictionary *)toJson{
    return [CJsonableUtil translateObjectToJsonObject:self];
}

+(id)fromJson:(NSDictionary *)json{
    return [CJsonableUtil generateObjectOfClass:[self class] fromJsonObject:json];
}

@end
