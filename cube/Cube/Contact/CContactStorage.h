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

#ifndef CContactStorage_h
#define CContactStorage_h

#import "CContact.h"
#import "CContactZone.h"
#import "CContactZoneParticipant.h"

@class CContactService;

/*!
 * @brief 联系人模块存储器。
 */
@interface CContactStorage : NSObject

/*!
 * @brief 初始化。
 */
- (instancetype)initWithService:(CContactService *)service;

/*!
 * @brief 开启存储器。
 * @param contactId 指定联系人 ID 。
 * @param domain 指定域。
 * @return 开启成功返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)open:(UInt64)contactId domain:(NSString *)domain;

/*!
 * @brief 关闭存储器。
 */
- (void)close;

/*!
 * @brief 读取指定 ID 的联系人。
 * @param contactId 指定联系人 ID 。
 * @return 找到指定联系人返回 @c CContact 实例，否则返回 @c nil 值。
 */
- (CContact *)readContact:(UInt64)contactId;

/*!
 * @brief 写入指定联系人数据。
 * @param contact 指定联系人数据实例。
 * @return 写入成功返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)writeContact:(CContact *)contact;

/*!
 * @brief 更新联系人上下文。
 * @param contactId 联系人 ID 。
 * @param context 联系人上下文。
 * @return 返回更新后的时间戳。
 */
- (UInt64)updateContactContext:(UInt64)contactId context:(NSDictionary *)context;

/*!
 * @brief 更新联系人名称。
 */
- (void)updateContactName:(UInt64)contactId name:(NSString *)name;

/*!
 * @brief 写入联系人附件数据。
 */
- (BOOL)writeContactAppendix:(CContactAppendix *)appendix;

/*!
 * @brief 读取指定名称的联系人分区。
 */
- (CContactZone *)readContactZone:(NSString *)zoneName;

/*!
 * @brief 写入联系人分区数据。
 */
- (void)writeContactZone:(CContactZone *)zone;

@end

#endif /* CContactStorage_h */
