//
//  CPacket.m
//  CServiceSuite
//
//  Created by Ashine on 2020/9/1.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CPacket.h"
#import <cell/cell.h>

@implementation CPacket

-(int)getStateCode{
    if (self.data[@"data"][@"state"]) {
        return [self.data[@"data"][@"state"][@"code"] intValue];
    }
    return -1;
}

-(long)sn{
    if (!_sn) {
        _sn = [CellUtil generateUnsignedSerialNumber];
    }
    return _sn;
}


@end
