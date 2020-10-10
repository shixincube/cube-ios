//
//  MessageKitSenderType.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/15.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MessageKitSenderType <NSObject>

/// The unique String identifier for the sender.
- (NSString *)senderId;

/// The display name of a sender.
- (NSString *)displayName;

@end

