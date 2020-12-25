//
//  CMultipointComm.m
//  CServiceSuite
//
//  Created by ShixinCloud on 2020/12/25.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CMultipointComm.h"
#import "CCommField.h"
#import "CContact.h"
#import "CMediaConstraint.h"
#import "CCallRecord.h"

static NSString *_name = @"MultipointComm";

@interface CMultipointComm () <CPipelineListener> // to be optimized. use messagePipeline listener instead.

@end


@implementation CMultipointComm

+(NSString *)mName{
    return _name;
}

-(CPipeline *)pipeline{
    return [[CKernel shareKernel] getPipeline:CCellPipeline.pName];
}

-(instancetype)init{
    if (self = [super initWithName:_name]) {
//        [self.pipeline addListener:@"Messaging" listener:self];
    }
    return self;
}

-(void)makeCall:(CContact*)target mediaConstraint:(CMediaConstraint*)mediaConstraint success:(MultipontSuccessCallBack)success error:(MultipontErrorCallBack)error{
    
    CPacket *packet = [[CPacket alloc] initWithName:@"applyCall" data:[group toJson] sn:0];
    [(CCellPipeline *)self.pipeline send:CContactService.mName packet:packet response:^(CPacket *packet) {
            
    }];
}

@end
