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
