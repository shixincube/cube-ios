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

#import "CubeAccountHelper.h"
#import "CubeAccount.h"
#import <Cube/CUtils.h>
#import <Cube/Cube.h>

#define KEY_TOKEN           @"CubeAppToken"
#define KEY_ACCOUNT         @"CubeAppAccount"
#define KEY_ENGINECONFIG    @"CubeEngineConfig"


@interface CubeAccountHelper ()

- (void)loadToken;

@end


@implementation CubeAccountHelper

@synthesize explorer = _explorer;
@synthesize tokenCode = _tokenCode;
@synthesize tokenExpireTime = _tokenExpireTime;
@synthesize currentAccount = _currentAccount;
@synthesize engineConfig = _engineConfig;

+ (CubeAccountHelper *)sharedInstance {
    static CubeAccountHelper *helper;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        helper = [[CubeAccountHelper alloc] init];
    });
    return helper;
}

- (instancetype)init {
    if (self = [super init]) {
        _tokenExpireTime = 0;
    }

    return self;
}

- (void)saveToken:(NSString *)code tokenExpireTime:(NSUInteger)expireTime {
    _tokenCode = code;
    _tokenExpireTime = expireTime;

    NSNumber * time = [NSNumber numberWithUnsignedLong:expireTime];
    NSDictionary * json = @{ @"code" : code, @"expire" : time };
    [[NSUserDefaults standardUserDefaults] setValue:json forKey:KEY_TOKEN];
}

- (BOOL)checkValidToken {
    if (self.tokenCode) {
        UInt64 now = [CUtils currentTimeMillis];
        if (self.tokenExpireTime > now) {
            return YES;
        }
    }

    return NO;
}

- (void)injectEngineEvent {
    [CEngine sharedInstance].contactService.delegate = self;
}

- (void)getBuildinAccounts:(void (^)(NSArray<__kindof CubeAccount *> *))handler {
    [self.explorer getBuildinAccounts:^(id data) {
        NSArray * array = (NSArray *)data;
        NSMutableArray * accounts = [[NSMutableArray alloc] initWithCapacity:array.count];
        for (NSDictionary * data in array) {
            CubeAccount * account = [[CubeAccount alloc] initWithJSON:data];
            [accounts addObject:account];
        }

        handler(accounts);
    } failure:^(NSError *error) {
        handler(nil);
    }];
}

#pragma mark - Delegate

- (NSDictionary *)needContactContext:(CContact *)contact {
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    __block CubeAccount * account = nil;

    [self.explorer getAccountWithId:contact.identity tokenCode:self.tokenCode success:^(id data) {
        account = data;

        // 修改名称
        [[CEngine sharedInstance].contactService modifyContactName:contact newName:account.displayName];

        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError * error) {
        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, timeout);

    return (account) ? [account toJSON] : nil;
}

#pragma mark - Getters

- (NSString *)defaultAvatarImageName {
    return @"AvatarDefault";
}

- (CubeAccountExplorer *)explorer {
    if (!_explorer) {
        _explorer = [[CubeAccountExplorer alloc] init];
    }

    return _explorer;
}

- (NSString *)tokenCode {
    if (!_tokenCode) {
        // 尝试读取令牌数据
        [self loadToken];
    }
    
    return _tokenCode;
}

- (NSUInteger)tokenExpireTime {
    if (0 == _tokenExpireTime) {
        // 尝试读取令牌数据
        [self loadToken];
    }

    return _tokenExpireTime;
}

- (CubeAccount *)currentAccount {
    if (!_currentAccount) {
        NSDictionary * json = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_ACCOUNT];
        
        if (json) {
            _currentAccount = [[CubeAccount alloc] initWithJSON:json];
        }
    }

    return _currentAccount;
}

- (NSDictionary *)engineConfig {
    if (!_engineConfig) {
        NSDictionary * json = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_ENGINECONFIG];
        if (json) {
            _engineConfig = json;
        }
    }

    return _engineConfig;
}

#pragma mark - Setters

- (void)setCurrentAccount:(CubeAccount *)currentAccount {
    _currentAccount = currentAccount;

    if (_currentAccount) {
        [[NSUserDefaults standardUserDefaults] setValue:[_currentAccount toJSON] forKey:KEY_ACCOUNT];
    }
}

- (void)setEngineConfig:(NSDictionary *)engineConfig {
    _engineConfig = engineConfig;

    if (engineConfig) {
        [[NSUserDefaults standardUserDefaults] setValue:engineConfig forKey:KEY_ENGINECONFIG];
    }
}

#pragma mark - Private

- (void)loadToken {
    NSDictionary * tokenJson = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_TOKEN];
    if (tokenJson) {
        _tokenCode = [tokenJson valueForKey:@"code"];
        _tokenExpireTime = [[tokenJson valueForKey:@"expire"] unsignedLongLongValue];
    }
}

@end
