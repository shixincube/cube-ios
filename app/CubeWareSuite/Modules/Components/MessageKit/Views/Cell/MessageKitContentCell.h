//
//  MessageKitContentCell.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "MessageKitCollectionViewCell.h"

/////////////////////////////////// cell components //////////////////////////////
#import "MessageKitAvatarView.h"
#import "MessageKitContainterView.h"
#import "MessageKitInsetLabel.h"
#import "MessageKitCollectionView.h"

/////////////////////////////////// delegate //////////////////////////////
#import "MessageKitCellDelegate.h"
#import "MessageKitMessageType.h"

#import "MessageKitCollectionViewLayoutAttributes.h"



NS_ASSUME_NONNULL_BEGIN

@interface MessageKitContentCell : MessageKitCollectionViewCell

/// The image view displaying the avatar.
@property (nonatomic , strong) MessageKitAvatarView *avatarView;

/// The container used for styling and holding the message's content view.
@property (nonatomic , strong) MessageKitContainterView *containerView;

/// The top label of the cell.
@property (nonatomic , strong) MessageKitInsetLabel *cellTopLabel;

/// The bottom label of the cell.
@property (nonatomic , strong) MessageKitInsetLabel *cellBottomLabel;

/// The top label of the messageBubble.
@property (nonatomic , strong) MessageKitInsetLabel *messageTopLabel;

/// The bottom label of the messageBubble.
@property (nonatomic , strong) MessageKitInsetLabel *messageBottomLabel;

/// The time label of the messageBubble.
@property (nonatomic , strong) MessageKitInsetLabel *messageTimestampLabel;

// Should only add customized subviews - don't change accessoryView itself.
@property (nonatomic , strong) UIView *accessoryView;

/// The `MessageCellDelegate` for the cell.
@property (nonatomic , weak) id <MessageKitCellDelegate> delegate;

@end

@interface MessageKitContentCell (UISubclassingHooks)

- (void)setupSubviews NS_REQUIRES_SUPER;

-(void)prepareForReuse NS_REQUIRES_SUPER;

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes NS_REQUIRES_SUPER;

/// Used to configure the cell.
- (void)configureWithMessage:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath collectionView:(MessageKitCollectionView *)messageCollectionView NS_REQUIRES_SUPER;

/// Handle `ContentView`'s tap gesture, return false when `ContentView` doesn't needs to handle gesture
- (BOOL)cellContentViewCanHandle:(CGPoint )touchPoint;

@end

NS_ASSUME_NONNULL_END
