//
//  MessageKitAvatarPosition.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/25.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


/// An enum representing the horizontal alignment of an `AvatarView`.
typedef enum : NSUInteger {
    /// Positions the `AvatarView` on the side closest to the cell's leading edge.
    avatar_cellLeading,
    
    /// Positions the `AvatarView` on the side closest to the cell's trailing edge.
    avatar_cellTrailing,
    
    /// Positions the `AvatarView` based on whether the message is from the current Sender.
    /// The cell is positioned `.cellTrailling` if `isFromCurrentSender` is true
    /// and `.cellLeading` if false.
    avatar_natural,
    
} MKAvatarHorizontal;

/// An enum representing the verical alignment for an `AvatarView`.
typedef enum : NSUInteger {
    /// Aligns the `AvatarView`'s top edge to the cell's top edge.
    avatar_cellTop,
    
    /// Aligns the `AvatarView`'s top edge to the `messageTopLabel`'s top edge.
    avatar_messageLabelTop,
    
    /// Aligns the `AvatarView`'s top edge to the `MessageContainerView`'s top edge.
    avatar_messageTop,
    
    /// Aligns the `AvatarView` center to the `MessageContainerView` center.
    avatar_messageCenter,
    
    /// Aligns the `AvatarView`'s bottom edge to the `MessageContainerView`s bottom edge.
    avatar_messageBottom,
    
    /// Aligns the `AvatarView`'s bottom edge to the cell's bottom edge.
    avatar_cellBottom
    
} MKAvatarVertical;


@interface MessageKitAvatarPosition : NSObject

@property (nonatomic , assign) MKAvatarHorizontal horizontal;

@property (nonatomic , assign) MKAvatarVertical vertical;

@end

NS_ASSUME_NONNULL_END
