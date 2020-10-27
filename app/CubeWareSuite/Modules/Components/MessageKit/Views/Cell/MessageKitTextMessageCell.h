//
//  MessageKitTextMessageCell.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "MessageKitContentCell.h"

#import "MessageKitMessageLabel.h"

NS_ASSUME_NONNULL_BEGIN

/// A subclass of `MessageContentCell` used to display text messages.
@interface MessageKitTextMessageCell : MessageKitContentCell

@property (nonatomic , strong) MessageKitMessageLabel *messageLabel;

@end

NS_ASSUME_NONNULL_END
