//
//  CPacket.h
//  CServiceSuite
//
//  Created by Ashine on 2020/9/1.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CPacket : NSObject


@property (nonatomic , copy) NSString *name;

@property (nonatomic , strong) NSDictionary *data; // temp use nsdata
// sequence number : sn
@property (nonatomic , assign) long sn;

- (int)getStateCode;


@end

NS_ASSUME_NONNULL_END
