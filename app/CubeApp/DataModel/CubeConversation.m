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

#import "CubeConversation.h"
#import "CubeAccount.h"
#import "CubeAccountHelper.h"

@interface CubeConversation ()

@end

@implementation CubeConversation

@synthesize conversation = _conversation;
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
        _unread = 0;//[[CEngine sharedInstance].messagingService countUnreadByMessage:self.message];
    }
    return _unread;
}

- (void)clearUnread {
    _unread = 0;

//    [[CEngine sharedInstance].messagingService markReadByContact:self.message.partner handleSuccess:^(id  _Nullable data) {
//        // 标记成功
//        NSLog(@"Mark messages (%ld) read", ((NSArray *)data).count);
//    } handleFailure:^(CError * _Nullable error) {
//        // 标记失败
//        NSLog(@"Mark message read failed");
//    }];
}

- (void)reset:(CConversation *)conversation {
    _unread = -1;

    _conversation = conversation;

    if (conversation.type == CConversationTypeGroup) {
        // TODO 群组数据
    }
    else if (conversation.type == CConversationTypeContact) {
        self.avatarName = (self.conversation.contact.context) ?
            [CubeAccount getAvatar:self.conversation.contact.context] : [CubeAccountHelper sharedInstance].defaultAvatarImageName;
    }

    // 头像处理
    self.avatarName = [CubeAccountHelper explainAvatar:self.avatarName];
}

#pragma mark - Getters

- (NSString *)badgeValue {
    if ([self isRead]) {
        return nil;
    }

    if (_conversation.type == CConversationTypeContact || _conversation.type == CConversationTypeGroup) {
        return self.unread <= 99 ? [NSString stringWithFormat:@"%ld", self.unread] : @"99+";
    }
    else {
        return @"";
    }
}

+ (CubeConversation *)conversationWithConversation:(CConversation *)conversation {
    CubeConversation * conv = [[CubeConversation alloc] init];
    [conv reset:conversation];
    return conv;
}

@end
