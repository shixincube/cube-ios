//
//  CSubject.m
//  CServiceSuite
//
//  Created by Ashine on 2020/9/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CSubject.h"
#import "CThreadSafeArray.h"
#import "CThreadSafeDictionary.h"

@interface CObserverState ()
{
    NSString *_name;
    NSDictionary *_data;
}
@end

@implementation CObserverState

@synthesize name = _name;
@synthesize data = _data;

#pragma mark - init

-(instancetype)initWithName:(NSString *)name data:(NSDictionary *)data{
    if (self = [super init]) {
        NSAssert(name, @"can't init state with nil name");
        NSAssert(data, @"can't init state with nil data");
        _name = name;
        _data = data;
    }
    return self;
}

@end


@interface CSubject ()

@property (nonatomic , strong) CThreadSafeArray *observers;
@property (nonatomic , strong) CThreadSafeDictionary *nameObservers;

@end


@implementation CSubject

#pragma mark - getter
-(NSMutableArray *)observers{
    if (!_observers) {
        _observers = [CThreadSafeArray array];
    }
    return _observers;
}

-(CThreadSafeDictionary *)nameObservers{
    if (!_nameObservers) {
        _nameObservers = [CThreadSafeDictionary dictionary];
    }
    return _nameObservers;
}

#pragma mark - public

-(void)attach:(id<CObserver>)observer{
    NSAssert(observer, @"attach observer can't be nil");
    if ([self.observers indexOfObject:observer] == NSNotFound) {
        [self.observers addObject:observer];
    }
}

-(void)attachWithName:(NSString *)name observer:(id<CObserver>)observer{
    NSAssert(name, @"attach observer with nil name");
    NSAssert(observer, @"attach observer with nil observer");
    CThreadSafeArray *observers = [self.nameObservers objectForKey:name];
    if (!observers) {
        CThreadSafeArray *observers = [CThreadSafeArray arrayWithObject:observer];
        [self.nameObservers setObject:observers forKey:name];
    }
    else{
        if ([observers indexOfObject:observer] == NSNotFound) {
            [observers addObject:observer];
        }
    }
}

-(void)detach:(id<CObserver>)observer{
    NSAssert(observer, @"can't detach nil observer.");
    [self.observers removeObject:observer];
}

-(void)detachWithName:(NSString *)name observer:(id<CObserver>)observer{
    NSAssert(name, @"can't detach observer with nil name.");
    NSAssert(observer, @"can't detach nil observer.");
    CThreadSafeArray *observers = [self.nameObservers objectForKey:name];
    if (observers) {
        [observers removeObject:observer];
    }
}

-(void)notifyObservers:(CObserverState *)state{
    state.subject = self;
    for (id <CObserver> observer in self.observers) {
        [observer update:state];
    }
    
    CThreadSafeArray *observers = [self.nameObservers objectForKey:state.name];
    for (id <CObserver> observer in observers) {
        [observer update:state];
    }
}

@end
