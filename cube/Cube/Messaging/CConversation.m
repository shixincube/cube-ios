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

#import "CConversation.h"
#import "CMessage.h"
#import "CContact.h"
#import "CGroup.h"

@interface CConversation () {
    NSDate * _date;
}

@end

@implementation CConversation

- (instancetype)initWithJSON:(NSDictionary *)json {
    if (self = [super initWithJSON:json]) {
        _type = [[json valueForKey:@"type"] integerValue];
        _state = [[json valueForKey:@"state"] integerValue];
        _reminding = [[json valueForKey:@"remind"] integerValue];
        _pivotalId = [[json valueForKey:@"pivotal"] unsignedLongLongValue];

        NSDictionary * messageJson = [json valueForKey:@"recentMessage"];
        _recentMessage = [[CMessage alloc] initWithJSON:messageJson];

        if ([json objectForKey:@"avatarName"]) {
            _avatarName = [json valueForKey:@"avatarName"];
        }
        if ([json objectForKey:@"avatarURL"]) {
            _avatarURL = [json valueForKey:@"avatarURL"];
        }

        double time = ((double)self.timestamp / 1000.0f);
        _date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    }

    return self;
}

- (instancetype)initWithId:(UInt64)identity
                 timestamp:(UInt64)timestamp
                      type:(CConversationType)type
                     state:(CConversationState)state
                 pivotalId:(UInt64)pivotalId
             recentMessage:(CMessage *)recentMessage
                 reminding:(CConversationReminding)reminding {
    if (self = [super initWithId:identity timestamp:timestamp]) {
        _type = type;
        _state = state;
        _pivotalId = pivotalId;
        _recentMessage = recentMessage;
        _reminding = reminding;

        double time = ((double)self.timestamp / 1000.0f);
        _date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    }

    return self;
}

- (BOOL)isFocus:(CMessage *)message {
    if (CConversationTypeContact == _type && ![message isFromGroup]) {
        if (message.partner.identity == _pivotalId) {
            return TRUE;
        }
    }
    else if (CConversationTypeGroup == _type && [message isFromGroup]) {
        // TODO
    }

    return FALSE;
}

- (void)setPivotalWithContact:(CContact *)contact {
    _contact = contact;
}

- (void)setPivotalWithGroup:(CGroup *)group {
    _group = group;
}

- (void)resetRecentMessage:(CMessage *)message {
    _recentMessage = message;
}

#pragma mark - Getters

- (NSString *)displayName {
    if (CConversationTypeContact == _type && _contact) {
        return [_contact getPriorityName];
    }
    else if (CConversationTypeGroup == _type && _group) {
        return [_group getPriorityName];
    }
    else {
        return @"";
    }
}

- (NSDate *)date {
    return _date;
}

- (NSString *)recentSummary {
    return _recentMessage.summary;
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [super toCompactJSON];
    [json setValue:[NSNumber numberWithInteger:_type] forKey:@"type"];
    [json setValue:[NSNumber numberWithInteger:_state] forKey:@"state"];
    [json setValue:[NSNumber numberWithInteger:_reminding] forKey:@"reminding"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_pivotalId] forKey:@"pivotal"];
    [json setValue:[_recentMessage toJSON] forKey:@"recentMessage"];
    return json;
}

- (NSMutableDictionary *)toCompactJSON {
    NSMutableDictionary * json = [super toCompactJSON];
    [json setValue:[NSNumber numberWithInteger:_type] forKey:@"type"];
    [json setValue:[NSNumber numberWithInteger:_state] forKey:@"state"];
    [json setValue:[NSNumber numberWithInteger:_reminding] forKey:@"reminding"];
    [json setValue:[NSNumber numberWithUnsignedLongLong:_pivotalId] forKey:@"pivotal"];
    return json;
}

@end
