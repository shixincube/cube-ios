//
//  MessageKitCollectionViewLayoutAttributes.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/25.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <UIKit/UIKit.h>

/////////////////////////////////// models //////////////////////////////
#import "MessageKitAvatarPosition.h"
#import "MessageKitLabelAlignment.h"
#import "MessageKitHorizontalEdgeInsets.h"
#import "MessageKitAccessoryPosition.h"
#import "MessageKitLinkPreviewFonts.h"

NS_ASSUME_NONNULL_BEGIN

/// The layout attributes used by a `MessageCollectionViewCell` to layout its subviews.

@interface MessageKitCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic , assign) CGSize avatarSize;

@property (nonatomic , strong) MessageKitAvatarPosition *avatarPosition;

@property (nonatomic , assign) CGFloat avatarLeadingTrailingPadding;

@property (nonatomic , assign) CGSize messageContainerSize;

@property (nonatomic , assign) UIEdgeInsets messageContainerPadding;

@property (nonatomic , strong) UIFont *messageLabelFont;

@property (nonatomic , assign) UIEdgeInsets messageLabelInsets;

@property (nonatomic , strong) MessageKitLabelAlignment *cellTopLabelAlignment;

@property (nonatomic , assign) CGSize cellTopLabelSize;

@property (nonatomic , strong) MessageKitLabelAlignment *cellBottomLabelAlignment;

@property (nonatomic , assign) CGSize cellBottomLabelSize;

@property (nonatomic , strong) MessageKitLabelAlignment *messageTopLabelAlignment;

@property (nonatomic , assign) CGSize messageTopLabelSize;

@property (nonatomic , strong) MessageKitLabelAlignment *messageBottomLabelAlignment;

@property (nonatomic , assign) CGSize messageBottomLabelSize;

@property (nonatomic , assign) CGSize messageTimeLabelSize;

@property (nonatomic , assign) CGSize accessoryViewSize;

@property (nonatomic , strong) MessageKitHorizontalEdgeInsets *accessoryViewPadding;

@property (nonatomic , assign) MessageKitAccessoryPosition accessoryViewPosition;

@property (nonatomic , strong) MessageKitLinkPreviewFonts *linkPreviewFonts;


@end

NS_ASSUME_NONNULL_END
