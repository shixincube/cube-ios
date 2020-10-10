//
//  MessageKitCollectionView.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/15.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <UIKit/UIKit.h>

/////////////////////////////////// delegate //////////////////////////////
#import "MessageKitDataSource.h"
#import "MessageKitLayoutDelegate.h"
#import "MessageKitDisplayDelegate.h"
#import "MessageKitCellDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageKitCollectionView : UICollectionView

@property (nonatomic , weak) id<MessageKitDataSource> messageDataSource;

@property (nonatomic , weak) id<MessageKitLayoutDelegate> layoutDelegate;

@property (nonatomic , weak) id<MessageKitDisplayDelegate> displayDelegate;

@property (nonatomic , weak) id<MessageKitCellDelegate> cellDelegate;

/// Display the date of message by swiping left.
/// The default value of this property is `false`.
@property (nonatomic , assign) BOOL showMessageTimestampOnSwipeLeft;

@end

NS_ASSUME_NONNULL_END
