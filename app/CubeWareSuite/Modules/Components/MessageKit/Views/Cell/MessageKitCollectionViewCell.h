//
//  MessageKitCollectionViewCell.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/// A subclass of `UICollectionViewCell` to be used inside of a `MessagesCollectionView`.
@interface MessageKitCollectionViewCell : UICollectionViewCell

// subclass override this method
- (void)handleTapGesture:(UIGestureRecognizer *)gesture;


@end

NS_ASSUME_NONNULL_END
