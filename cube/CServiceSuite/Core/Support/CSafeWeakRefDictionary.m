//
//  CSafeWeakRefDictionary.m
//  CServiceSuite
//
//  Created by Ashine on 2020/9/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CSafeWeakRefDictionary.h"

#define INIT(...) self = super.init; \
if (!self) return nil; \
__VA_ARGS__; \
if (!_weakdic) return nil; \
_lock = dispatch_semaphore_create(1); \
return self;

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@interface CSafeWeakRefDictionary ()
{
    dispatch_semaphore_t _lock;
    NSMapTable *_weakdic;
}


@end

@implementation CSafeWeakRefDictionary

#pragma mark - init

-(instancetype)init{
    INIT(_weakdic = [NSMapTable weakToWeakObjectsMapTable]);
}

#pragma mark - public
-(void)setObject:(id)anObject forKey:(id<NSCopying>)aKey{
    LOCK([_weakdic setObject:anObject forKey:aKey]);
}

-(void)removeObjectForKey:(id)aKey{
    LOCK([_weakdic removeObjectForKey:aKey]);
}

-(void)removeAllObject{
    LOCK([_weakdic removeAllObjects]);
}

-(id)objectForKey:(id)key{
    LOCK(id object = [_weakdic.dictionaryRepresentation objectForKey:key]);
    return object;
}

-(NSArray *)allValues{
    LOCK(
         NSMutableArray *values = [NSMutableArray array];
         id value;
         while((value = [_weakdic.objectEnumerator nextObject])){
            [value addObject:value];
        }
    );
    return values;
}

-(NSArray *)allKeys{
    LOCK(
         NSMutableArray *keys = [NSMutableArray array];
         id key;
          while((key = [_weakdic.keyEnumerator nextObject])){
             [keys addObject:key];
         }
    );
    return keys;
}

@end
