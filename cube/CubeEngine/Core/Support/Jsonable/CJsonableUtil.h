//
//  CJsonableUtil.h
//  CServiceSuite
//
//  Created by Ashine on 2020/10/12.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CJsonable.h"


NS_ASSUME_NONNULL_BEGIN

/*
 * jsonable protocol provide key maps & ignored properties
 * 
 */

@interface CJsonableUtil : NSObject

+ (NSDictionary *)translateObjectToJsonObject:(id)obj;

+ (id)generateObjectOfClass:(Class)cls fromJsonObject:(NSDictionary *)json;

+ (void)updateObject:(id)obj withJsonObject:(NSDictionary *)json;


@end

NS_ASSUME_NONNULL_END
