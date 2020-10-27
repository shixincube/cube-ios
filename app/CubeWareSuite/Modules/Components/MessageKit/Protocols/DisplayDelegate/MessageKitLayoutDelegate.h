//
//  MessageKitLayoutDelegate.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/15.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "MessageKitCollectionView.h"

/// A protocol used by the `MessagesCollectionViewFlowLayout` object to determine
/// the size and layout of a `MessageCollectionViewCell` and its contents.

@protocol MessageKitLayoutDelegate <NSObject>

/// Specifies the size to use for a header view.
- (CGSize)headerViewSizeForSection:(int)section inCollectionView:(MessageKitCollectionView *)collectionView;

/// Specifies the size to use for a footer view.
- (CGSize)footerViewSizeForSection:(int)section inCollectionView:(MessageKitCollectionView *)collectionView;

/// Specifies the size to use for a typing indicator view.
- (CGSize)typingIndicatorViewSizeInCollectionView:(MessageKitCollectionView *)collectionView;

/// Specifies the top inset to use for a typing indicator view.
- (CGFloat)typingIndicatorViewTopInsetInCollectionView:(MessageKitCollectionView *)collectionView;

/// Specifies the height for the `MessageContentCell`'s top label.
- (CGFloat)cellTopLabelHeight:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)collectionView;

/// Specifies the height for the `MessageContentCell`'s bottom label.
- (CGFloat)cellBottomLabelHeight:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)collectionView;

/// Specifies the height for the message bubble's top label.
- (CGFloat)messageTopLabelHeight:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)collectionView;

/// Specifies the height for the `MessageContentCell`'s bottom label.
- (CGFloat)messageBottomLabelHeight:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath inCollectionView:(MessageKitCollectionView *)collectionView;

/// Custom cell size calculator for messages with MessageType.custom.
//- ()

@end
