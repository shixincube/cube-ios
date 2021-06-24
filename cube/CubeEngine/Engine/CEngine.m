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
