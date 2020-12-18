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

#import "CContactService.h"
#import "CConferenceService.h"

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
        
        
        
//        CContactService *contact = (CContactService *)[self getModule:CContactService.mName];
//        CAuthService *auth = (CAuthService *)[self getModule:CAuthService.mName];
//        CContact *me = [[CContact alloc] initWithId:1234567 domain:auth.token.domain];
//        me.name = @"wowowo1";
//        CDevice *device = [[CDevice alloc] initWithName:@"iOS" platform:@"ipod gold"];
//        [me addDevice:device];
//        [contact setCurrentContact:me];
        
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
//    [self.kernel installPipeline:[CCellPipeline new]]; // already install in kernel.
}

- (void)initializeModules{
    [self.kernel installModule:[CMessageService new]];
    [self.kernel installModule:[CContactService new]];
}

#pragma mark - Public
- (id)getModule:(NSString *)moduleName{
    NSAssert(moduleName, @"can't get module with nil name.");
    return [self.kernel getModule:moduleName];
}

-(CContactService *)contactService{
    return (CContactService *)[self.kernel getModule:CContactService.mName];
}

-(CMessageService *)messageService{
    return (CMessageService *)[self.kernel getModule:CMessageService.mName];
}

-(CAuthService *)authService{
    return (CAuthService *)[self.kernel getModule:CAuthService.mName];
}


-(CConferenceService *)confereneceService{
    return (CConferenceService *)[self.kernel getModule:CConferenceService.mName];
}





@end
