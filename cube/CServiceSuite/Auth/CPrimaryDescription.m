//
//  CPrimaryDescription.m
//  CServiceSuite
//
//  Created by Ashine on 2020/10/10.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CPrimaryDescription.h"

@implementation CPrimaryDescription

-(instancetype)initWithAddress:(NSString *)address primaryContent:(NSDictionary *)primaryContent{
    if (self = [super init]) {
        self.address = address;
        self.primaryContent = primaryContent;
    }
    return self;
}

-(instancetype)initWithJson:(NSDictionary *)json{
    if (self = [super init]) {
        self.address = json[@"address"];
        self.primaryContent = json[@"primaryContent"];
    }
    return self;
}


-(NSDictionary *)toJson{
    return @{
        @"address":self.address,
        @"primaryContent":self.primaryContent,
    };
}




@end
