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

#import "CMessagingStorage.h"
#import <FMDB/FMDatabase.h>

@interface CMessagingStorage () {
    
    NSString * _domain;

    FMDatabase * _db;
}

- (void)execSelfChecking;

@end


@implementation CMessagingStorage

- (instancetype)init {
    if (self = [super init]) {
        _db = nil;
    }
    
    return self;
}

- (BOOL)open:(UInt64)contactId domain:(NSString *)domain {
    if (_db) {
        return TRUE;
    }
    
    _domain = domain;
    
    NSString * dbName = [NSString stringWithFormat:@"CubeMessaging_%@_%lld.db", domain, contactId];

    // 创建数据库文件
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filename = [docPath stringByAppendingPathComponent:dbName];
    _db = [[FMDatabase alloc] initWithPath:filename];

    if ([_db open]) {
        [self execSelfChecking];
        return TRUE;
    }
    else {
        return FALSE;
    }
}

- (void)close {
    
}

#pragma mark - Private

- (void)execSelfChecking {
    // 配置信息表
    NSString * sql = @"CREATE TABLE IF NOT EXISTS `config` (`item` TEXT, `value` TEXT)";

    if ([_db executeUpdate:sql]) {
        NSLog(@"CMessagingStorage#execSelfChecking : `config` table OK");
    }
    
    // 消息表
    sql = @"CREATE TABLE IF NOT EXISTS `message` (`id` BIGINT PRIMARY KEY, `from` BIGINT, `to` BIGINT)";
}

@end
