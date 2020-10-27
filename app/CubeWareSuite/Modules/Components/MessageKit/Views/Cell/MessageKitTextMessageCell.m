//
//  MessageKitTextMessageCell.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "MessageKitTextMessageCell.h"

@implementation MessageKitTextMessageCell


#pragma mark - Getter
-(MessageKitMessageLabel *)messageLabel{
    if (_messageLabel) {
        _messageLabel = [[MessageKitMessageLabel alloc] init];
    }
    return _messageLabel;
}


#pragma mark - Override method

-(void)setDelegate:(id<MessageKitCellDelegate>)delegate{
    [super setDelegate:delegate];
    self.messageLabel.delegate = delegate;
}

-(void)applyLayoutAttributes:(MessageKitCollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    if ([layoutAttributes isKindOfClass:[MessageKitCollectionViewLayoutAttributes class]]) {
        self.messageLabel.textInsets = layoutAttributes.messageLabelInsets;
        self.messageLabel.messageLabelFont = layoutAttributes.messageLabelFont;
        self.frame = self.contentView.bounds;
    }
}

-(void)prepareForReuse{
    [super prepareForReuse];
    self.messageLabel.text = nil;
    self.messageLabel.attributedText = nil;
}

-(void)setupSubviews{
    [super setupSubviews];
    [self.containerView addSubview:self.messageLabel];
}

-(void)configureWithMessage:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath collectionView:(MessageKitCollectionView *)messageCollectionView{
    [super configureWithMessage:message atIndexPath:indexPath collectionView:messageCollectionView];
    
    id <MessageKitDisplayDelegate> displayDelegate = messageCollectionView.displayDelegate;
    NSAssert(displayDelegate, @"nilMessagesDisplayDelegate");
    
    NSArray *enabledDetectors = [displayDelegate enabledDetectors:message atIndexPath:indexPath inCollectionView:messageCollectionView];
    
    [self.messageLabel configure:^{
        self.messageLabel.enabledDetectors = enabledDetectors;
        for (MessageKitDetectorType *detector in enabledDetectors) {
            NSDictionary *attributes = [displayDelegate detectorAttributes:detector message:message atIndexPath:indexPath];
            [self.messageLabel setAttributes:attributes detector:detector];
        }
        
        
        if (message.kind.kind == MKMessageKind_text || message.kind.kind == MKMessageKind_emoji) {
            UIColor *textColor = [displayDelegate textColor:message atIndexPath:indexPath inCollectionView:messageCollectionView];
            self.messageLabel.text = message.kind.kindObject;
            self.messageLabel.textColor = textColor;
            if (self.messageLabel.messageLabelFont) {
                self.messageLabel.font = self.messageLabel.messageLabelFont;
            }
        }
        else if (message.kind.kind == MKMessageKind_attributedText){
            self.messageLabel.attributedText = message.kind.kindObject;
        }
    }];
}

-(BOOL)cellContentViewCanHandle:(CGPoint)touchPoint{
//    return self.messageLabel.han
    return YES;
}

@end
