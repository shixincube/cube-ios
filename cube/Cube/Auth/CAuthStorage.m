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

#import "CAuthStorage.h"
#import <FMDB/FMDatabase.h>


@interface CAuthStorage () {
    FMDatabase * db;
}

/*!
 * @brief 执行自检。
 */
- (void)execSelfChecking;

@end

@implementation CAuthStorage

- (instancetype)init {
    if (self = [super init]) {
        // 创建数据库文件
        NSString * docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        NSString * filename = [docPath stringByAppendingPathComponent:@"CubeAuth.db"];
        db = [[FMDatabase alloc] initWithPath:filename];
    }

    return self;
}

- (BOOL)open {
    // 自检，尝试创建表
    if ([db open]) {
        [self execSelfChecking];
        return TRUE;
    }

    return FALSE;
}

- (void)close {
    [db close];
}

- (CAuthToken *)loadTokenWithDomain:(NSString *)domain appKey:(NSString *)appKey {
    NSString * sql = [NSString stringWithFormat:@"SELECT * FROM `token` WHERE `cid`=0 AND `domain`='%@' AND `app_key`='%@' ORDER BY sn DESC", domain, appKey];
    FMResultSet * result = [db executeQuery:sql];
    if ([result next]) {
        NSString * data = [result stringForColumn:@"data"];
        NSData * jsonData = [data dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error = nil;
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:jsonData
                                                              options:NSJSONReadingMutableContainers
                                                                error:&error];
        if (error) {
            // 错误
            return nil;
        }
        else {
            CAuthToken * token = [[CAuthToken alloc] initWithJSON:json];
            return token;
        }
    }
    else {
        return nil;
    }
}

- (void)saveToken:(CAuthToken *)authToken {
    NSString * sql = @"INSERT INTO `token` (domain,app_key,cid,data) VALUES (?,?,?,?)";

    NSError * error = nil;
    NSData * jsonData = [NSJSONSerialization dataWithJSONObject:[authToken toJSON] options:0 error:&error];
    NSString * json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];

    BOOL success = [db executeUpdate:sql, authToken.domain, authToken.appKey, authToken.cid, json];
    if (success) {
        NSLog(@"CAuthStorage#saveToken : Save token for %@", authToken.domain);
    }
    else {
        NSLog(@"CAuthStorage#saveToken : Failed");
    }
}

#pragma mark - Private

- (void)execSelfChecking {
    NSString * sql = @"CREATE TABLE IF NOT EXISTS `token` (`sn` INTEGER PRIMARY KEY AUTOINCREMENT, `domain` TEXT, `app_key` TEXT, `cid` BIGINT DEFAULT 0, `data` TEXT)";

    if ([db executeUpdate:sql]) {
        NSLog(@"CAuthStorage#execSelfChecking : create token table");
    }
    else {
        NSLog(@"CAuthStorage#execSelfChecking");
    }
}

@end
