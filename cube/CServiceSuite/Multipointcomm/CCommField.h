//
//  CCommField.h
//  CServiceSuite
//
//  Created by ShixinCloud on 2020/12/25.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <CServiceSuite/CServiceSuite.h>

@class CContact,RTCDevice,CDevice;

@interface CCommField : CEntity

@property (nonatomic ,assign) NSInteger fieldID;
@property (nonatomic ,strong) CContact *founder;
@property (nonatomic ,strong) CPipeline *pipeline;
@property (nonatomic ,copy)   NSArray<RTCDevice*> *rtcDevices;
@property (nonatomic ,strong) RTCDevice *outboundRTC;
@property (nonatomic ,strong) RTCDevice *inboundRTC;
@property (nonatomic ,copy)   NSArray *endpoints;
@property (nonatomic ,strong)   CDevice *device;

@end


