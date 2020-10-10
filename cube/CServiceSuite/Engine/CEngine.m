//
//  CEngine.m
//  CServiceSuite
//
//  Created by Ashine on 2020/9/1.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CEngine.h"

#import "CCellPipeline.h"

#import "CAuthService.h"

#import "CMessageService.h"




@interface CEngine ()

@property (nonatomic , strong) CKernel *kernel;

@end

static CEngine *engine = nil;

@implementation CEngine

+(instancetype)shareEngine{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        engine = [CEngine new];
        [engine initializePipeline];
        [engine initializeModules];
    });
    return engine;
}

#pragma mark - life circle


- (void)startWithConfig:(CKernelConfig *)config{
    [self.kernel startUp:config completion:^{
        
    } failure:^{
        
    }]; //TODO:  start with config
}


#pragma mark - getter

-(CKernel *)kernel{
    if (!_kernel) {
        _kernel = [CKernel shareKernel];
    }
    return _kernel;
}


#pragma mark - install

- (void)initializePipeline{
//    [self.kernel installPipeline:[CCellPipeline new]];
}

- (void)initializeModules{
//    [self.kernel installModule:[CMessageService new]];
}

#pragma mark - Public
- (id)getModule:(NSString *)moduleName{
    NSAssert(moduleName, @"can't get module with nil name.");
    return [self.kernel getModule:moduleName];
}

//- (id)getContactService{
//    return self.kernel getModule:c
//}

//- (id)getMessagingService{
//    return <#expression#>
//}

//- (CAuthService *)getAuthService{
//    return (CAuthService *)[self.kernel getModule:CAuthService.name];
//}





@end
