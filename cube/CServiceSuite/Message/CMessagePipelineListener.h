//
//  CMessagePipelineListener.h
//  CServiceSuite
//
//  Created by Ashine on 2020/11/2.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPipeline.h"
//#import "CMessageService.h"
@class CMessageService;

NS_ASSUME_NONNULL_BEGIN

@interface CMessagePipelineListener : NSObject <CPipelineListener>

@property (nonatomic , weak) CMessageService *messageService;

- (instancetype)initWithListener:(id)listener;


@end

NS_ASSUME_NONNULL_END
