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
#import "CMessagingService+Core.h"
#import "CUtils.h"
#import <FMDB/FMDatabase.h>

@interface CMessagingStorage () {
    
    CMessagingService * _service;
    
    NSString * _domain;

    FMDatabase * _db;
}

- (void)execSelfChecking;

@end


@implementation CMessagingStorage

- (instancetype)initWithService:(CMessagingService *)service {
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
    if (_db) {
        [_db close];
        _db = nil;
    }
}

- (UInt64)queryLastMessageTime {
    NSString * sql = @"SELECT `rts` FROM `message` WHERE `scope`=0 ORDER BY `rts` DESC LIMIT 1";
    FMResultSet * result = [_db executeQuery:sql];
    if ([result next]) {
        return [result unsignedLongLongIntForColumn:@"rts"];
    }

    return 0;
}

- (void)updateMessage:(CMessage *)message {
    // 先查询是否有该消息记录
    NSString * sql = [NSString stringWithFormat:@"SELECT `id` FROM `message` WHERE `id`=%llu", message.identity];
    FMResultSet * result = [_db executeQuery:sql];
    if ([result next]) {
        // 更新消息状态
        NSString * jsonString = [CUtils toStringWithJSON:[message toJSON]];
        [_db executeUpdate:@"UPDATE `message` SET `rts`=? `state`=? `data`=? WHERE `id`=?",
            [NSNumber numberWithUnsignedLongLong:message.remoteTS],
            [NSNumber numberWithInt:message.state],
            jsonString,
            [NSNumber numberWithUnsignedLongLong:message.identity]];

        UInt64 messagerId = 0;

        // 更新最近消息
        if ([message isFromGroup]) {
            // TODO
        }
        else {
            if ([_service isSender:message]) {
                messagerId = message.to;
            }
            else {
                messagerId = message.from;
            }
        }

        sql = [NSString stringWithFormat:@"SELECT `time` FROM `recent_messager` WHERE `messager_id`=%llu", messagerId];
        result = [_db executeQuery:sql];
        if ([result next]) {
            UInt64 time = [result unsignedLongLongIntForColumn:@"time"];
            if (message.remoteTS > time) {
                // 更新记录
                [_db executeUpdate:@"UPDATE `recent_messager` SET `time`=? `message_id`=? `is_group`=? WHERE `messager_id`=?",
                    [NSNumber numberWithUnsignedLongLong:message.remoteTS],
                    [NSNumber numberWithUnsignedLongLong:message.identity],
                    [NSNumber numberWithInt:([message isFromGroup] ? 1 : 0)],
                    [NSNumber numberWithUnsignedLongLong:messagerId]];
            }
        }

        return;
    }

    // 写入新消息
    
    NSString * jsonString = [CUtils toStringWithJSON:[message toJSON]];
    
    sql = [NSString stringWithFormat:@"INSERT INTO `message` (id,from,to,source,lts,rts,state,scope,data) VALUES (%lld,%lld,%lld,%lld,%lld,%lld,%d,%d,?)",
           message.identity,
           message.from,
           message.to,
           message.source,
           message.localTS,
           message.remoteTS,
           message.state,
           [message getScope]];

    BOOL ret = [_db executeUpdate:sql, jsonString];
    if (ret) {
        UInt64 messagerId = 0;

        // 更新最近消息
        if ([message isFromGroup]) {
            // TODO
        }
        else {
            if ([_service isSender:message]) {
                messagerId = message.to;
            }
            else {
                messagerId = message.from;
            }
        }

        sql = [NSString stringWithFormat:@"SELECT `time` FROM `recent_messager` WHERE `messager_id`=%lld", messagerId];
        result = [_db executeQuery:sql];
        if ([result next]) {
            // 更新记录
            [_db executeUpdate:@"UPDATE `recent_messager` SET `time`=? `message_id`=? `is_group`=? WHERE `messager_id`=?",
                [NSNumber numberWithUnsignedLongLong:message.remoteTS],
                [NSNumber numberWithUnsignedLongLong:message.identity],
                [NSNumber numberWithInt:([message isFromGroup] ? 1 : 0)],
                [NSNumber numberWithUnsignedLongLong:messagerId]];
        }
        else {
            // 新记录
            [_db executeUpdate:@"INSERT INTO `recent_messager`(messager_id,time,message_id,is_group) VALUES (?,?,?,?)",
                [NSNumber numberWithUnsignedLongLong:messagerId],
                [NSNumber numberWithUnsignedLongLong:message.remoteTS],
                [NSNumber numberWithUnsignedLongLong:message.identity],
                [NSNumber numberWithInt:([message isFromGroup] ? 1 : 0)]];
        }
    }
}

#pragma mark - Private

- (void)execSelfChecking {
    // 配置信息表
    NSString * sql = @"CREATE TABLE IF NOT EXISTS `config` (`item` TEXT, `value` TEXT)";
    if ([_db executeUpdate:sql]) {
        NSLog(@"CMessagingStorage#execSelfChecking : `config` table OK");
    }

    // 消息表
    sql = @"CREATE TABLE IF NOT EXISTS `message` (`id` BIGINT PRIMARY KEY, `from` BIGINT, `to` BIGINT, `source` BIGINT, `lts` BIGINT, `rts` BIGINT, `state` INT, `scope` INT, `data` TEXT)";
    if ([_db executeUpdate:sql]) {
        NSLog(@"CMessagingStorage#execSelfChecking : `message` table OK");
    }

    // 最近消息表，当前联系人和其他每一个联系人的最近消息
    // messager_id - 消息相关发件人或收件人 ID
    // time        - 消息是时间戳
    // message_id  - 消息 ID
    // is_group    - 是否来自群组
    sql = @"CREATE TABLE IF NOT EXISTS `recent_messager` (`messager_id` BIGINT PRIMARY KEY, `time` BIGINT, `message_id` BIGINT, `is_group` INT)";
    if ([_db executeUpdate:sql]) {
        NSLog(@"CMessagingStorage#execSelfChecking : `recent_messager` table OK");
    }

    // 消息草稿表
    // TODO
}

@end
