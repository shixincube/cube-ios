/**
* This file is part of Cube.
*
* The MIT License (MIT)
*
* Copyright (c) 2020 Shixin Cube Team.
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/


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
