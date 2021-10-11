/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Shixin Cube Team.
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

#import "CubeAccountExplorer.h"
#import <AFNetworking/AFNetworking.h>
#import "CubeAccount.h"
#import "CubeAccountHelper.h"

#define URL_CUBE_CONFIG  @"/cube/config/"
#define URL_LOGIN        @"/account/login/"
#define URL_LOGOUT       @"/account/logout/"
#define URL_REGISTER     @"/account/register/"
#define URL_INFO         @"/account/info/"

@interface CubeAccountExplorer ()

@property (nonatomic, strong) AFHTTPSessionManager * httpManager;

@end

@implementation CubeAccountExplorer

- (NSString *)defaultAvatar {
    return @"default";
}

- (void)loginWithPhoneNumber:(NSString *)phoneNumber
                    password:(NSString *)password
                     success:(CubeBlockRequestSuccessWithData)success
                     failure:(CubeBlockRequestFailureWithError)failure {
    UIDevice * dev = [UIDevice currentDevice];
    NSString * device = [NSString stringWithFormat:@"%@/%@ %@/%@", dev.model, dev.systemName, dev.systemVersion,
                         dev.identifierForVendor.UUIDString];

    NSString * url = [HOST_URL stringByAppendingString:URL_LOGIN];
    NSDictionary * params = @{
        @"phone" : phoneNumber,
        @"password" : password,
        @"device" : device };

    [self.httpManager POST:url
                parameters:params
                   headers:nil
                  progress:nil
                   success:^(NSURLSessionDataTask * task, id responseObject) {
        // 请求成功
        NSDictionary * json = [responseObject toJSONObject];
        NSInteger code = [[json valueForKey:@"code"] integerValue];
        if (code == CubeAccountStateCodeSuccess) {
            NSString * tokenCode = (NSString *) [json valueForKey:@"token"];
            NSUInteger tokenExpireTime = [[json valueForKey:@"expire"] unsignedLongLongValue];
            [[CubeAccountHelper sharedInstance] saveToken:tokenCode tokenExpireTime:tokenExpireTime];

            success(tokenCode);
        }
        else {
            NSError * error = [NSError errorWithDomain:@"CubeFailure" code:code userInfo:nil];
            failure(error);
        }
    }
                   failure:^(NSURLSessionDataTask * task, NSError * error) {
        // 请求失败
        failure(error);
    }];
}

- (void)registerWithPhoneNumber:(NSString *)phoneNumber
                       password:(NSString *)password
                       nickname:(NSString *)nickname
                         avatar:(NSString *)avatar
                        success:(CubeBlockRequestSuccessWithData)success
                        failure:(CubeBlockRequestFailureWithError)failure {
    NSString * url = [HOST_URL stringByAppendingString:URL_REGISTER];
    NSDictionary * params = @{
        @"phone" : phoneNumber,
        @"password" : password,
        @"nickname" : nickname,
        @"avatar" : avatar };

    [self.httpManager POST:url
                parameters:params
                   headers:nil
                  progress:nil
                   success:^(NSURLSessionDataTask * task, id responseObject) {
        // 请求成功
        NSDictionary * json = [responseObject toJSONObject];
        NSInteger code = [[json valueForKey:@"code"] integerValue];
        if (code == CubeAccountStateCodeSuccess) {
            // 回调成功
            CubeAccount * account = [CubeAccount accountWithJSON:[json valueForKey:@"account"]];
            success(account);
        }
        else {
            // 回调故障
            NSError * error = [NSError errorWithDomain:@"CubeAccountExplorer" code:code userInfo:nil];
            failure(error);
        }
    }
                   failure:^(NSURLSessionDataTask * task, NSError * error) {
        // 请求失败
        failure(error);
    }];
}

- (void)getAccountWithToken:(NSString *)tokenCode
                    success:(CubeBlockRequestSuccessWithData)success
                    failure:(CubeBlockRequestFailureWithError)failure {
    NSString * url = [HOST_URL stringByAppendingString:URL_INFO];
    NSDictionary * params = @{
        @"token" : tokenCode };

    [self.httpManager GET:url
               parameters:params
                  headers:nil
                 progress:nil
                  success:^(NSURLSessionDataTask * task, id responseObject) {
        // 请求成功
        NSDictionary * json = [responseObject toJSONObject];
        CubeAccount * account = [[CubeAccount alloc] initWithJSON:json];
        // 保存数据
        [CubeAccountHelper sharedInstance].currentAccount = account;
        // 回调
        success(account);
    }
                  failure:^(NSURLSessionDataTask * task, NSError * error) {
        // 请求失败
        NSLog(@"Get account failure: %ld", error.code);
        failure(error);
    }];
}

- (void)getAccountWithId:(NSUInteger)accountId
               tokenCode:(NSString *)tokenCode
                 success:(CubeBlockRequestSuccessWithData)success
                 failure:(CubeBlockRequestFailureWithError)failure {
    NSString * url = [HOST_URL stringByAppendingString:URL_INFO];
    NSDictionary * params = @{
        @"id" : [NSNumber numberWithUnsignedInteger:accountId],
        @"token" : tokenCode };

    [self.httpManager GET:url
               parameters:params
                  headers:nil
                 progress:nil
                  success:^(NSURLSessionDataTask * task, id responseObject) {
        // 请求成功
        NSDictionary * json = [responseObject toJSONObject];
        CubeAccount * account = [[CubeAccount alloc] initWithJSON:json];
        success(account);
    }
                  failure:^(NSURLSessionDataTask * task, NSError * error) {
        // 请求失败
        failure(error);
    }];
}

- (void)getEngineConfigWithSuccess:(CubeBlockRequestSuccessWithData)success
                           failure:(CubeBlockRequestFailureWithError)failure {
    NSString * url = [HOST_URL stringByAppendingString:URL_CUBE_CONFIG];
    NSDictionary * params = @{
        @"t" : [CubeAccountHelper sharedInstance].tokenCode };

    [self.httpManager GET:url
               parameters:params
                  headers:nil
                 progress:nil
                  success:^(NSURLSessionDataTask * task, id responseObject) {
        // 请求成功
        [CubeAccountHelper sharedInstance].engineConfig = [responseObject toJSONObject];
        // 回调
        success([CubeAccountHelper sharedInstance].engineConfig);
    }
                  failure:^(NSURLSessionDataTask * task, NSError * error) {
        // 请求失败
        NSLog(@"Get engine config: %ld", error.code);
        failure(error);
    }];
}

#pragma mark - Getter

- (AFHTTPSessionManager *)httpManager {
    if (!_httpManager) {
        _httpManager = [AFHTTPSessionManager manager];
        
        NSSet * acceptableContentTypes = [NSSet setWithObjects:@"application/json",
                                             @"text/html",
                                             @"text/json",
                                             @"text/javascript",
                                             @"text/plain", nil];
        _httpManager.operationQueue.maxConcurrentOperationCount = 5;
        _httpManager.requestSerializer.timeoutInterval = 3;
        _httpManager.responseSerializer.acceptableContentTypes = acceptableContentTypes;
    }
    
    return _httpManager;
}

@end
