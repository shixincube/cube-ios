//
//  MessageKitMessageType.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/15.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageKitSenderType.h"
#import "MessageKitMessageKind.h"


@protocol MessageKitMessageType <NSObject>

/// The sender of the message.
- (id<MessageKitSenderType>)senderType;

/// The unique identifier for the message.
- (NSString *)messageId;

/// The date the message was sent.
- (NSDate *)sentDate;

/// The kind of message and its underlying kind.
- (MessageKitMessageKind *)kind;


@end
