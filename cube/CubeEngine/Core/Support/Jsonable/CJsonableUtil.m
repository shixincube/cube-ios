//
//  CJsonableUtil.m
//  CServiceSuite
//
//  Created by Ashine on 2020/10/12.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CJsonableUtil.h"
#import <objc/runtime.h>

@implementation CJsonableUtil

+(NSDictionary *)translateObjectToJsonObject:(id)obj{
    NSMutableDictionary *dic = nil;
    if (obj) {
        Class cls = [obj class]; // get object class.
        NSMutableArray *clsArray = [NSMutableArray arrayWithObject:cls];
        while ([cls superclass]) {
            cls = [cls superclass];
            if ([cls conformsToProtocol:@protocol(CJsonable)]) {
                [clsArray addObject:cls];
            }
            else{
                break;
            }
        }
        
        for (Class tmpCls in clsArray) {
            dic = [self translateObjectToJsonObject:obj OfClass:tmpCls inputJsonObject:dic];
        }
    }
    return dic;
}

+ (NSMutableDictionary *)translateObjectToJsonObject:(id)object OfClass:(Class)cls inputJsonObject:(NSMutableDictionary *)inputJsonObject{
    if (object && cls) {
        if (!inputJsonObject) {
            inputJsonObject = [NSMutableDictionary dictionary];
        }
        
        unsigned int propertCount = 0;
        objc_property_t *properties = class_copyPropertyList(cls, &propertCount);
        if (propertCount) {
            
            NSArray *ignoredProperties = nil;
            if([[object class] conformsToProtocol:@protocol(CJsonable)] && [[object class] respondsToSelector:@selector(ignoredProperties)])
            {
                ignoredProperties = [[object class] ignoredProperties];
            }
            
            NSDictionary *keysMap = nil;
            if([[object class] conformsToProtocol:@protocol(CJsonable)] && [[object class] respondsToSelector:@selector(keysMap)]){
                keysMap = [[object class] keysMap];
            }
            
            BOOL ifCustomeKey = [cls conformsToProtocol:@protocol(CJsonable)] && [object respondsToSelector:@selector(valueForProperty:)];
            
            for (int i = 0; i < propertCount; i++) {
                objc_property_t p = properties[i];
                NSString *key = [NSString stringWithUTF8String:property_getName(p)];
                NSLog(@"get property key : %@",key);
                if (![ignoredProperties containsObject:key]) {
                    
                    id value = nil;
                    
                    if (ifCustomeKey) {
                        value = [object valueForProperty:key];
                    }
                    else{
                        value = [object valueForKey:key];
                    }
                    
                    if (value) {
                        NSArray *customKeys = [[keysMap objectForKey:key] count] ? [keysMap valueForKey:key] : @[key];
                        NSMutableDictionary *tmpDic = inputJsonObject;
                        for (NSString *ck in customKeys) {
                            if ([ck isEqualToString:customKeys.lastObject]) {
                                [tmpDic setValue:value forKey:ck];
                            }
                            else{
                                if (![tmpDic objectForKey:ck]) {
                                    [tmpDic setObject:[NSMutableDictionary dictionary] forKey:ck];
                                }
                                tmpDic = [tmpDic objectForKey:ck];
                            }
                        }
                    }
                }
            }
        }
        free(properties);
    }
    return inputJsonObject;
}

+(void)updateObject:(id)obj withJsonObject:(NSDictionary *)json{
    if (obj && json) {
        Class cls = [obj class];
        NSMutableArray *clsArray = [NSMutableArray arrayWithObject:cls];
        
        while ([cls superclass]) {
            cls = [cls superclass];
            if ([cls conformsToProtocol:@protocol(CJsonable)]) {
                [clsArray insertObject:cls atIndex:0];
            }
            else{
                break;
            }
        }
        
        for (Class tmpCls in clsArray) {
            [self updateObject:obj OfClass:tmpCls andJsonObject:json];
        }
    }
}

+(id)generateObjectOfClass:(Class)cls fromJsonObject:(NSDictionary *)json{
    id obj = nil;
    if (cls && json) {
        obj = [cls new];
        [self updateObject:obj withJsonObject:json];
    }
    return obj;
}

+ (void)updateObject:(id)obj OfClass:(Class)cls andJsonObject:(NSDictionary *)json{
    if (obj && json) {
        unsigned int propertCount = 0;
        objc_property_t *properts = class_copyPropertyList(cls, &propertCount);
        if (propertCount) {
            
            BOOL ifCustomKey = [obj conformsToProtocol:@protocol(CJsonable)] && [obj respondsToSelector:@selector(setValue:forProperty:)];
            
            NSDictionary *keyMaps = nil;
            if ([[obj class] conformsToProtocol:@protocol(CJsonable)] && [[obj class] respondsToSelector:@selector(keysMap)]) {
                keyMaps = [[obj class] keysMap];
            }
            
            for (int i = 0; i < propertCount; i++) {
                objc_property_t p = properts[i];
                char *pv = property_copyAttributeValue(p, "R");
                if (!pv) {
                    NSString *key = [NSString stringWithUTF8String:property_getName(p)];
                    NSArray *customKeys = [[keyMaps valueForKey:key] count] ? [keyMaps valueForKey:key] : @[key];
                    id value = nil;
                    NSDictionary *tmpDic = json;
                    for (NSString *ck in customKeys) {
                        if ([ck isEqualToString:customKeys.lastObject]) {
                            value = [tmpDic objectForKey:ck];
                        }
                        else{
                            tmpDic = [tmpDic objectForKey:ck];
                        }
                    }
                    
                    if (value) {
                        if (ifCustomKey) {
                            [obj setValue:value forProperty:key];
                        }
                        else{
                            [obj setValue:value forKey:key];
                        }
                    }
                }
                else{
                    free(pv);
                }
            }
        }
        free(properts);
    }
}


@end
