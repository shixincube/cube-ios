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

#ifndef CContactZoneParticipant_h
#define CContactZoneParticipant_h

#import "CEntity.h"

@class CContact;

/*!
 * @brief 联系人分区成员状态。
 */
typedef enum _CContactZoneParticipantState {

    /*! 正常状态。 */
    CContactZoneParticipantStateNormal = 0,

    /*! 待处理状态。 */
    CContactZoneParticipantStatePending = 1

} CContactZoneParticipantState;


/*!
 * @brief 联系人分区参与人。
 */
@interface CContactZoneParticipant : CEntity


@property (nonatomic, assign, readonly) UInt64 contactId;


@property (nonatomic, assign, readonly) CContactZoneParticipantState state;


@property (nonatomic, strong, readonly) NSString * postscript;


@property (nonatomic, strong) CContact * contact;


- (instancetype)initWithContactId:(UInt64)contactId timestamp:(UInt64)timestamp state:(CContactZoneParticipantState)state postscript:(NSString *)postscript;

- (instancetype)initWithJSON:(NSDictionary *)json;

@end

#endif /* CContactZoneParticipant_h */
