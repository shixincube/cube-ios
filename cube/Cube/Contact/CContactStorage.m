/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Cube Team.
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
#import "CContactAppendix.h"
#import <FMDB/FMDatabase.h>

@interface CContactStorage () {

    CContactService * _service;

    NSString * _domain;

    FMDatabase * _db;
}

- (void)execSelfChecking;

- (void)dropAllTables;

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
    
    NSString * dbName = [NSString stringWithFormat:@"CubeContact_%@_%llu.db", domain, contactId];

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
    @synchronized (self) {
        if (_db) {
            [_db close];
            _db = nil;
        }
    }
}

- (CContact *)readContact:(UInt64)contactId {
    CContact * contact = nil;

    @synchronized (self) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM `contact` WHERE `id`=%llu", contactId];
        FMResultSet * result = [_db executeQuery:sql];
        if ([result next]) {
            NSString * name = [result stringForColumn:@"name"];

            NSString * contextString = [result stringForColumn:@"context"];
            NSDictionary * contextData = nil;
            if (contextString && contextString.length > 1) {
                contextData = [CUtils toJSONWithString:contextString];
            }

            UInt64 timestamp = [result unsignedLongLongIntForColumn:@"timestamp"];
            UInt64 last = [result unsignedLongLongIntForColumn:@"last"];
            UInt64 expiry = [result unsignedLongLongIntForColumn:@"expiry"];

            contact = [[CContact alloc] initWithId:contactId name:name domain:_domain timestamp:timestamp];
            // 重置时间戳
            [contact resetExpiry:expiry lastTimestamp:last];
            // 上下文
            if (contextData) {
                contact.context = contextData;
            }

            [result close];

            // 查找附录
            sql = [NSString stringWithFormat:@"SELECT * FROM `appendix` WHERE `id`=%llu", contactId];
            FMResultSet * appendixResult = [_db executeQuery:sql];
            if ([appendixResult next]) {
                NSString * appendixString = [appendixResult stringForColumn:@"data"];
                NSDictionary * json = [CUtils toJSONWithString:appendixString];

                // 实例化附录
                CContactAppendix * appendix = [[CContactAppendix alloc] initWithService:_service contact:contact json:json];
                // 关联附录
                contact.appendix = appendix;
            }

            [appendixResult close];
        }
        else {
            [result close];
        }
    }

    return contact;
}

- (BOOL)writeContact:(CContact *)contact {
    BOOL ret = FALSE;

    @synchronized (self) {
        NSString * sql = [NSString stringWithFormat:@"SELECT `sn` FROM `contact` WHERE `id`=%llu", contact.identity];
        FMResultSet * result = [_db executeQuery:sql];
        if ([result next]) {
            [result close];

            // 已经有数据进行更新
            sql = @"UPDATE `contact` SET `name`=?, `context`=?, `timestamp`=?, `last`=?, `expiry`=? WHERE `id`=?";

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
                   [NSNumber numberWithUnsignedLongLong:contact.last],
                   [NSNumber numberWithUnsignedLongLong:contact.expiry],
                   [NSNumber numberWithUnsignedLongLong:contact.identity]];

            if (ret && contact.appendix) {
                // 更新附录
                sql = @"UPDATE `appendix` SET `data`=?, `timestamp`=? WHERE `id`=?";

                NSString * appendixString = [CUtils toStringWithJSON:[contact.appendix toJSON]];

                ret = [_db executeUpdate:sql, appendixString,
                       [NSNumber numberWithUnsignedLongLong:contact.last],
                       [NSNumber numberWithUnsignedLongLong:contact.identity]];
            }
        }
        else {
            [result close];

            // 没有数据进行插入
            sql = @"INSERT INTO `contact`(`id`,`name`,`context`,`timestamp`,`last`,`expiry`) VALUES (?,?,?,?,?,?)";

            NSString * contextString = contact.context ?
                    [CUtils toStringWithJSON:contact.context] : @"";

            // 执行 SQL
            ret = [_db executeUpdate:sql, [NSNumber numberWithUnsignedLongLong:contact.identity],
                   contact.name, contextString,
                   [NSNumber numberWithUnsignedLongLong:contact.timestamp],
                   [NSNumber numberWithUnsignedLongLong:contact.last],
                   [NSNumber numberWithUnsignedLongLong:contact.expiry]];

            if (ret && contact.appendix) {
                // 插入附录
                sql = @"INSERT INTO `appendix`(`id`,`data`,`timestamp`) VALUES (?,?,?)";

                ret = [_db executeUpdate:sql, [NSNumber numberWithUnsignedLongLong:contact.identity],
                       [CUtils toStringWithJSON:[contact.appendix toJSON]],
                       [NSNumber numberWithUnsignedLongLong:contact.last]];
            }
        }
    }

    return ret;
}

- (UInt64)updateContactContext:(UInt64)contactId context:(NSDictionary *)context {
    NSString * sql = @"UPDATE `contact` SET `context`=?, `last`=?, `expiry`=? WHERE `id`=?";

    NSString * contextString = [CUtils toStringWithJSON:context];

    UInt64 now = [CUtils currentTimeMillis];
    @synchronized (self) {
        // 执行 SQL
        [_db executeUpdate:sql, contextString,
                [NSNumber numberWithUnsignedLongLong:now],
                [NSNumber numberWithUnsignedLongLong:now + CUBE_LIFECYCLE_IN_MSEC],
                [NSNumber numberWithUnsignedLongLong:contactId]];
    }
    return now;
}

- (void)updateContactName:(UInt64)contactId name:(NSString *)name {
    NSString * sql = @"UPDATE `contact` SET `name`=? WHERE `id`=?";
    @synchronized (self) {
        // 执行 SQL
        [_db executeUpdate:sql, name,
               [NSNumber numberWithUnsignedLongLong:contactId]];
    }
}

- (BOOL)writeContactAppendix:(CContactAppendix *)appendix {
    BOOL ret = FALSE;

    @synchronized (self) {
        NSString * sql = [NSString stringWithFormat:@"SELECT `id` FROM `appendix` WHERE `id`=%llu", appendix.owner.identity];
        FMResultSet * result = [_db executeQuery:sql];
        if ([result next]) {
            [result close];

            // 有数据，更新
            sql = @"UPDATE `appendix` SET `data`=?, `timestamp`=? WHERE `id`=?";

            NSString * appendixString = [CUtils toStringWithJSON:[appendix toJSON]];

            ret = [_db executeUpdate:sql, appendixString,
                   [NSNumber numberWithUnsignedLongLong:[CUtils currentTimeMillis]],
                   [NSNumber numberWithUnsignedLongLong:appendix.owner.identity]];
        }
        else {
            [result close];

            // 无数据，插入
            sql = @"INSERT INTO `appendix`(`id`,`data`,`timestamp`) VALUES (?,?,?)";

            NSString * appendixString = [CUtils toStringWithJSON:[appendix toJSON]];

            ret = [_db executeUpdate:sql,
                   [NSNumber numberWithUnsignedLongLong:appendix.owner.identity],
                   appendixString,
                   [NSNumber numberWithUnsignedLongLong:[CUtils currentTimeMillis]]];
        }
    }

    return ret;
}

#pragma mark - # Contact Zone

- (CContactZone *)readContactZone:(NSString *)zoneName {
    CContactZone * zone = nil;

    @synchronized (self) {
        NSString * sql = [NSString stringWithFormat:@"SELECT * FROM `contact_zone` WHERE `name`='%@'", zoneName];
        FMResultSet * result = [_db executeQuery:sql];
        if ([result next]) {
            UInt64 identity = [result unsignedLongLongIntForColumn:@"id"];
            NSString * name = [result stringForColumn:@"name"];
            NSString * displayName = [result stringForColumn:@"display_name"];
            UInt64 timestamp = [result unsignedLongLongIntForColumn:@"timestamp"];
            CContactZoneState state = [result intForColumn:@"state"];
            // 实例化分区
            zone = [[CContactZone alloc] initWithId:identity name:name displayName:displayName timestamp:timestamp state:state];
        }

        [result close];

        if (nil == zone) {
            return nil;
        }

        sql = [NSString stringWithFormat:@"SELECT * FROM `contact_zone_participant` WHERE `contact_zone_id`=%llu", zone.identity];
        FMResultSet * partResult = [_db executeQuery:sql];
        while ([partResult next]) {
            UInt64 contactId = [partResult unsignedLongLongIntForColumn:@"contact_id"];
            CContactZoneParticipantState state = [partResult intForColumn:@"state"];
            NSString * postscript = [partResult stringForColumn:@"postscript"];

            CContactZoneParticipant * participant = [[CContactZoneParticipant alloc] initWithContactId:contactId state:state postscript:postscript];
            [zone addContact:participant];
        }

        [partResult close];
    }

    return zone;
}

- (void)writeContactZone:(CContactZone *)zone {
    @synchronized (self) {
        NSString * sql = [NSString stringWithFormat:@"SELECT `id` FROM `contact_zone` WHERE `name`='%@'", zone.name];
        FMResultSet * result = [_db executeQuery:sql];
        if ([result next]) {
            [result close];

            // 已存在，重置参与人数据，删除已存在数据
            sql = [NSString stringWithFormat:@"DELETE FROM `contact_zone_participant` WHERE `contact_zone_id`=%llu", zone.identity];
            [_db executeUpdate:sql];

            // 更新数据
            sql = [NSString stringWithFormat:@"UPDATE `contact_zone` SET `display_name`='%@', `state`=%d, `timestamp`=%llu", zone.displayName, zone.state, zone.timestamp];
            [_db executeUpdate:sql];
        }
        else {
            [result close];

            // 不存在，写入
            sql = @"INSERT INTO `contact_zone` (`id`,`name`,`display_name`,`state`,`timestamp`) VALUES (?,?,?,?,?)";
            [_db executeUpdate:sql,
                [NSNumber numberWithUnsignedLongLong:zone.identity],
                zone.name,
                zone.displayName,
                [NSNumber numberWithInt:zone.state],
                [NSNumber numberWithUnsignedLongLong:zone.timestamp]
            ];
        }

        // 写入参与人数据
        NSNumber * zoneId = [NSNumber numberWithUnsignedLongLong:zone.identity];
        NSNumber * timestamp = [NSNumber numberWithUnsignedLongLong:zone.timestamp];
        for (CContactZoneParticipant * participant in zone.participants) {
            NSString * postscript = (nil != participant.postscript) ? participant.postscript : @"";

            sql = @"INSERT INTO `contact_zone_participant` (`contact_zone_id`,`contact_id`,`state`,`timestamp`,`postscript`) VALUES (?,?,?,?,?)";
            [_db executeUpdate:sql,
                zoneId,
                [NSNumber numberWithUnsignedLongLong:participant.contactId],
                [NSNumber numberWithInt:participant.state],
                timestamp,
                postscript
            ];
        }
    }
}

#pragma mark - Private

- (void)execSelfChecking {
    // 联系人表
    NSString * sql = @"CREATE TABLE IF NOT EXISTS `contact` (`sn` BIGINT PRIMARY KEY AUTOINCREMENT, `id` BIGINT, `name` TEXT, `context` TEXT, `timestamp` BIGINT DEFAULT 0, `last` BIGINT DEFAULT 0, `expiry` BIGINT DEFAULT 0)";
    if ([_db executeUpdate:sql]) {
        NSLog(@"CContactStorage#execSelfChecking : `contact` table OK");
    }

    // 群组表
    sql = @"CREATE TABLE IF NOT EXISTS `group` (`sn` BIGINT PRIMARY KEY AUTOINCREMENT, `id` BIGINT, `name` TEXT, `owner` TEXT, `tag` TEXT, `creation` BIGINT, `last_active` BIGINT, `state` INTEGER, `context` TEXT)";
    if ([_db executeUpdate:sql]) {
        NSLog(@"CContactStorage#execSelfChecking : `group` table OK");
    }

    // 群成员表
    sql = @"CREATE TABLE IF NOT EXISTS `group_member` (`sn` BIGINT PRIMARY KEY AUTOINCREMENT, `group` BIGINT, `contact_id` BIGINT, `contact_name` TEXT, `contact_context` TEXT)";
    if ([_db executeUpdate:sql]) {
        NSLog(@"CContactStorage#execSelfChecking : `group_member` table OK");
    }

    // 附录表
    sql = @"CREATE TABLE IF NOT EXISTS `appendix` (`id` BIGINT PRIMARY KEY, `timestamp` BIGINT, `data` TEXT)";
    if ([_db executeUpdate:sql]) {
        NSLog(@"CContactStorage#execSelfChecking : `appendix` table OK");
    }

    // 联系人分区
    sql = @"CREATE TABLE IF NOT EXISTS `contact_zone` (`id` BIGINT PRIMARY KEY, `name` TEXT, `display_name` TEXT, `state` INTEGER, `timestamp` BIGINT)";
    if ([_db executeUpdate:sql]) {
        NSLog(@"CContactStorage#execSelfChecking : `contact_zone` table OK");
    }

    // 联系人分区参与者
    sql = @"CREATE TABLE IF NOT EXISTS `contact_zone_participant` (`contact_zone_id` BIGINT, `contact_id` BIGINT, `state` INTEGER, `timestamp` BIGINT, `postscript` TEXT)";
    if ([_db executeUpdate:sql]) {
        NSLog(@"CContactStorage#execSelfChecking : `contact_zone_participant` table OK");
    }
}

- (void)dropAllTables {
    if ([_db executeUpdate:@"DROP TABLE `contact`"]) {
        NSLog(@"CContactStorage#dropAllTables : Drop `contact`");
    }

    if ([_db executeUpdate:@"DROP TABLE `appendix`"]) {
        NSLog(@"CContactStorage#dropAllTables : Drop `appendix`");
    }
}

@end
