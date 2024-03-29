/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Cube Team.
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

#import "CPipeline.h"

// 标记不需要标记目标的监听器。
#define DRIFTLESS_LISTENER @"*"

@interface CPipeline ()

@property (nonatomic, strong) NSMutableDictionary <NSString *, __kindof NSMutableArray *> *listeners;

- (__kindof NSMutableArray<id<CPipelineListener>> *)getOrCreateListeners:(NSString *)destination;

/*!
 * @brief 返回指定目标对应的监听器协议。
 */
- (__kindof NSMutableArray<id<CPipelineListener>> *)getListeners:(NSString *)destination;

@end


@implementation CPipeline

- (instancetype)initWithName:(NSString *)name {
    if (self = [super init]) {
        _name = name;
        _tokenCode = nil;

        self.listeners = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)open {
    // subclass hook override.
}

- (void)close {
    // subclass hook override.
}

- (BOOL)isReady {
    // subclass hook override.
    return FALSE;
}

- (void)send:(NSString *)destination withPacket:(CPacket *)packet handleResponse:(void (^)(CPacket *))handleResponse {
    // subclass hook override.
}

- (void)send:(NSString *)destination withPacket:(CPacket *)packet {
    // subclass hook override.
}

- (void)setRemoteAddress:(NSString *)address withPort:(NSInteger)port {
    _address = address;
    _port = port;
}

- (void)addListener:(id<CPipelineListener>)listener withDestination:(NSString *)destination {
    NSAssert(destination, @"Can't add listener with nil destination.");
    NSAssert(listener, @"Can't add listener with nil listener.");

    NSMutableArray * listeners = [self getOrCreateListeners:destination];
    if ([listeners indexOfObject:listener] == NSNotFound) {
        [listeners addObject:listener];
    }
}

- (void)addListener:(id<CPipelineListener>)listener {
    NSAssert(listener, @"Can't add listener with nil listener.");

    NSMutableArray * listeners = [self getOrCreateListeners:DRIFTLESS_LISTENER];
    if ([listeners indexOfObject:listener] == NSNotFound) {
        [listeners addObject:listener];
    }
}

- (void)removeListener:(id<CPipelineListener>)listener withDestination:(NSString *)destination {
    NSAssert(destination, @"Can't add listener with nil destination.");
    NSAssert(listener, @"Can't add listener with nil listener.");

    NSMutableArray * listeners = [self getListeners:destination];
    if (listeners) {
        [listeners removeObject:listener];
    }
}

- (void)removeListener:(id<CPipelineListener>)listener {
    NSAssert(listener, @"Can't add listener with nil listener.");

    NSMutableArray * listeners = [self getListeners:DRIFTLESS_LISTENER];
    if (listeners) {
        [listeners removeObject:listener];
    }
}

- (__kindof NSMutableArray<id<CPipelineListener>> *)getAllListeners {
    NSMutableArray<id<CPipelineListener>> * result = [[NSMutableArray alloc] init];
    for (NSString * key in _listeners) {
        NSMutableArray<id<CPipelineListener>> * list = [_listeners objectForKey:key];
        for (id<CPipelineListener> listener in list) {
            [result addObject:listener];
        }
    }
    return result;
}

- (__kindof NSMutableArray<id<CPipelineListener>> *)getOrCreateListeners:(NSString *)destination {
    NSMutableArray *listeners = [self.listeners objectForKey:destination];
    if (!listeners) {
        listeners = [NSMutableArray array];
        [self.listeners setObject:listeners forKey:destination];
    }
    return listeners;
}

- (__kindof NSMutableArray<id<CPipelineListener>> *)getListeners:(NSString *)destination {
    return [self.listeners objectForKey:destination];
}

- (void)triggerListener:(NSString *)destination packet:(CPacket *)packet {
    NSMutableArray * listeners = [self getListeners:destination];

    if (listeners) {
        for (id<CPipelineListener> listener in listeners) {
            if ([listener respondsToSelector:@selector(didReceive:source:packet:)]) {
                [listener didReceive:self source:destination packet:packet];
            }
        }
    }
}

- (CPipelineState *)extractState:(NSDictionary *)state {
    unsigned int code = [state[@"code"] unsignedIntValue];
    NSString * desc = [state objectForKey:@"desc"];
    return [[CPipelineState alloc] initWithCode:code desc:desc];
}

@end
