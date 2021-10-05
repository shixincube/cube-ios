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
#import "CMessageState.h"
#import "CUtils.h"
#import <FMDB/FMDatabase.h>
#import <FMDB/FMDatabaseQueue.h>

@interface CMessagingStorage () {
    
    CMessagingService * _service;
    
    NSString * _domain;

    FMDatabaseQueue * _dbQueue;
}

- (void)execSelfChecking;

@end


@implementation CMessagingStorage

- (instancetype)initWithService:(CMessagingService *)service {
    if (self = [super init]) {
        _service = service;
        _dbQueue = nil;
    }

    return self;
}

- (BOOL)open:(UInt64)contactId domain:(NSString *)domain {
    if (_dbQueue) {
        return TRUE;
    }

    _domain = domain;

    NSString * dbName = [NSString stringWithFormat:@"CubeMessaging_%@_%llu.db", domain, contactId];

    // 创建数据库文件
    NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString * filename = [docPath stringByAppendingPathComponent:dbName];
    _dbQueue = [FMDatabaseQueue databaseQueueWithPath:filename];

    [self execSelfChecking];

    return TRUE;
}

- (void)close {
    if (_dbQueue) {
        [_dbQueue close];
        _dbQueue = nil;
    }
}

- (UInt64)queryLastMessageTime {
    __block UInt64 ret = 0;
    
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString * sql = @"SELECT `rts` FROM `message` WHERE `scope`=0 ORDER BY `rts` DESC LIMIT 1";
        FMResultSet * result = [db executeQuery:sql];
        if ([result next]) {
            ret = [result unsignedLongLongIntForColumn:@"rts"];
        }

        [result close];

        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, timeout);

    return ret;
}

- (BOOL)updateMessage:(CMessage *)message {
    __block BOOL exists = FALSE;

    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        // 先查询是否有该消息记录
        NSString * sql = [NSString stringWithFormat:@"SELECT `id` FROM `message` WHERE `id`=%llu", message.identity];
        FMResultSet * result = [db executeQuery:sql];
        if ([result next]) {
            [result close];

            // 更新消息状态
            NSString * jsonString = [CUtils toStringWithJSON:[message toJSON]];
            [db executeUpdate:@"UPDATE `message` SET `rts`=?, `state`=?, `data`=? WHERE `id`=?",
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
            result = [db executeQuery:sql];
            if ([result next]) {
                UInt64 time = [result unsignedLongLongIntForColumn:@"time"];

                [result close];

                if (message.remoteTS > time) {
                    // 更新记录
                    [db executeUpdate:@"UPDATE `recent_messager` SET `time`=?, `message_id`=?, `is_group`=? WHERE `messager_id`=?",
                        [NSNumber numberWithUnsignedLongLong:message.remoteTS],
                        [NSNumber numberWithUnsignedLongLong:message.identity],
                        [NSNumber numberWithInt:([message isFromGroup] ? 1 : 0)],
                        [NSNumber numberWithUnsignedLongLong:messagerId]];
                }
            }
            else {
                [result close];
            }

            exists = TRUE;
        }
        else {
            // 写入新消息
            NSString * jsonString = [CUtils toStringWithJSON:[message toJSON]];

            sql = [NSString stringWithFormat:@"INSERT INTO `message` (`id`,`from`,`to`,source,lts,rts,state,scope,data) VALUES (%llu,%llu,%llu,%llu,%llu,%llu,%d,%d,?)",
                   message.identity,
                   message.from,
                   message.to,
                   message.source,
                   message.localTS,
                   message.remoteTS,
                   message.state,
                   [message getScope]];

            BOOL ret = [db executeUpdate:sql, jsonString];
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

                sql = [NSString stringWithFormat:@"SELECT `time` FROM `recent_messager` WHERE `messager_id`=%llu", messagerId];
                result = [db executeQuery:sql];
                if ([result next]) {
                    [result close];

                    // 更新记录
                    [db executeUpdate:@"UPDATE `recent_messager` SET `time`=?, `message_id`=?, `is_group`=? WHERE `messager_id`=?",
                        [NSNumber numberWithUnsignedLongLong:message.remoteTS],
                        [NSNumber numberWithUnsignedLongLong:message.identity],
                        [NSNumber numberWithInt:([message isFromGroup] ? 1 : 0)],
                        [NSNumber numberWithUnsignedLongLong:messagerId]];
                }
                else {
                    [result close];

                    // 新记录
                    [db executeUpdate:@"INSERT INTO `recent_messager`(messager_id,time,message_id,is_group) VALUES (?,?,?,?)",
                        [NSNumber numberWithUnsignedLongLong:messagerId],
                        [NSNumber numberWithUnsignedLongLong:message.remoteTS],
                        [NSNumber numberWithUnsignedLongLong:message.identity],
                        [NSNumber numberWithInt:([message isFromGroup] ? 1 : 0)]];
                }
            }

            exists = FALSE;
        }

        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, timeout);

    return exists;
}

- (NSArray<__kindof CMessage *> *)queryRecentMessagesWithLimit:(NSInteger)limit {
    __block NSMutableArray<__kindof CMessage *> * array = [[NSMutableArray alloc] init];

    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray * messageIdList = [[NSMutableArray alloc] init];

        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM `recent_messager` ORDER BY `time` DESC LIMIT %ld", limit];
        FMResultSet * result = [db executeQuery:sql];
        while ([result next]) {
            UInt64 messageId = [result unsignedLongLongIntForColumn:@"message_id"];
            [messageIdList addObject:[NSNumber numberWithUnsignedLongLong:messageId]];
        }

        [result close];

        // 逐一查询消息记录
        for (NSNumber * messageId in messageIdList) {
            sql = [NSString stringWithFormat:@"SELECT * FROM `message` WHERE `id`=%llu", messageId.unsignedLongLongValue];
            result = [db executeQuery:sql];

            if ([result next]) {
                NSString * dataString = [result stringForColumn:@"data"];
                // 实例化消息
                CMessage * message = [[CMessage alloc] initWithJSON:[CUtils toJSONWithString:dataString]];
                // 填充数据
                [_service fillMessage:message];

                [array addObject:message];
            }

            [result close];
        }

        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, timeout);

    return array;
}

- (NSUInteger)countUnreadMessagesWithFrom:(UInt64)contactId {
    __block NSUInteger count = 0;
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString * sql = [NSString stringWithFormat:@"SELECT COUNT(`id`) FROM `message` WHERE `from`=%llu AND `state`=%d", contactId, CMessageStateSent];

        FMResultSet * result = [db executeQuery:sql];
        if ([result next]) {
            count = [result intForColumnIndex:0];
        }

        [result close];

        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 10 * NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, timeout);

    return count;
}

- (NSUInteger)countUnreadMessagesWithTo:(UInt64)contactId {
    return 0;
}

- (NSUInteger)countUnreadMessagesWithSource:(UInt64)groupId {
    return 0;
}

- (void)updateMessageStateWithContactId:(UInt64)contactId state:(CMessageState)state completion:(void (^)(NSArray<__kindof NSNumber *> * list))completion {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray * array = [[NSMutableArray alloc] init];

        NSString * sql = [NSString stringWithFormat:@"SELECT `id` FROM `message` WHERE `source`=0 AND `scope`=0 AND `state`=10 AND `from`=%llu", contactId];

        FMResultSet * result = [db executeQuery:sql];
        while ([result next]) {
            NSNumber * mid = [NSNumber numberWithUnsignedLongLong:[result unsignedLongLongIntForColumn:@"id"]];
            [array addObject:mid];
        }

        [result close];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            completion(array);
        });

        if (array.count == 0) {
            return;
        }

        for (NSNumber * messageId in array) {
            NSString * updateSQL = [NSString stringWithFormat:@"UPDATE `message` SET `state`=%d WHERE `id`=%llu", state, [messageId unsignedLongLongValue]];
            BOOL ret = [db executeUpdate:updateSQL];
            if (!ret) {
                NSLog(@"CMessageStorage#updateMessageStateWithContactId failed : %llu", [messageId unsignedLongLongValue]);
            }
        }
    }];
}

- (void)updateMessageState:(UInt64)messageId state:(CMessageState)state completion:(void (^)(void))completion {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString * sql = [NSString stringWithFormat:@"UPDATE `message` SET `state`=%d WHERE `id`=%llu", state, messageId];
        [db executeUpdate:sql];
        completion();
    }];
}

- (void)updateMessagesRemoteState:(NSArray<__kindof NSNumber *> *)messageIdList state:(CMessageState)state completion:(void (^)(void))completion {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        for (NSNumber * messageId in messageIdList) {
            NSString * sql = [NSString stringWithFormat:@"UPDATE `message` SET `remote_state`=%d WHERE `id`=%llu", state, messageId.unsignedLongLongValue];
            BOOL ret = [db executeUpdate:sql];
            if (!ret) {
                NSLog(@"CMessageStorage#updateMessageRemoteState Failed");
            }
        }

        completion();
    }];
}

- (void)updateMessageRemoteState:(UInt64)messageId state:(CMessageState)state completion:(void (^)(void))completion {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString * sql = [NSString stringWithFormat:@"UPDATE `message` SET `remote_state`=%d WHERE `id`=%llu", state, messageId];
        [db executeUpdate:sql];
    }];
}

- (void)queryReverseWithContact:(UInt64)contactId
                      beginning:(UInt64)beginning
                          limit:(NSInteger)limit
                     completion:(void (^)(NSArray <__kindof CMessage *> * array, BOOL hasMore))completion {
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSMutableArray<__kindof CMessage *> * array = [[NSMutableArray alloc] init];

        // 多查询一条记录，判断是否后续还有数据
        BOOL hasMore = FALSE;

        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM `message` WHERE `scope`=0 AND `rts`<%llu ORDER BY `rts` DESC LIMIT %ld",
                          beginning, limit + 1];
        FMResultSet * result = [db executeQuery:sql];
        while ([result next]) {
            if (array.count == limit) {
                hasMore = TRUE;
                break;
            }

            NSString * dataString = [result stringForColumn:@"data"];
            // 实例化消息
            CMessage * message = [[CMessage alloc] initWithJSON:[CUtils toJSONWithString:dataString]];
            // 填充
            [_service fillMessage:message];

            [array addObject:message];
        }

        [result close];

        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            completion(array, hasMore);
        });
    }];
}

- (CMessage *)readMessageWithId:(UInt64)messageId {
    __block CMessage * message = nil;
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM `message` WHERE `id`=%llu", messageId];
        FMResultSet * result = [db executeQuery:sql];

        if ([result next]) {
            NSString * dataString = [result stringForColumn:@"data"];
            // 实例化消息
            message = [[CMessage alloc] initWithJSON:[CUtils toJSONWithString:dataString]];
            // 填充数据
            [_service fillMessage:message];
        }

        [result close];

        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, timeout);

    return message;
}

#pragma mark - Private

- (void)execSelfChecking {
    __block dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);

    [_dbQueue inDatabase:^(FMDatabase * _Nonnull db) {
        // 配置信息表
        NSString * sql = @"CREATE TABLE IF NOT EXISTS `config` (`item` TEXT, `value` TEXT)";
        if ([db executeUpdate:sql]) {
            NSLog(@"CMessagingStorage#execSelfChecking : `config` table OK");
        }

        // 消息表
        sql = @"CREATE TABLE IF NOT EXISTS `message` (`id` BIGINT PRIMARY KEY, `from` BIGINT, `to` BIGINT, `source` BIGINT, `lts` BIGINT, `rts` BIGINT, `state` INT, `remote_state` INT DEFAULT 10, `scope` INT, `data` TEXT)";
        if ([db executeUpdate:sql]) {
            NSLog(@"CMessagingStorage#execSelfChecking : `message` table OK");
        }

        // 最近消息表，当前联系人和其他每一个联系人的最近消息
        // messager_id - 消息相关发件人或收件人 ID
        // time        - 消息是时间戳
        // message_id  - 消息 ID
        // is_group    - 是否来自群组
        sql = @"CREATE TABLE IF NOT EXISTS `recent_messager` (`messager_id` BIGINT PRIMARY KEY, `time` BIGINT, `message_id` BIGINT, `is_group` INT)";
        if ([db executeUpdate:sql]) {
            NSLog(@"CMessagingStorage#execSelfChecking : `recent_messager` table OK");
        }

        // 消息草稿表
        // TODO

        dispatch_semaphore_signal(semaphore);
    }];

    dispatch_time_t timeout = dispatch_time(DISPATCH_TIME_NOW, 3 * NSEC_PER_SEC);
    dispatch_semaphore_wait(semaphore, timeout);
}

@end
