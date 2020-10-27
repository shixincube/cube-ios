//
//  MessageKitContentCell.m
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "MessageKitContentCell.h"

#import "MessageKitDataSource.h"
#import "MessageKitDisplayDelegate.h"

@implementation MessageKitContentCell


#pragma mark - Getter
-(MessageKitAvatarView *)avatarView{
    if (!_avatarView) {
        _avatarView = [[MessageKitAvatarView alloc] init];
    }
    return _avatarView;
}

-(MessageKitContainterView *)containerView{
    if (!_containerView) {
        _containerView = [[MessageKitContainterView alloc] init];
        _containerView.clipsToBounds = YES;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

-(MessageKitInsetLabel *)cellTopLabel{
    if (!_cellTopLabel) {
        _cellTopLabel = [[MessageKitInsetLabel alloc] init];
        _cellTopLabel.numberOfLines = 0;
        _cellTopLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cellTopLabel;
}

-(MessageKitInsetLabel *)cellBottomLabel{
    if (!_cellBottomLabel) {
        _cellBottomLabel = [[MessageKitInsetLabel alloc] init];
        _cellBottomLabel.numberOfLines = 0;
        _cellBottomLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _cellBottomLabel;
}

-(MessageKitInsetLabel *)messageTopLabel{
    if (!_messageTopLabel) {
        _messageTopLabel = [[MessageKitInsetLabel alloc] init];
        _messageTopLabel.numberOfLines = 0;
    }
    return _messageTopLabel;
}

-(MessageKitInsetLabel *)messageBottomLabel{
    if (!_messageBottomLabel) {
        _messageBottomLabel = [[MessageKitInsetLabel alloc] init];
        _messageBottomLabel.numberOfLines = 0;
    }
    return _messageBottomLabel;
}

-(MessageKitInsetLabel *)messageTimestampLabel{
    if (!_messageTimestampLabel) {
        _messageTimestampLabel = [[MessageKitInsetLabel alloc] init];
    }
    return _messageTimestampLabel;
}

-(UIView *)accessoryView{
    if (!_accessoryView) {
        _accessoryView = [[UIView alloc] init];
    }
    return _accessoryView;
}

#pragma mark - initialize

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self setupSubviews];
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)coder{
    if (self = [super initWithCoder:coder]) {
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self setupSubviews];
    }
    return self;
}



#pragma mark - Gesture

/// Handle tap gesture on contentView and its subviews.
-(void)handleTapGesture:(UIGestureRecognizer *)gesture{
    CGPoint tapLocation = [gesture locationInView:self];
    
    
    if (CGRectContainsPoint(self.containerView.frame, tapLocation) && ![self cellContentViewCanHandle:[self convertPoint:tapLocation toView:self.containerView]]) {
        [self.delegate didTapMessage:self];
    }
    else if (CGRectContainsPoint(self.avatarView.frame, tapLocation)){
        [self.delegate didTapAvatar:self];
    }
    else if (CGRectContainsPoint(self.cellTopLabel.frame, tapLocation)){
        [self.delegate didTapCellTopLabel:self];
    }
    else if (CGRectContainsPoint(self.cellBottomLabel.frame, tapLocation)){
        [self.delegate didTapCellBottomLabel:self];
    }
    else if (CGRectContainsPoint(self.messageTopLabel.frame, tapLocation)){
        [self.delegate didTapMessageTopLabel:self];
    }
    else if (CGRectContainsPoint(self.messageBottomLabel.frame, tapLocation)){
        [self.delegate didTapMessageBottomLabel:self];
    }
    else if (CGRectContainsPoint(self.accessoryView.frame, tapLocation)){
        [self.delegate didTapAccessoryView:self];
    }
    else{
        [self.delegate didTapBackground:self];
    }
}


/// Handle long press gesture, return true when gestureRecognizer's touch point in `messageContainerView`'s frame
-(BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    CGPoint tapLocation = [gestureRecognizer locationInView:self];
    if (![gestureRecognizer isKindOfClass:[UILongPressGestureRecognizer class]]) {
        return NO;
    }
    return CGRectContainsPoint(self.containerView.frame, tapLocation);
}


#pragma mark - Origin Calculations

/// Positions the cell's `AvatarView`.
- (void)layoutAvatarView:(MessageKitCollectionViewLayoutAttributes *)attributes{
    CGPoint origin = CGPointZero;
    CGFloat padding = attributes.avatarLeadingTrailingPadding;
    
    switch (attributes.avatarPosition.horizontal) {
        case avatar_cellLeading:
            origin.x = padding;
            break;
        case avatar_cellTrailing:
            origin.x = attributes.frame.size.width - attributes.avatarSize.width - padding;
            break;
        case avatar_natural:
            NSAssert(1, @"avatarPositionUnresolved");
            break;
    }
    
    switch (attributes.avatarPosition.vertical) {
        case avatar_messageLabelTop:
            origin.y = self.messageTopLabel.frame.origin.y;
            break;
        case avatar_messageTop:
            origin.y = self.containerView.frame.origin.y;
            break;
        case avatar_messageBottom:
            origin.y = self.containerView.frame.origin.y + self.containerView.frame.size.height - attributes.avatarSize.height;
            break;
        case avatar_messageCenter:
            origin.y = ((self.containerView.frame.origin.y + self.containerView.frame.size.height) / 2.f) - (attributes.avatarSize.height/2);
            break;
        case avatar_cellBottom:
            origin.y = attributes.frame.size.height - attributes.avatarSize.height;
            break;
        default:
            break;
    }
    
    self.avatarView.frame = CGRectMake(origin.x, origin.y,attributes.avatarSize.width,attributes.avatarSize.height);
}

/// Positions the cell's `MessageContainerView`.
- (void)layoutMessageContainerView:(MessageKitCollectionViewLayoutAttributes *)attributes{
    CGPoint origin = CGPointZero;
    switch (attributes.avatarPosition.vertical) {
        case avatar_messageBottom:
            origin.y = attributes.size.height - attributes.messageContainerPadding.bottom - attributes.cellBottomLabelSize.height - attributes.messageBottomLabelSize.height - attributes.messageContainerSize.height - attributes.messageContainerPadding.top;
            break;
        case avatar_messageCenter:
            if (attributes.avatarSize.height > attributes.messageContainerSize.height) {
                CGFloat messageHeight = attributes.messageContainerSize.height + attributes.messageContainerPadding.top + attributes.messageContainerPadding.bottom;
                origin.y = (attributes.size.height / 2) - (messageHeight / 2);
                break;
            }
        default:
            if (attributes.accessoryViewSize.height > attributes.messageContainerSize.height) {
                CGFloat messageHeight = attributes.messageContainerSize.height + attributes.messageContainerPadding.top + attributes.messageContainerPadding.bottom;
                origin.y = (attributes.size.height / 2) - (messageHeight / 2);
            } else {
                origin.y = attributes.cellTopLabelSize.height + attributes.messageTopLabelSize.height + attributes.messageContainerPadding.top;
            }
            break;
    }
    
    CGFloat avatarPadding = attributes.avatarLeadingTrailingPadding;
    switch (attributes.avatarPosition.horizontal) {
        case avatar_cellLeading:
            origin.x = attributes.avatarSize.width + attributes.messageContainerPadding.left + avatarPadding;
            break;
        case avatar_cellTrailing:
            origin.x = attributes.frame.size.width - attributes.avatarSize.width - attributes.messageContainerSize.width - attributes.messageContainerPadding.right - avatarPadding;
            break;
        case avatar_natural:
            NSAssert(1, @"avatarPositionUnresolved");
            break;
        default:
            break;
    }
    self.containerView.frame = CGRectMake(origin.x, origin.y, attributes.messageContainerSize.width, attributes.messageContainerSize.height);
}

/// Positions the cell's top label.
- (void)layoutCellTopLabel:(MessageKitCollectionViewLayoutAttributes *)attributes{
    self.cellTopLabel.textAlignment = attributes.cellTopLabelAlignment.textAlignment;
    self.cellTopLabel.textInsets = attributes.cellTopLabelAlignment.textInsets;
    self.cellTopLabel.frame = CGRectMake(0, 0, attributes.cellTopLabelSize.width, attributes.cellTopLabelSize.height);
}

/// Positions the cell's bottom label.
- (void)layoutCellBottomLabel:(MessageKitCollectionViewLayoutAttributes *)attributes{
    self.cellBottomLabel.textAlignment = attributes.cellBottomLabelAlignment.textAlignment;
    self.cellBottomLabel.textInsets = attributes.cellBottomLabelAlignment.textInsets;
    
    CGFloat y = self.messageBottomLabel.frame.origin.y + self.messageBottomLabel.frame.size.height;
    CGPoint origin = CGPointMake(0, y);
    self.cellBottomLabel.frame = CGRectMake(origin.x, origin.y, attributes.cellBottomLabelSize.width, attributes.cellBottomLabelSize.height);
}

/// Positions the message bubble's top label.
- (void)layoutMessageTopLabel:(MessageKitCollectionViewLayoutAttributes *)attributes{
    self.messageTopLabel.textAlignment = attributes.messageTopLabelAlignment.textAlignment;
    self.messageTopLabel.textInsets = attributes.messageTopLabelAlignment.textInsets;
    CGFloat y = self.containerView.frame.origin.y - attributes.messageContainerPadding.top - attributes.messageTopLabelSize.height;
    CGPoint origin = CGPointMake(0, y);
    self.messageTopLabel.frame = CGRectMake(origin.x, origin.y, attributes.messageTopLabelSize.width, attributes.messageTopLabelSize.height);
}

/// Positions the message bubble's bottom label.
- (void)layoutMessageBottomLabel:(MessageKitCollectionViewLayoutAttributes *)attributes{
    self.messageBottomLabel.textAlignment = attributes.messageBottomLabelAlignment.textAlignment;
    self.messageBottomLabel.textInsets = attributes.messageBottomLabelAlignment.textInsets;
    
    CGFloat y = self.containerView.frame.origin.y + self.containerView.frame.size.height + attributes.messageContainerPadding.bottom;
    CGPoint origin = CGPointMake(0, y);
    self.messageBottomLabel.frame = CGRectMake(origin.x, origin.y, attributes.messageBottomLabelSize.width, attributes.messageBottomLabelSize.height);
}

/// Positions the cell's accessory view.
- (void)layoutAccessoryView:(MessageKitCollectionViewLayoutAttributes *)attributes{
    CGPoint origin = CGPointZero;
    
    // Accessory view is set at the side space of the messageContainerView
    switch (attributes.accessoryViewPosition) {
        case accessory_messageLabelTop:
            origin.y = self.messageTopLabel.frame.origin.y;
            break;
        case accessory_messageTop:
            origin.y = self.containerView.frame.origin.y;
            break;
        case accessory_messageBottom:
            origin.y = self.containerView.frame.origin.y + self.containerView.frame.size.height - attributes.accessoryViewSize.height;
            break;
        case accessory_messageCenter:
            origin.y = ((self.containerView.frame.origin.y + self.containerView.frame.size.height) / 2.f) - (attributes.accessoryViewSize.height / 2.f);
            break;
        case accessory_cellBottom:
            origin.y = attributes.frame.size.height - attributes.accessoryViewSize.height;
            break;
        default:
            break;
    }
    
    // Accessory view is always on the opposite side of avatar
    switch (attributes.avatarPosition.horizontal) {
        case avatar_cellLeading:
            origin.x = self.containerView.frame.origin.x + self.containerView.frame.size.width + attributes.accessoryViewPadding.left;
            break;
        case avatar_cellTrailing:
            origin.x = self.containerView.frame.origin.x - attributes.accessoryViewPadding.right - attributes.accessoryViewSize.width;
            break;
        case avatar_natural:
            NSAssert(1, @"avatarPositionUnresolved");
            break;
        default:
            break;
    }
    
    self.accessoryView.frame = CGRectMake(origin.x, origin.y, attributes.accessoryViewSize.width, attributes.accessoryViewSize.height);
}

///  Positions the message bubble's time label.
- (void)layoutTimeLabelView:(MessageKitCollectionViewLayoutAttributes *)attributes{
    CGFloat paddingLeft = 10;
    CGPoint origin = CGPointMake(self.contentView.frame.size.width + paddingLeft, self.contentView.frame.size.height * 0.5);
    CGSize size = CGSizeMake(attributes.messageTimeLabelSize.width, attributes.messageTimeLabelSize.height);
    self.messageTimestampLabel.frame = CGRectMake(origin.x, origin.y, size.width, size.height);
}

@end


@implementation MessageKitContentCell (UISubclassingHooks)

#pragma mark - Configuration

-(void)prepareForReuse{
    [super prepareForReuse];
    /* clear text from reuse queue */
    self.cellTopLabel.text = nil;
    self.cellBottomLabel.text = nil;
    self.messageTopLabel.text = nil;
    self.messageBottomLabel.text = nil;
    self.messageTimestampLabel.attributedText = nil;
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes{
    [super applyLayoutAttributes:layoutAttributes];
    MessageKitCollectionViewLayoutAttributes *attributes = (MessageKitCollectionViewLayoutAttributes *)layoutAttributes;
    if ([attributes isKindOfClass:[MessageKitCollectionViewLayoutAttributes class]]) {
        // Call this before other laying out other subviews
        [self layoutMessageContainerView:attributes];
        [self layoutMessageBottomLabel:attributes];
        [self layoutCellBottomLabel:attributes];
        [self layoutCellTopLabel:attributes];
        [self layoutMessageTopLabel:attributes];
        [self layoutAvatarView:attributes];
        [self layoutAccessoryView:attributes];
        [self layoutTimeLabelView:attributes];
    }
}

-(void)setupSubviews{
    [self.contentView addSubview:self.accessoryView];
    [self.contentView addSubview:self.cellTopLabel];
    [self.contentView addSubview:self.messageTopLabel];
    [self.contentView addSubview:self.messageBottomLabel];
    [self.contentView addSubview:self.cellBottomLabel];
    [self.contentView addSubview:self.containerView];
    [self.contentView addSubview:self.avatarView];
    [self.contentView addSubview:self.messageTimestampLabel];
}

-(void)configureWithMessage:(id<MessageKitMessageType>)message atIndexPath:(NSIndexPath *)indexPath collectionView:(MessageKitCollectionView *)messageCollectionView{
    
    id<MessageKitDataSource> datasource = messageCollectionView.messageDataSource;
    id<MessageKitDisplayDelegate> displayDelegate = messageCollectionView.displayDelegate;
    
    NSAssert(datasource, @"configure message cell with nil datasource.");
    NSAssert(displayDelegate, @"configure message cell with nil display delegate.");
    
    self.delegate = messageCollectionView.cellDelegate;
    
    UIColor *messageBgColor = [displayDelegate backgroundColor:message atIndexPath:indexPath inCollectionView:messageCollectionView];
    
    MessageKitMessageStyle *messageStyle = [displayDelegate messageStyle:message atIndexPath:indexPath inCollectionView:messageCollectionView];
    
    [displayDelegate configureAvatarView:self.avatarView message:message atIndexPath:indexPath inCollectionView:messageCollectionView];
    
    [displayDelegate configureAccessoryView:self.accessoryView message:message atIndexPath:indexPath inCollectionView:messageCollectionView];
    
    self.containerView.backgroundColor = messageBgColor;
    self.containerView.style = messageStyle;
    
    
    NSAttributedString *topCellLabelText = [datasource cellTopLabelAttributedText:message atIndexPath:indexPath];
    NSAttributedString *bottomCellLabelText = [datasource cellBottomLabelAttributedText:message atIndexPath:indexPath];
    NSAttributedString *topMessageLabelText = [datasource messageTopLabelAttributedText:message atIndexPath:indexPath];
    NSAttributedString *bottomMessageLabelText = [datasource messageBottomLabelAttributedText:message atIndexPath:indexPath];
    
    NSAttributedString * messageTimestampLabelText = [datasource messageTimestampLabelAttributedText:message atIndexPath:indexPath];
    
    self.cellTopLabel.attributedText = topCellLabelText;
    self.cellBottomLabel.attributedText = bottomCellLabelText;
    self.messageTopLabel.attributedText = topMessageLabelText;
    self.messageBottomLabel.attributedText = bottomMessageLabelText;
    self.messageTimestampLabel.attributedText = messageTimestampLabelText;
    self.messageTimestampLabel.hidden = !messageCollectionView.showMessageTimestampOnSwipeLeft;
}

/// Handle `ContentView`'s tap gesture, return false when `ContentView` doesn't needs to handle gesture
- (BOOL)cellContentViewCanHandle:(CGPoint )touchPoint {
    return NO;
}

@end
