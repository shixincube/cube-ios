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

#ifndef CContactZone_h
#define CContactZone_h

#import "CJSONable.h"

@class CContact;
@class CContactZoneParticipant;

/*!
 * @brief 联系人分区状态。
 */
typedef enum _CContactZoneState {

    /*!
     * 正常状态。
     */
    CContactZoneStateNormal = 0,

    /*!
     * 已移除。
     */
    CContactZoneStateDeleted = 1

} CContactZoneState;


/*!
 * @brief 联系人分区数据。
 */
@interface CContactZone : CJSONable

@property (nonatomic, assign, readonly) UInt64 identity;

@property (nonatomic, strong, readonly) NSString * name;

@property (nonatomic, strong, readonly) NSString * displayName;

@property (nonatomic, assign, readonly) UInt64 timestamp;

@property (nonatomic, assign, readonly) CContactZoneState state;

@property (nonatomic, readonly) NSArray<__kindof CContactZoneParticipant *> * participants;

/*!
 * @brief 返回联系人名称按照拼音/英文字母序排序的联系人列表。
 */
@property (nonatomic, readonly) NSArray<__kindof CContactZoneParticipant *> * orderedParticipants;

@property (nonatomic, readonly) NSUInteger count;

- (instancetype)initWithJSON:(NSDictionary *)json;

- (instancetype)initWithId:(UInt64)identity name:(NSString *)name displayName:(NSString *)displayName timestamp:(UInt64)timestamp state:(CContactZoneState)state;

- (BOOL)addContact:(CContactZoneParticipant *)participant;

- (void)matchContact:(CContact *)contact;

@end

#endif /* CContactZone_h */
