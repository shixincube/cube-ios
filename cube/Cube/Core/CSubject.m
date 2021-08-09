/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Shixin Cube Team.
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 */

#import "CSubject.h"

@interface CSubject ()

@property (nonatomic, strong) NSMutableArray <__kindof CObserver *> * observers;

@property (nonatomic, strong) NSMutableDictionary <NSString *, __kindof NSMutableArray *> * namedObservers;

@end

@implementation CSubject

- (instancetype)init {
    if (self = [super init]) {
        self.observers = nil;
        self.namedObservers = nil;
    }

    return self;
}

- (void)attach:(CObserver *)observer {
    if (nil == self.observers) {
        self.observers = [[NSMutableArray alloc] init];
    }

    if ([self.observers containsObject:observer]) {
        return;
    }
    
    [self.observers addObject:observer];
}

- (void)attachWithName:(NSString *)name observer:(CObserver *)observer {
    if (nil == self.namedObservers) {
        self.namedObservers = [[NSMutableDictionary alloc] init];
    }
    
    NSMutableArray * list = [self.namedObservers objectForKey:name];
    
    if (list) {
        if (![list containsObject:observer]) {
            [list addObject:observer];
        }
    }
    else {
        list = [[NSMutableArray alloc] init];
        [list addObject:observer];
        [self.namedObservers setObject:list forKey:name];
    }
}

- (void)detach:(CObserver *)observer {
    if (nil == self.observers) {
        return;
    }
    
    [self.observers removeObject:observer];
}

- (void)detachWithName:(NSString *)name observer:(CObserver *)observer {
    if (nil == self.namedObservers) {
        return;
    }

    NSMutableArray * list = [self.namedObservers objectForKey:name];

    if (list) {
        [list removeObject:observer];
    }
}

- (void)notifyObservers:(CObservableEvent *)event {
    event.subject = self;
    
    if (nil != self.observers) {
        for (CObserver * obs in self.observers) {
            [obs update:event];
        }
    }

    if (nil != self.namedObservers) {
        NSMutableArray * list = [self.namedObservers objectForKey:event.name];
        if (list) {
            for (CObserver * obs in list) {
                [obs update:event];
            }
        }
    }
}

@end
