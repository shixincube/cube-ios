//
//  CCommFieldEndpoint.h
//  CServiceSuite
//
//  Created by ShixinCloud on 2020/12/25.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CContact;

//通讯场域里的媒体节点
@interface CCommFieldEndpoint : NSObject

//节点名称
@property (nonatomic ,strong) NSString *name;
//节点ID
@property (nonatomic ,assign) NSInteger pointID;
//关联的联系人
@property (nonatomic ,strong) CContact *contact;

@end

