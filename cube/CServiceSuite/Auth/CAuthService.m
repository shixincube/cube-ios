//
//  CAuthService.m
//  CServiceSuite
//
//  Created by Ashine on 2020/10/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CAuthService.h"

#define cachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

static NSString *_name = @"Auth";

@interface CAuthService ()

@property (nonatomic , copy) NSString *domain;

@property (nonatomic , copy) NSString *appKey;



@end

@implementation CAuthService

+(NSString *)mName{
    return _name;
}


-(instancetype)init{
    if (self = [super initWithName:CAuthService.mName]) {
    }
    return self;
}

-(void)start{
    [super start];
    [self.pipeline addListener:CAuthService.mName listener:self.pipeListener];
}

-(void)stop{
    [super stop];
    [self.pipeline removeListener:CAuthService.mName listener:self.pipeListener];
}


-(void)check:(NSString *)domain appKey:(NSString *)appKey address:(NSString *)address completion:(nonnull void (^)(CAuthToken * _Nonnull))completion{
    
    self.domain = domain;
    self.appKey = appKey;

    // TODO: get local token.
    CAuthToken *token = [self getTokenFromDiskCache];
    
    // pipeline open
    [self.pipeline open];
    
    // TODO: parse token to get expire date.
    
    if (token && token.isValid) {
        self.token = token;

        BOOL jmp = YES;
        while (jmp) {
            if (self.pipeline.isReady) {
                
                [self checkToken:^{

                } failure:^{

                }];
                
                if (completion) {
                    completion(token);
                }
                jmp = NO;
            }
        }
    }
    
    // TODO: check token expire & check token validate.
  
    BOOL jmp = YES;
    while (jmp) {
        if (self.pipeline.isReady) {
            // TODO: get token from auth server.
            [self applyToken:domain appkey:appKey completion:^(CAuthToken * _Nonnull token) {
                [self writeTokenIntoDiskCache:token];
                if (completion) {
                    completion(token);
                }
            }];
            jmp = NO;
        }
    }
}

- (CAuthToken *)getTokenFromDiskCache{
    // TODO: encrypt
    NSString *tokenPath = [cachePath stringByAppendingPathComponent:@"token"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:tokenPath]) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL fileURLWithPath:tokenPath]];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"get token json from disk cache : %@", json);
        CAuthToken *token = [CAuthToken fromJson:json];
        NSLog(@"get token from disk cache : %@",[token toJson]);
        return token;
    }
    NSLog(@"get nil token from disk cache");
    return nil;
}

- (void)writeTokenIntoDiskCache:(CAuthToken *)token{
    // TODO: decrypt
    NSString *tokenPath = [cachePath stringByAppendingPathComponent:@"token"];
    NSFileManager *manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:tokenPath]) {
        [manager removeItemAtURL:[NSURL fileURLWithPath:tokenPath] error:nil];
    }
    NSDictionary *json = [token toJson];
    NSLog(@"write in token json : %@",json);
    NSData *data = [NSJSONSerialization dataWithJSONObject:json options:NSJSONWritingFragmentsAllowed error:nil];
    [data writeToURL:[NSURL fileURLWithPath:tokenPath] atomically:YES];
}


- (void)applyToken:(NSString *)domain appkey:(NSString *)appKey completion:(nonnull void (^)(CAuthToken * _Nonnull))completion{
    NSAssert(domain, @"can't apply token with nil domain.");
    NSAssert(appKey, @"can't apply token with nil appkey.");
    
    CPacket *packet = [[CPacket alloc] init];
    packet.name = @"applyToken";
    packet.data = @{
        @"domain":domain,
        @"appKey":appKey,
    };
    [self.pipeline send:CAuthService.mName packet:packet response:^(CPacket * _Nonnull packet) {
        NSLog(@"send apply token ack with data : %@",packet.data);
        CAuthToken *token = [[CAuthToken alloc] initWithJson:packet.data];
        if (completion) {
            completion(token);
        }
    }];
}


- (void)checkToken:(void(^)(void))success failure:(void(^)(void))failure{
    NSAssert(self.token, @"check token failed with nil token.");
    NSString *code = self.token.code;
    CPacket *packet = [[CPacket alloc] init];
    packet.name = @"getToken";
    packet.data = @{@"code":code};
    [self.pipeline send:CAuthService.mName packet:packet response:^(CPacket * _Nonnull packet) {
        int code = [packet getStateCode];
        if (code == 1000 && [packet.data[@"code"] intValue] == 0) { // ok
            NSLog(@"token is valid. : %@",packet.data);
            if (success) {
                success();
            }
        }
        else{
            NSLog(@"check token failed.");
            if (failure) {
                failure();
            }
        }
    }];
}



@end
