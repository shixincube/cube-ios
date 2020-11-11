//
//  CKernel.m
//  CServiceSuite
//
//  Created by Ashine on 2020/9/1.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CKernel.h"
#import "CAuthService.h"


@implementation CKernelConfig

@end

@interface CKernel ()

@property (nonatomic , strong) NSMutableDictionary <NSString *, CPipeline *> *pipelines;

@property (nonatomic , strong) NSMutableDictionary <NSString *,CModule *> *modules;

//@property (nonatomic , <#strong#>) <#type#> *<#name#>

@end


static CKernel *kernel = nil;

@implementation CKernel

+(instancetype)shareKernel{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kernel = [CKernel new];
        [kernel initializeData];
        [kernel installDefaultModulesAndPipeline];
    });
    return kernel;
}


#pragma mark - initialize

- (void)initializeData{
    self.pipelines = [NSMutableDictionary dictionary];
    self.modules = [NSMutableDictionary dictionary];
}

- (void)installDefaultModulesAndPipeline{
    [self installModule:[CAuthService new]];
    [self installPipeline:[CCellPipeline new]];
}

#pragma mark - invoke

-(void)startUp:(CKernelConfig *)config completion:(void (^)(void))completion failure:(void (^)(void))failure{
    
    // set log level according to config.
    
    // bundle default.
    [self bundleDefault];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        [self checkAuth:config completion:^(CAuthToken *token) {
            if (!token || !token.isValid) { // failure.
                if (failure) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        failure();
                    });
                }
            }
            else{
                // success.
                if (completion) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        completion();
                    });
                }
            }
        }];
    });
}

-(void)shutdown{
    
}

-(void)suspend{
    
}

-(void)resume{
    
}

#pragma mark - auth
- (void)checkAuth:(CKernelConfig *)config completion:(void(^)(CAuthToken *token))completion{
    NSAssert(config, @"kernel can't check auth with nil config.");
    CAuthService *auth = (CAuthService *)[self getModule:CAuthService.mName];
    
    // defense code.
    if (!auth) {
        NSLog(@"Kernel can't find auth module.");
        return;
    }
    
    if (!config.domain || !config.appKey) {
        NSLog(@"Kernel config error with nil domain or nil appkey.");
        return;
    }
    
    
    [auth check:config.domain appKey:config.appKey address:config.address completion:^(CAuthToken * _Nonnull token) {
        if (!token) {
            NSLog(@"Kernel Auth token is invalid");
        }
        if (completion) {
            completion(token);
        }
    }];
}

// async use
- (CAuthToken *)checkAuth:(CKernelConfig *)config{
    NSAssert(config, @"kernel can't check auth with nil config.");
    CAuthService *auth = (CAuthService *)[self getModule:CAuthService.mName];
    
    // defense code.
    if (!auth) {
        NSLog(@"Kernel can't find auth module.");
        return nil;
    }
    
    if (!config.domain || !config.appKey) {
        NSLog(@"Kernel config error with nil domain or nil appkey.");
        return nil;
    }
    
    __block CAuthToken *t = nil;
    AnyPromise *checkPromise = [AnyPromise promiseWithAdapterBlock:^(PMKAdapter  _Nonnull adapter) {
        [auth check:config.domain appKey:config.appKey address:config.address completion:^(CAuthToken * _Nonnull token) {
              if (!token) {
                  NSLog(@"Kernel Auth token is invalid");
              }
            adapter(token,nil);
          }];
    }];
    checkPromise.then(^(CAuthToken *token){
        t = token;
    });
    PMKHang(checkPromise);
    return t;
}



#pragma mark - configure

- (void)bundleDefault{
    // default all modules's pipeline is cellpipe.
    CPipeline *cell = [self getPipeline:CCellPipeline.pName];
    for (CModule *module in self.modules.allValues) {
        module.pipeline = cell;
    }
}

- (void)configModules:(CKernelConfig *)config token:(CAuthToken *)token{
    NSAssert(token, @"can't config modules with nil token.");
    for (CPipeline *pipeline in self.pipelines.allValues) {
        [pipeline setRemoteAddress:token.pDescription.address port:7070];
        pipeline.tokenCode = token.code;
    }
}

// TODO: keep thread safe with mutex lock

-(void)installPipeline:(CPipeline *)pipeline{
    NSAssert(pipeline, @"can't install nil pipeline.");
    NSAssert(pipeline.name, @"can't install pipeline with nil name.");
    if (![self getPipeline:pipeline.name]) {
        [self.pipelines setObject:pipeline forKey:pipeline.name];
    }
}

-(void)installModule:(CModule *)module{
    NSAssert(module, @"can't install nil module.");
    NSAssert(module.name, @"can't install module with nil name.");
    if (![self getModule:module.name]) {
        [self.modules setObject:module forKey:module.name];
    }
}

-(void)uninstallPipeline:(CPipeline *)pipeline{
    NSAssert(pipeline, @"can't uninstall nil pipeline.");
    NSAssert(pipeline.name, @"can't uninstall pipeline with nil name.");
    if ([self getPipeline:pipeline.name]) {
        [self.pipelines removeObjectForKey:pipeline.name];
    }
}

-(void)uninstallModule:(CModule *)module{
    NSAssert(module, @"can't uninstall nil module.");
    NSAssert(module.name, @"can't uninstall module with nil name.");
    if ([self getModule:module.name]) {
        [self.modules removeObjectForKey:module.name];
    }
}

#pragma mark - get

-(CPipeline *)getPipeline:(NSString *)pipelineName{
    NSAssert(pipelineName, @"can't get pipeline with nil name.");
    for (CPipeline *pipeline in self.pipelines.allValues) {
        if ([pipeline.name isEqualToString:pipelineName]) {
            return pipeline;
        }
    }
    return nil;
}

-(CModule *)getModule:(NSString *)moduleName{
    NSAssert(moduleName, @"can't get module with nil name.");
    for (CModule *module in self.modules.allValues) {
        if ([module.name isEqualToString:moduleName]) {
            return module;
        }
    }
    return nil;
}





@end
