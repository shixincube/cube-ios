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

#import "CubeConversation.h"
#import "CubeAccount.h"
#import "CubeAccountHelper.h"
#import "CubeAppUtil.h"

@interface CubeConversation ()

@property (nonatomic, strong) CMessage * message;

@end

@implementation CubeConversation

@synthesize unread = _unread;

- (instancetype)init {
    if (self = [super init]) {
        _unread = -1;
    }
    return self;
}

- (BOOL)isRead {
    return self.unread == 0;
}

- (NSInteger)unread {
    if (_unread < 0) {
        _unread = [[CEngine sharedInstance].messagingService countUnreadWithMessage:self.message];
    }
    return _unread;
}

- (void)clearUnread {
    _unread = 0;
}

#pragma mark - Getters

- (NSString *)badgeValue {
    if ([self isRead]) {
        return nil;
    }

    if (self.type == CubeConversationTypeContact || self.type == CubeConversationTypeGroup) {
        return self.unread <= 99 ? [NSString stringWithFormat:@"%ld", self.unread] : @"99+";
    }
    else {
        return @"";
    }
}

+ (CubeConversation *)conversationWithMessage:(CMessage *)message currentOwner:(CSelf *)owner {
    CubeConversation * conversation = [[CubeConversation alloc] init];
    conversation.message = message;

    if ([message isFromGroup]) {
        conversation.type = CubeConversationTypeGroup;
        conversation.identity = message.source;
        conversation.group = message.sourceGroup;
        // TODO 群组数据
//        conversation.displayName = message.sourceGroup.name;
    }
    else {
        conversation.type = CubeConversationTypeContact;
        if (message.from == owner.identity) {
            // “我”是发件人
            conversation.identity = message.to;
            conversation.contact = message.receiver;
            conversation.displayName = [message.receiver getPriorityName];
            conversation.avatarName = message.receiver.context ? [CubeAccount getAvatar:message.receiver.context] : [CubeAccountHelper sharedInstance].defaultAvatarImageName;
        }
        else {
            // “我”是收件人
            conversation.identity = message.from;
            conversation.contact = message.sender;
            conversation.displayName = [message.sender getPriorityName];
            conversation.avatarName = message.sender.context ? [CubeAccount getAvatar:message.sender.context] : [CubeAccountHelper sharedInstance].defaultAvatarImageName;
        }
    }

    // 头像处理
    conversation.avatarName = [CubeAppUtil explainAvatarName:conversation.avatarName];

    conversation.remindType = CubeMessageRemindTypeNormal;

    // 时间
    double time = (double) message.remoteTS;
    conversation.date = [[NSDate alloc] initWithTimeIntervalSince1970:time / 1000.0f];

    // 信息摘要
    conversation.content = message.summary;

    return conversation;
}

@end
