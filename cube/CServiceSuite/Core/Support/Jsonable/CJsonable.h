//
//  CJsonable.h
//  CServiceSuite
//
//  Created by Ashine on 2020/10/12.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CJsonable

@required

- (NSDictionary *)toJson;

+ (id)fromJson:(NSDictionary *)json;

@optional

+ (NSDictionary *)keysMap;

+ (NSArray <NSString *> *)ignoredProperties;

- (id)valueForProperty:(NSString *)property;

- (void)setValue:(id)value forProperty:(NSString *)property;

@end
