//
//  CContactPipelineListener.m
//  CServiceSuite
//
//  Created by ShixinCloud on 2020/12/18.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CContactPipelineListener.h"
#import "CContactService.h"

@implementation CContactPipelineListener


-(instancetype)initWithListener:(id)listener{
    if (self = [super init]) {
        self.contactService = listener; // need to optimized.
    }
    return self;
}


#pragma mark - cpipelinelistener

-(void)onReceived:(CPipeline *)pipeline source:(NSString *)source packet:(CPacket *)packet{
    
}


@end
