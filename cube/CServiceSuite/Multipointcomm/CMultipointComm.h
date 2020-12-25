//
//  CMultipointComm.h
//  CServiceSuite
//
//  Created by ShixinCloud on 2020/12/25.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <CServiceSuite/CServiceSuite.h>
@class CCommField,CContact,CMediaConstraint,CCallRecord;

@interface CMultipointComm : CModule

@property (nonatomic ,class , readonly) NSString *mName;

//ice services
@property (nonatomic ,copy) NSString *iceServers;
//个人的私有通信场
@property (nonatomic ,strong) CCommField *privateField;
//管理的通信场域 <nsinteger,CCommField>
@property (nonatomic ,strong) NSDictionary *fields;


typedef void(^MultipontSuccessCallBack)(CCallRecord *callRecord);
typedef void(^MultipontErrorCallBack)(int code,NSString *desc);


-(void)makeCall:(CContact*)target mediaConstraint:(CMediaConstraint*)mediaConstraint success:(MultipontSuccessCallBack)success error:(MultipontErrorCallBack)error;
@end


