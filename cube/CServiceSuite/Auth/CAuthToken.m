//
//  CToken.m
//  CServiceSuite
//
//  Created by Ashine on 2020/10/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CAuthToken.h"
#import "CJsonableUtil.h"



@implementation CAuthToken

-(instancetype)initWithJson:(NSDictionary *)json{
    if (self = [super init]) {
        NSDictionary *jsonData = json[@"data"];
        self.code = jsonData[@"code"];
        self.domain = jsonData[@"domain"];
        self.appKey = jsonData[@"appKey"];
        self.cid = [jsonData[@"cid"] unsignedIntegerValue];
        self.issues = [jsonData[@"issues"] unsignedIntegerValue];
        self.expiry = [jsonData[@"expiry"] unsignedIntegerValue];
        self.pDescription = [[CPrimaryDescription alloc] initWithJson:jsonData[@"description"]];
    }
    return self;
}


-(BOOL)isValid{
    return [[NSDate date] timeIntervalSince1970]  < self.expiry;
}

#pragma mark - jsonable

-(NSDictionary *)toJson{
    return [CJsonableUtil translateObjectToJsonObject:self];
}

+(id)fromJson:(NSDictionary *)json{
    return [CJsonableUtil generateObjectOfClass:[self class] fromJsonObject:json];
}
+(NSDictionary *)keysMap{
    return @{@"pDescription":@[@"description"]};
}

- (void)setValue:(id)value forProperty:(NSString *)property{
    if ([property isEqualToString:@"pDescription"]) {
        self.pDescription = [[CPrimaryDescription alloc] initWithJson:value];
    }
    else{
        [super setValue:value forKey:property];
    }
}

-(id)valueForProperty:(NSString *)property{
    if ([property isEqualToString:@"pDescription"]) {
        return [self.pDescription toJson];
    }
    return [super valueForKey:property];
}







@end
