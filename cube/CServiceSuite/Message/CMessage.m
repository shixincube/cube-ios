//
//  CMessage.m
//  CServiceSuite
//
//  Created by Ashine on 2020/10/15.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CMessage.h"
#import "CJsonableUtil.h"
#import <cell/cell.h>

@implementation CMessage

-(instancetype)initWithPayload:(NSDictionary *)payload{
    if (self = [super initWithLifeSpan:10 * 60 * 1000]) {
        self.messageId = [CellUtil generateUnsignedSerialNumber];
        self.entityId = 239948;
        self.domain = @"shixincube.com";
        self.payload = payload;
    }
    return self;
}

-(void)clone:(CMessage *)src{
    self.messageId = src.messageId;
    self.domain = src.domain;
    self.from = src.from;
    self.to = src.to;
    self.source = src.source;
    self.localTS = src.localTS;
    self.remoteTS = src.remoteTS;
    self.payload = src.payload;
    self.state = src.state;
}

#pragma mark - jsonable

-(NSDictionary *)toJson{
    return [CJsonableUtil translateObjectToJsonObject:self];
}

+(id)fromJson:(NSDictionary *)json{
    return [CJsonableUtil generateObjectOfClass:[self class] fromJsonObject:json];
}

+(NSDictionary *)keysMap{
    return @{
        @"messageId":@[@"id"],
        @"localTS":@[@"lts"],
        @"remoteTS":@[@"rts"],
    };
}





@end
