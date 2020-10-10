//
//  MessageKitDataSource.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/15.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MessageKitCollectionView;

#import "MessageKitSenderType.h"
#import "MessageKitMessageType.h"
#import "MessageKitDisplayDelegate.h"
#import "MessageKitLayoutDelegate.h"

@protocol MessageKitDataSource <NSObject>

@required

/// The `SenderType` of new messages in the `MessagesCollectionView`.
- (id <MessageKitSenderType> )currentSender;

/// A helper method to determine if a given message is from the current `SenderType`.
- (BOOL)isFromCurrentSender:(id<MessageKitMessageType>)message;

/// The message to be used for a `MessageCollectionViewCell` at the given `IndexPath`.
- (id <MessageKitMessageType>)messageForItemAtIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)collectionView;

/// The number of sections to be displayed in the `MessagesCollectionView`.
- (int)numberOfSectionInCollectionView:(MessageKitCollectionView *)collectionView;

/// The number of cells to be displayed in the `MessagesCollectionView`.
- (int)numberOfItemsInSection:(int)section inCollectionView:(MessageKitCollectionView *)collectionView;

/// The attributed text to be used for cell's top label.
- (NSAttributedString *)cellTopLabelAttributedText:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath;

/// The attributed text to be used for cell's bottom label.
- (NSAttributedString *)cellBottomLabelAttributedText:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath;

/// The attributed text to be used for message bubble's top label.
- (NSAttributedString *)messageTopLabelAttributedText:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath;

/// The attributed text to be used for cell's bottom label.
- (NSAttributedString *)messageBottomLabelAttributedText:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath;

/// The attributed text to be used for cell's timestamp label.
- (NSAttributedString *)messageTimestampLabelAttributedText:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath;

@optional

/// Custom collectionView cell for message with `custom` message type.
- (__kindof UICollectionViewCell *)customCell:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)collectionView;

/// Typing indicator cell used when the indicator is set to be shown
- (__kindof UICollectionViewCell *)typingIndicatorAtIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)collectionView;

@end

