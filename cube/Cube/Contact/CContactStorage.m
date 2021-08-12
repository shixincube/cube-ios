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

#import "CContactStorage.h"
#import "CUtils.h"
#import <FMDB/FMDatabase.h>

@interface CContactStorage () {
    
    NSString * _domain;
    
    FMDatabase * _db;
}

- (void)execSelfChecking;

@end

@implementation CContactStorage

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
    
    NSString * dbName = [NSString stringWithFormat:@"CubeContact_%@_%lld.db", domain, contactId];

    // 创建数据库文件
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)     objectAtIndex:0];
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
    if (_db) {
        [_db close];
        _db = nil;
    }
}

- (CContact *)readContact:(UInt64)contactId {
    CContact * contact = nil;
    
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM `contact` WHERE `id`=%lld", contactId];
    FMResultSet * result = [_db executeQuery:sql];
    if ([result next]) {
        NSString * name = [result stringForColumn:@"name"];
        
        NSString * context = [result stringForColumn:@"context"];
        NSDictionary * contextData = nil;
        if (context) {
            contextData = [CUtils toJSONWithString:context];
        }

        contact = [[CContact alloc] initWithId:contactId name:name domain:_domain];
        if (contextData) {
            contact.context = contextData;
        }
        
        // 查询附件
        sql = [NSString stringWithFormat:@"SELECT * FROM `appendix` WHERE `id`=%lld", contactId];
        FMResultSet * appendixResult = [_db executeQuery:sql];
        if ([appendixResult next]) {
            NSString * appendixString = [appendixResult stringForColumn:@"appendix"];
            NSDictionary * json = [CUtils toJSONWithString:appendixString];
        }
    }
    
    return contact;
}

#pragma mark - Private

- (void)execSelfChecking {
    // 联系人表
    NSString * sql = @"CREATE TABLE IF NOT EXISTS `contact` (`sn` INTEGER PRIMARY KEY AUTOINCREMENT, `id` BIGINT, `name` TEXT, `context` TEXT)";

    if ([_db executeUpdate:sql]) {
        NSLog(@"CContactStorage#execSelfChecking : `contact` table OK");
    }

    // 群组表
    sql = @"CREATE TABLE IF NOT EXISTS `group` (`sn` INTEGER PRIMARY KEY AUTOINCREMENT, `id` BIGINT, `name` TEXT, `owner` TEXT, `tag` TEXT, `creation` BIGINT, `last_active` BIGINT, `state` INTEGER, `context` TEXT)";

    if ([_db executeUpdate:sql]) {
        NSLog(@"CContactStorage#execSelfChecking : `group` table OK");
    }

    // 群成员表
    sql = @"CREATE TABLE IF NOT EXISTS `group_member` (`sn` INTEGER PRIMARY KEY AUTOINCREMENT, `group` BIGINT, `contact_id` BIGINT, `contact_name` TEXT, `contact_context` TEXT)";

    if ([_db executeUpdate:sql]) {
        NSLog(@"CContactStorage#execSelfChecking : `group_member` table OK");
    }
    
    // 附录表
    sql = @"CREATE TABLE IF NOT EXISTS `appendix` (`id` BIGINT PRIMARY KEY, `appendix` TEXT)";
    
    if ([_db executeUpdate:sql]) {
        NSLog(@"CContactStorage#execSelfChecking : `appendix` table OK");
    }
}

@end
