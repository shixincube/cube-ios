//
//  CModule.m
//  CServiceSuite
//
//  Created by Ashine on 2020/9/1.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CModule.h"
#import "CKernel.h"


@interface CModule ()
{
    NSArray *_dependModules;
}

@property (nonatomic , strong) NSMutableArray *depModules;

@end

@implementation CModule

@synthesize dependModules = _dependModules;


-(instancetype)initWithName:(NSString *)name{
    if (self = [super init]) {
        NSAssert(name, @"can't init module with nil name.");
        _name = name;
    }
    return self;
}

-(void)start{
    
}

-(void)stop{
    
}

-(void)suspend{
    
}

-(void)resume{
    
}


#pragma mark - getter
-(NSArray<NSString *> *)dependModules{
    return [_depModules copy];
}

-(NSMutableArray *)depModules{
    if (!_depModules) {
        _depModules = [NSMutableArray array];
    }
    return _depModules;
}

-(void)requireModules:(NSArray<NSString *> *)modules{
    [self.depModules addObjectsFromArray:modules];
}




@end
