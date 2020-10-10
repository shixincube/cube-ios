//
//  MessageKitMessageLabel.h
//  CubeWareSuite
//
//  Created by Ashine on 2020/9/24.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MessageKitLabelDelegate.h"
#import "MessageKitDetectorType.h"

NS_ASSUME_NONNULL_BEGIN

@interface MessageKitMessageLabel : UILabel

@property (nonatomic , weak) id <MessageKitLabelDelegate> delegate;

@property (nonatomic , assign) UIEdgeInsets textInsets;

@property (nonatomic , strong) UIFont *messageLabelFont;

@property (nonatomic , strong) NSArray <MessageKitDetectorType *> *enabledDetectors;

- (void)configure:(void(^)(void))block;

- (void)setAttributes:(NSDictionary *)attributes detector:(MessageKitDetectorType *)detector;

- (BOOL)handleGesture:(CGPoint)touchLocation;


@end

NS_ASSUME_NONNULL_END
