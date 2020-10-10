//
//  MessageKitDisplayDelegate.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/15.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

/////////////////////////////////// delegate //////////////////////////////
#import "MessageKitMessageType.h"

/////////////////////////////////// view //////////////////////////////
#import "MessageKitCollectionView.h"
#import "MessageKitReusableView.h"
#import "MessageKitAvatarView.h"
//#import "MessageKitAudioMessageCell.h"
@class MessageKitAudioMessageCell;

/////////////////////////////////// model //////////////////////////////
#import "MessageKitMessageStyle.h"
#import "MessageKitDetectorType.h"


/// A protocol used by the `MessagesViewController` to customize the appearance of a `MessageContentCell`.
@protocol MessageKitDisplayDelegate <NSObject>

#pragma mark - All Message

/// Specifies the `MessageStyle` to be used for a `MessageContainerView`.
- (MessageKitMessageStyle *)messageStyle:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)messageCollectionView;

/// Specifies the background color of the `MessageContainerView`.
- (UIColor *)backgroundColor:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)messageCollectionView;

/// The section header to use for a given `IndexPath`.
- (MessageKitReusableView *)messageHeaderViewForIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)messageCollectionView;

/// The section footer to use for a given `IndexPath`.
- (MessageKitReusableView *)messageFooterViewForIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)messageCollectionView;

/// Used to configure the `AvatarView`‘s image in a `MessageContentCell` class.
- (void)configureAvatarView:(MessageKitAvatarView *)avatarView message:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)messageCollectionView;

/// Used to configure the `AccessoryView` in a `MessageContentCell` class.
- (void)configureAccessoryView:(UIView *)accessoryView message:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)messageCollectionView;

#pragma mark - Text Message

/// Specifies the color of the text for a `TextMessageCell`.
- (UIColor *)textColor:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)messageCollectionView;

/// Specifies the `DetectorType`s to check for the `MessageType`'s text against.
- (NSArray <MessageKitDetectorType *> *)enabledDetectors:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)messageCollectionView;

/// Specifies the attributes for a given `DetectorType`
- (NSDictionary *)detectorAttributes:(MessageKitDetectorType *)detectorType message:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath;


#pragma mark - Media Message

/// Used to configure the `UIImageView` of a `MediaMessageCell`.
- (void)configureMediaMessageImageView:(UIImageView *)imageView message:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)messageCollectionView;


#pragma mark - Audio Message

/// Used to configure the audio cell UI:
- (void)configureAudioCell:(MessageKitAudioMessageCell *)cell message:(id<MessageKitMessageType>)message;

/// Specifies the tint color of play button and progress bar for an `AudioMessageCell`.
- (UIColor *)audioTintColor:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)messageCollectionView;

/// Used to format the audio sound duration in a readable string
- (NSString *)audioProgressTextFormat:(CGFloat)duration audioCell:(MessageKitAudioMessageCell *)audioCell inCollectionView:(MessageKitCollectionView *)messageCollectionView;

/// Used to configure the `UIImageView` of a `LinkPreviewMessageCell`.
- (void)configureLinkPreviewImageView:(UIImageView *)imageView message:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)messageCollectionView;


@end
