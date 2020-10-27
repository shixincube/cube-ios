//
//  MessageKitCellDelegate.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageKitLabelDelegate.h"
@class MessageKitCollectionViewCell;
@class MessageKitAudioMessageCell;

/// A protocol used by `MessageContentCell` subclasses to detect taps in the cell's subviews.
@protocol MessageKitCellDelegate <MessageKitLabelDelegate>

/// Triggered when a tap occurs in the background of the cell.
- (void)didTapBackground:(__kindof MessageKitCollectionViewCell *)cell;

/// Triggered when a tap occurs in the `MessageContainerView`.
- (void)didTapMessage:(__kindof MessageKitCollectionViewCell *)cell;

/// Triggered when a tap occurs in the `AvatarView`.
- (void)didTapAvatar:(__kindof MessageKitCollectionViewCell *)cell;

/// Triggered when a tap occurs in the cellTopLabel.
- (void)didTapCellTopLabel:(__kindof MessageKitCollectionViewCell *)cell;

/// Triggered when a tap occurs in the cellBottomLabel.
- (void)didTapCellBottomLabel:(__kindof MessageKitCollectionViewCell *)cell;

/// Triggered when a tap occurs in the messageTopLabel.
- (void)didTapMessageTopLabel:(__kindof MessageKitCollectionViewCell *)cell;

/// Triggered when a tap occurs in the messageBottomLabel.
- (void)didTapMessageBottomLabel:(__kindof MessageKitCollectionViewCell *)cell;

/// Triggered when a tap occurs in the accessoryView.
- (void)didTapAccessoryView:(__kindof MessageKitCollectionViewCell *)cell;

/// Triggered when a tap occurs on the image.
- (void)didTapImage:(__kindof MessageKitCollectionViewCell *)cell;

/// Triggered when a tap occurs on the play button from audio cell.
- (void)didTapPlayButton:(__kindof MessageKitAudioMessageCell *)cell;

/// Triggered when audio player start playing audio.
- (void)didStartAudio:(__kindof MessageKitAudioMessageCell *)cell;

/// Triggered when audio player pause audio.
- (void)didPauseAudio:(__kindof MessageKitAudioMessageCell *)cell;

/// Triggered when audio player stoped audio.
- (void)didStopAudio:(__kindof MessageKitAudioMessageCell *)cell;



@end
