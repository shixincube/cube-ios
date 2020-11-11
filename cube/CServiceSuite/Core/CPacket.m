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


-(instancetype)initWithName:(NSString *)name data:(NSDictionary *)data sn:(long)sn{
    if (self = [super init]) {
        self.name = name;
        self.data = data;
        if (sn) {
            self.sn = sn;
        }
    }
    return self;
}

-(int)getStateCode{
    if (self.state[@"code"]) {
        return [self.state[@"code"] intValue];
    }
    return -1;
}

-(int64_t)sn{
    if (!_sn) {
        _sn = [CellUtil generateUnsignedSerialNumber];
    }
    return _sn;
}


@end
