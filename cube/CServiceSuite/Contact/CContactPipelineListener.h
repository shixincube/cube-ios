//
//  CContactPipelineListener.h
//  CServiceSuite
//
//  Created by ShixinCloud on 2020/12/18.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CPipeline.h"
@class CContactService;

@interface CContactPipelineListener : NSObject <CPipelineListener>

@property (nonatomic , weak) CContactService *contactService;

- (instancetype)initWithListener:(id)listener;

@end


