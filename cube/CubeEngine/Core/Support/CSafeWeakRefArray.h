//
//  CSafeWeakRefArray.h
//  CServiceSuite
//
//  Created by Ashine on 2020/9/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*
* convenient thread safe weak array by use weak pointer array
*/

@interface CSafeWeakRefArray <ObjectType> : NSObject

// temp to offer below api. extend if needed.

- (void)addObject:(ObjectType)object;
- (void)addObjectsFromArray:(NSArray <ObjectType>*)otherArray;
- (void)insertObject:(ObjectType)anObject atIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(ObjectType)anObject;

- (ObjectType)objectAtIndex:(NSUInteger)index;
- (NSArray <ObjectType>*)allObjects;

- (void)compact;

// weak ref not retain object , just use compact to eliminate null pointer.
//- (void)removeObject:(ObjectType)anObject;
//- (void)removeLastObject;
//- (void)removeObjectAtIndex:(NSUInteger)index;
//- (void)removeAllObjects;


@end

NS_ASSUME_NONNULL_END
