//
//  CContact.m
//  CServiceSuite
//
//  Created by Ashine on 2020/10/12.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CContact.h"
#import "CJsonableUtil.h"

@implementation CContact

-(instancetype)initWithId:(long)contactId domain:(nonnull NSString *)domain{
    if (self = [super initWithLifeSpan:10 * 60 * 1000]) {
        self.contactId = contactId;
        self.domain = domain;
        self.name = [NSString stringWithFormat:@"Cube%ld",self.contactId];
        self.devices = [NSMutableArray array];
    }
    return self;
}

-(void)addDevice:(CDevice *)device{
    if ([self.devices indexOfObject:device] == NSNotFound) {
        [self.devices addObject:device];
    }
}

- (void)removeDevice:(CDevice *)device{
    NSInteger index = [self.devices indexOfObject:device];
    if (index != NSNotFound) {
        [self.devices removeObjectAtIndex:index];
    }
}


#pragma mark - jsonable

-(NSDictionary *)toJson{
    return [CJsonableUtil translateObjectToJsonObject:self];
}

+(id)fromJson:(NSDictionary *)json{
    return [CJsonableUtil generateObjectOfClass:[self class]  fromJsonObject:json];
}

+(NSDictionary *)keysMap{
    return @{@"contactId":@[@"id"]};
}

-(void)setValue:(id)value forProperty:(NSString *)property{
    id newValue = value;
    if ([property isEqualToString:@"devices"]) {
        NSMutableArray *devices = [NSMutableArray array];
        for (NSDictionary *dev in self.devices) {
            CDevice *device = [CDevice fromJson:dev];
            [devices addObject:device];
        }
        newValue = devices;
    }
    [self setValue:newValue forKey:property];
}

-(id)valueForProperty:(NSString *)property{
    if ([property isEqualToString:@"devices"]) {
        NSMutableArray *ret = [NSMutableArray array];
        for (CDevice *device in self.devices) {
            NSDictionary *deviceJson = [device toJson];
            [ret addObject:deviceJson];
        }
        return ret;
    }
    return [self valueForKey:property];
}





@end
