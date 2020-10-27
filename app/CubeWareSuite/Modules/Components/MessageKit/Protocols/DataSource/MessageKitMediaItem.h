//
//  MessageKitMediaItem.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/28.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/// A protocol used to represent the data for a media message.
@protocol MessageKitMediaItem <NSObject>

/// The url where the media is located.
- (NSURL *)url;

/// The image.
- (UIImage *)image;

/// A placeholder image for when the image is obtained asychronously.
- (UIImage *)placeholderImage;

/// The size of the media item.
- (CGSize)size;


@end
