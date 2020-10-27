//
//  CToken.m
//  CServiceSuite
//
//  Created by Ashine on 2020/10/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CToken.h"

@implementation CToken


-(BOOL)isValid{
    return [[NSDate date] timeIntervalSince1970]  < self.expiry;
}

-(NSDictionary *)toJson{
    return @{
        @"code":self.code,
        @"domain":self.domain,
        @"appKey":self.appKey,
        @"cid":[NSNumber numberWithUnsignedInteger:self.cid],
        @"issues":[NSNumber numberWithUnsignedInteger:self.issues],
        @"expiry":[NSNumber numberWithUnsignedInteger:self.expiry],
        @"description":[self.pDescription toJson],
    };
}

-(instancetype)initWithJson:(NSDictionary *)json{
    if (self = [super init]) {
        self.code = json[@"code"];
        self.domain = json[@"domain"];
        self.appKey = json[@"appKey"];
        self.cid = [json[@"cid"] unsignedIntegerValue];
        self.issues = [json[@"issues"] unsignedIntegerValue];
        self.expiry = [json[@"expiry"] unsignedIntegerValue];
        self.pDescription = [[CPrimaryDescription alloc] initWithJson:json[@"description"]];
    }
    return self;
}

@end
