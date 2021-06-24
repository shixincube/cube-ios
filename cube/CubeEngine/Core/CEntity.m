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
