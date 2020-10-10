//
//  CMessageService.m
//  CServiceSuite
//
//  Created by Ashine on 2020/9/2.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CMessageService.h"

static NSString *_name = @"message";

@implementation CMessageService

+(NSString *)mName{
    return _name;
}

-(instancetype)init{
    if (self = [super initWithName:_name]) {
        
    }
    return self;
}



@end
