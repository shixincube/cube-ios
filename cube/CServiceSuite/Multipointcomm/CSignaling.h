//
//  CSignaling.h
//  CServiceSuite
//
//  Created by ShixinCloud on 2020/12/25.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJsonable.h"


@interface CSignaling : NSObject<CJsonable>

//信令名
@property (nonatomic ,strong) NSString *name;


@end


