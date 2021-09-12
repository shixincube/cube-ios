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

#define KEY_TOKEN @"CubeAppToken"
#define KEY_ACCOUNT @"CubeAppAccount"
#define KEY_ENGINECONFIG @"CubeEngineConfig"

@interface CubeAccountHelper ()

- (void)loadToken;

@end


@implementation CubeAccountHelper

@synthesize tokenCode = _tokenCode;
@synthesize tokenExpireTime = _tokenExpireTime;
@synthesize current = _current;
@synthesize cubeConfig = _cubeConfig;

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

#pragma mark - Getters

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

- (CubeAccount *)current {
    if (!_current) {
        NSDictionary * json = [[NSUserDefaults standardUserDefaults] valueForKey:KEY_ACCOUNT];
        if (json) {
            _current = [[CubeAccount alloc] initWithJSON:json];
        }
    }
    
    return _current;
}

#pragma mark - Setters

- (void)setCurrent:(CubeAccount *)current {
    _current = current;

    if (_current) {
        [[NSUserDefaults standardUserDefaults] setValue:_current forKey:KEY_ACCOUNT];
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
