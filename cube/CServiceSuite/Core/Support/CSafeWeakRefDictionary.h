//
//  CSafeWeakRefDictionary.h
//  CServiceSuite
//
//  Created by Ashine on 2020/9/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CSafeWeakRefDictionary <KeyType,ObjectType> : NSObject

@property (readonly, copy) NSArray<KeyType> *allKeys;
@property (readonly, copy) NSArray<ObjectType> *allValues;

- (void)removeObjectForKey:(KeyType)aKey;
- (void)setObject:(ObjectType)anObject forKey:(KeyType <NSCopying>)aKey;

- (ObjectType)objectForKey:(KeyType)key;
- (void)removeAllObject;

@end

NS_ASSUME_NONNULL_END
