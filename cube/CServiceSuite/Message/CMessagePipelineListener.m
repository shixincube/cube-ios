//
//  CMessagePipelineListener.m
//  CServiceSuite
//
//  Created by Ashine on 2020/11/2.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CMessagePipelineListener.h"

@implementation CMessagePipelineListener

-(instancetype)initWithListener:(id)listener{
    if (self = [super init]) {
        self.messageService = listener; // need to optimized.
    }
    return self;
}


#pragma mark - cpipelinelistener

-(void)onReceived:(CPipeline *)pipeline source:(NSString *)source packet:(CPacket *)packet{
    
}



@end
