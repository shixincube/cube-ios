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

#import "CContactZone.h"
#import "CContactZoneParticipant.h"
#import "CContact.h"

@interface CContactZone () {
    NSMutableArray<__kindof CContactZoneParticipant *> * _participantList;
}

@end


@implementation CContactZone

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super init]) {
        _identity = [[json valueForKey:@"id"] unsignedLongLongValue];
        _name = [json valueForKey:@"name"];
        _displayName = [json valueForKey:@"displayName"];
        _timestamp = [[json valueForKey:@"timestamp"] unsignedLongLongValue];
        _state = [[json valueForKey:@"state"] intValue];

        _participantList = [[NSMutableArray alloc] init];

        if ([json objectForKey:@"participants"]) {
            NSArray * array = [json valueForKey:@"participants"];
            for (NSDictionary * data in array) {
                CContactZoneParticipant * participant = [[CContactZoneParticipant alloc] initWithJSON:data];
                [_participantList addObject:participant];
            }
        }
    }

    return self;
}

- (instancetype)initWithId:(UInt64)identity name:(NSString *)name displayName:(NSString *)displayName timestamp:(UInt64)timestamp state:(CContactZoneState)state {
    if (self = [super init]) {
        _identity = identity;
        _name = name;
        _displayName = displayName;
        _timestamp = timestamp;
        _state = state;

        _participantList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (BOOL)addContact:(CContactZoneParticipant *)participant {
    for (CContactZoneParticipant * item in _participantList) {
        if (item.contactId == participant.contactId) {
            return FALSE;
        }
    }

    [_participantList addObject:participant];
    return TRUE;
}

- (void)matchContact:(CContact *)contact {
    for (CContactZoneParticipant * item in _participantList) {
        if (item.contactId == contact.identity) {
            item.contact = contact;
            break;
        }
    }
}

#pragma mark - Getters

- (NSArray<__kindof CContactZoneParticipant *> *)participants {
    return _participantList;
}

@end
