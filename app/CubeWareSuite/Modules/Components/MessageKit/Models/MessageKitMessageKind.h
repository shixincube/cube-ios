//
//  MessageKitMessageKind.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/28.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageKitMediaItem.h"

NS_ASSUME_NONNULL_BEGIN


typedef enum : NSUInteger {
    MKMessageKind_text,
    MKMessageKind_attributedText,
    MKMessageKind_photo,
    MKMessageKind_video,
    MKMessageKind_location,
    MKMessageKind_emoji,
    MKMessageKind_audio,
    MKMessageKind_contact,
    MKMessageKind_linkPreview,
    MKMessageKind_custom,
} MKMessageKind;

@interface MessageKitMessageKind : NSObject

@property (nonatomic , assign) MKMessageKind kind;

// difference kind represent difference kind object. 
@property (nonatomic , strong) id kindObject;



@end

NS_ASSUME_NONNULL_END
