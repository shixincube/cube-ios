//
//  MessageKitCollectionViewLayoutAttributes.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/25.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "MessageKitCollectionViewLayoutAttributes.h"

@implementation MessageKitCollectionViewLayoutAttributes

#pragma mark - Getter

// TODO: add models initialize method

-(MessageKitAvatarPosition *)avatarPosition{
    if (!_avatarPosition) {
        _avatarPosition = [[MessageKitAvatarPosition alloc] init];
    }
    return _avatarPosition;
}

-(UIFont *)messageLabelFont{
    if (!_messageLabelFont) {
        _messageLabelFont = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    }
    return _messageLabelFont;
}

-(MessageKitLabelAlignment *)cellTopLabelAlignment{
    if (!_cellTopLabelAlignment) {
        _cellTopLabelAlignment = [[MessageKitLabelAlignment alloc] init];
    }
    return _cellTopLabelAlignment;
}

-(MessageKitLabelAlignment *)cellBottomLabelAlignment{
    if (!_cellBottomLabelAlignment) {
        _cellBottomLabelAlignment = [[MessageKitLabelAlignment alloc] init];
    }
    return _cellBottomLabelAlignment;
}

-(MessageKitLabelAlignment *)messageTopLabelAlignment{
    if (!_messageTopLabelAlignment) {
        _messageTopLabelAlignment = [[MessageKitLabelAlignment alloc] init];
    }
    return _messageTopLabelAlignment;
}

-(MessageKitLabelAlignment *)messageBottomLabelAlignment{
    if (!_messageBottomLabelAlignment) {
        _messageBottomLabelAlignment = [[MessageKitLabelAlignment alloc] init];
    }
    return _messageBottomLabelAlignment;
}

-(MessageKitHorizontalEdgeInsets *)accessoryViewPadding{
    if (_accessoryViewPadding) {
        _accessoryViewPadding = [[MessageKitHorizontalEdgeInsets alloc] init];
    }
    return _accessoryViewPadding;
}

//-(MessageKitAccessoryPosition *)accessoryViewPosition{
//    if (!_accessoryViewPosition) {
//        _accessoryViewPosition = [[MessageKitAccessoryPosition alloc] init];
//    }
//    return _accessoryViewPosition;
//}

-(MessageKitLinkPreviewFonts *)linkPreviewFonts{
    if (!_linkPreviewFonts) {
        _linkPreviewFonts = [[MessageKitLinkPreviewFonts alloc] init];
    }
    return _linkPreviewFonts;
}


#pragma mark - Override method

-(id)copyWithZone:(NSZone *)zone{
    MessageKitCollectionViewLayoutAttributes *copy = [super copyWithZone:zone];
    /**/
    copy.avatarSize = self.avatarSize;
    copy.avatarPosition = self.avatarPosition;
    copy.avatarLeadingTrailingPadding = self.avatarLeadingTrailingPadding;
    copy.messageContainerSize = self.messageContainerSize;
    copy.messageContainerPadding = self.messageContainerPadding;
    copy.messageLabelFont = self.messageLabelFont;
    copy.messageLabelInsets = self.messageLabelInsets;
    copy.cellTopLabelAlignment = self.cellTopLabelAlignment;
    copy.cellTopLabelSize = self.cellTopLabelSize;
    copy.cellBottomLabelAlignment = self.cellBottomLabelAlignment;
    copy.cellBottomLabelSize = self.cellBottomLabelSize;
    copy.messageTimeLabelSize = self.messageTimeLabelSize;
    copy.messageTopLabelAlignment = self.messageTopLabelAlignment;
    copy.messageTopLabelSize = self.messageTopLabelSize;
    copy.messageBottomLabelAlignment = self.messageBottomLabelAlignment;
    copy.messageBottomLabelSize = self.messageBottomLabelSize;
    copy.accessoryViewSize = self.accessoryViewSize;
    copy.accessoryViewPadding = self.accessoryViewPadding;
    copy.accessoryViewPosition = self.accessoryViewPosition;
    copy.linkPreviewFonts = self.linkPreviewFonts;
    return copy;
}

-(BOOL)isEqual:(id)object{
    MessageKitCollectionViewLayoutAttributes *attributes = (MessageKitCollectionViewLayoutAttributes *)object;
    if ([object isKindOfClass:[MessageKitCollectionViewLayoutAttributes class]]) {
        return [super isEqual:object] && CGSizeEqualToSize(attributes.avatarSize, self.avatarSize)
        && attributes.avatarLeadingTrailingPadding == self.avatarLeadingTrailingPadding
        && CGSizeEqualToSize(attributes.messageContainerSize ,self.messageContainerSize)
        && UIEdgeInsetsEqualToEdgeInsets(attributes.messageContainerPadding, self.messageContainerPadding)
        && [attributes.messageLabelFont isEqual:self.messageLabelFont]
        && UIEdgeInsetsEqualToEdgeInsets(attributes.messageLabelInsets, self.messageLabelInsets)
        && [attributes.cellTopLabelAlignment isEqual:self.cellTopLabelAlignment]
        && CGSizeEqualToSize(attributes.cellTopLabelSize, self.cellTopLabelSize)
        && [attributes.cellBottomLabelAlignment isEqual:self.cellBottomLabelAlignment]
        && CGSizeEqualToSize(attributes.cellBottomLabelSize, self.cellBottomLabelSize)
        && CGSizeEqualToSize(attributes.messageTimeLabelSize, self.messageTimeLabelSize)
        && [attributes.messageTopLabelAlignment isEqual:self.messageTopLabelAlignment]
        && CGSizeEqualToSize(attributes.messageTopLabelSize, self.messageTopLabelSize)
        && [attributes.messageBottomLabelAlignment isEqual:self.messageBottomLabelAlignment]
        && CGSizeEqualToSize(attributes.messageBottomLabelSize, self.messageBottomLabelSize)
        && CGSizeEqualToSize(attributes.accessoryViewSize, self.accessoryViewSize)
        && attributes.accessoryViewPadding == self.accessoryViewPadding
        && attributes.accessoryViewPosition == self.accessoryViewPosition
        && [attributes.linkPreviewFonts isEqual:self.linkPreviewFonts];
    }
    return NO;
}

@end
