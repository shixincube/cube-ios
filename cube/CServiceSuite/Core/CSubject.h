//
//  CSubject.h
//  CServiceSuite
//
//  Created by Ashine on 2020/9/9.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@class CSubject;

@interface CObserverState : NSObject

@property (nonatomic , copy , readonly) NSString *name;
@property (nonatomic , strong , readonly) NSDictionary *data;
@property (nonatomic , weak) CSubject *subject;

- (instancetype)initWithName:(NSString *)name data:(NSDictionary *)data;

@end

@protocol CObserver <NSObject>

- (void)update:(CObserverState *)state;

@end

@interface CSubject : NSObject

- (void)attach:(id<CObserver>)observer;

- (void)attachWithName:(NSString *)name observer:(id<CObserver>)observer;

- (void)detach:(id<CObserver>)observer;

- (void)detachWithName:(NSString *)name observer:(id<CObserver>)observer;

- (void)notifyObservers:(CObserverState *)state;

@end

NS_ASSUME_NONNULL_END
