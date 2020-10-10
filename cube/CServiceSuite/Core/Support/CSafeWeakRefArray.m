//
//  CSafeWeakRefArray.m
//  CServiceSuite
//
//  Created by Ashine on 2020/9/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CSafeWeakRefArray.h"

#define INIT(...) self = super.init; \
if (!self) return nil; \
__VA_ARGS__; \
if (!_weakRefArr) return nil; \
_lock = dispatch_semaphore_create(1); \
return self;

#define LOCK(...) dispatch_semaphore_wait(_lock, DISPATCH_TIME_FOREVER); \
__VA_ARGS__; \
dispatch_semaphore_signal(_lock);

@interface CSafeWeakRefArray ()
{
    dispatch_semaphore_t _lock;
    NSPointerArray *_weakRefArr; //Subclass a class cluster...
}
@end

@implementation CSafeWeakRefArray

#pragma mark - init

-(instancetype)init{
    INIT(_weakRefArr = [NSPointerArray weakObjectsPointerArray]);
}

#pragma mark - public

-(void)addObject:(id)object{
    LOCK([_weakRefArr addPointer:(__bridge void *)object]);
}

-(void)addObjectsFromArray:(NSArray *)otherArray{
    LOCK(
    for (id object in otherArray) {
        [_weakRefArr addPointer:(__bridge void *)object];
    });
}

-(void)insertObject:(id)anObject atIndex:(NSUInteger)index{
    LOCK([_weakRefArr insertPointer:(__bridge void *)anObject atIndex:index]);
}


-(void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject{
    LOCK([_weakRefArr replacePointerAtIndex:index withPointer:(__bridge void *)anObject]);
}

-(void)compact{
    LOCK([_weakRefArr compact]);
}

-(id)objectAtIndex:(NSUInteger)index{
    LOCK(
         if(index < _weakRefArr.count){
            return nil;
         }
         void *objectPointer = [_weakRefArr pointerAtIndex:index];
    );
    return (__bridge id)objectPointer;
}

-(NSArray *)allObjects{
    LOCK(
         [_weakRefArr compact];
         NSArray *array = _weakRefArr.allObjects;
    );
    return array;
}

//-(void)removeObject:(id)anObject{
//    LOCK(
//         for (int i = 0; i < _weakRefArr.count; i++ ) {
//            void *objectPointer = [_weakRefArr pointerAtIndex:i];
//            if (objectPointer ==  (__bridge void *)anObject) {
//                [_weakRefArr removePointerAtIndex:i];
//                break;
//            }
//         }
//    );
//}
//
//-(void)removeLastObject{
//    _weakRefArr removePointerAtIndex:<#(NSUInteger)#>
//}






@end
