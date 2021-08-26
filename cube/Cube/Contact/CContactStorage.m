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
#import "CContactService.h"
#import <FMDB/FMDatabase.h>

@interface CContactStorage () {
    
    CContactService * _service;
    
    NSString * _domain;
    
    FMDatabase * _db;
}

- (void)execSelfChecking;

@end

@implementation CContactStorage

- (instancetype)initWithService:(CContactService *)service {
    if (self = [super init]) {
        _service = service;
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

        NSString * contextString = [result stringForColumn:@"context"];
        NSDictionary * contextData = nil;
        if (contextString && contextString.length > 1) {
            contextData = [CUtils toJSONWithString:contextString];
        }
        
        UInt64 timestamp = [result unsignedLongLongIntForColumn:@"timestamp"];

        contact = [[CContact alloc] initWithId:contactId name:name domain:_domain timestamp:timestamp];
        if (contextData) {
            contact.context = contextData;
        }

        // 查询附件
        sql = [NSString stringWithFormat:@"SELECT * FROM `appendix` WHERE `id`=%lld", contactId];
        FMResultSet * appendixResult = [_db executeQuery:sql];
        if ([appendixResult next]) {
            NSString * appendixString = [appendixResult stringForColumn:@"data"];
            NSDictionary * json = [CUtils toJSONWithString:appendixString];

            // 实例化附录
            CContactAppendix * appendix = [[CContactAppendix alloc] initWithService:_service contact:contact json:json];
            // 关联附录
            contact.appendix = appendix;
        }
    }

    return contact;
}

- (BOOL)writeContact:(CContact *)contact {
    BOOL ret = FALSE;

    NSString * sql = [NSString stringWithFormat:@"SELECT `sn` FROM `contact` WHERE `id`=%lld", contact.identity];
    FMResultSet * result = [_db executeQuery:sql];
    if ([result next]) {
        // 已经有数据进行更新
        sql = @"UPDATE `contact` SET `name`=?, `context`=?, `timestamp`=? WHERE `id`=?";

        NSString * contextString = nil;
        if (contact.context) {
            contextString = [CUtils toStringWithJSON:contact.context];
        }
        else {
            contextString = @"";
        }
        // 执行 SQL
        ret = [_db executeUpdate:sql, contact.name, contextString,
               [NSNumber numberWithUnsignedLongLong:contact.timestamp],
               [NSNumber numberWithUnsignedLongLong:contact.identity]];

        if (ret && contact.appendix) {
            // 更新附录
            sql = @"UPDATE `appendix` SET `data`=? WHERE `id`=?";

            NSString * appendixString = [CUtils toStringWithJSON:[contact.appendix toJSON]];

            ret = [_db executeUpdate:sql, appendixString, [NSNumber numberWithUnsignedLongLong:contact.identity]];
        }
    }
    else {
        // 没有数据进行插入
        sql = @"INSERT INTO `contact`(id,name,context,timestamp) VALUES (?,?,?,?)";

        NSString * contextString = contact.context ?
                [CUtils toStringWithJSON:contact.context] : @"";
        // 执行 SQL
        ret = [_db executeUpdate:sql, [NSNumber numberWithUnsignedLongLong:contact.identity],
               contact.name, contextString, [NSNumber numberWithUnsignedLongLong:contact.timestamp]];

        if (ret && contact.appendix) {
            // 插入附录
            sql = @"INSERT INTO `appendix`(id,data) VALUES (?,?)";

            ret = [_db executeUpdate:sql, [NSNumber numberWithUnsignedLongLong:contact.identity],
                   [CUtils toStringWithJSON:[contact.appendix toJSON]]];
        }
    }

    return ret;
}

- (BOOL)writeContactAppendix:(CContactAppendix *)appendix {
    BOOL ret = FALSE;
    NSString * sql = [NSString stringWithFormat:@"SELECT id FROM `appendix` WHERE `id`=%llu", appendix.owner.identity];
    FMResultSet * result = [_db executeQuery:sql];
    if ([result next]) {
        // 有数据，更新
        sql = @"UPDATE `appendix` SET `data`=? WHERE `id`=?";
        
        NSString * appendixString = [CUtils toStringWithJSON:[appendix toJSON]];

        ret = [_db executeUpdate:sql, appendixString,
               [NSNumber numberWithUnsignedLongLong:appendix.owner.identity]];
    }
    else {
        // 无数据，插入
        sql = @"INSERT INTO `appendix`(id,data) VALUES (?,?)";

        NSString * appendixString = [CUtils toStringWithJSON:[appendix toJSON]];
        
        ret = [_db executeUpdate:sql, [NSNumber numberWithUnsignedLongLong:appendix.owner.identity],
               appendixString];
    }
    
    return ret;
}

#pragma mark - Private

- (void)execSelfChecking {
    // 联系人表
    NSString * sql = @"CREATE TABLE IF NOT EXISTS `contact` (`sn` INTEGER PRIMARY KEY AUTOINCREMENT, `id` BIGINT, `name` TEXT, `context` TEXT, `timestamp` BIGINT)";

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
    sql = @"CREATE TABLE IF NOT EXISTS `appendix` (`id` BIGINT PRIMARY KEY, `data` TEXT)";
    
    if ([_db executeUpdate:sql]) {
        NSLog(@"CContactStorage#execSelfChecking : `appendix` table OK");
    }
}

@end
