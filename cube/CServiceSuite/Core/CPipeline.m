/**
* This file is part of Cube.
*
* The MIT License (MIT)
*
* Copyright (c) 2020 Shixin Cube Team.
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

@interface CPipeline ()

@property (nonatomic , strong) NSMutableDictionary <NSString *,__kindof NSArray *> *listeners;

@property (nonatomic , copy) NSString *token;

@end

@implementation CPipeline


-(instancetype)initWithName:(NSString *)name{
    if (self = [super init]) {
        NSAssert(name, @"can't init pipeline with nil name.");
        _name = name;
    }
    return self;
}

-(void)setRemoteAddress:(NSString *)address port:(NSUInteger)port{
    NSAssert(address, @"can't set remote address with nil.");
    NSAssert(port, @"can't set remote port with nil.");
    _address = address;
    _port = port;
}


#pragma mark - getter
-(NSMutableDictionary<NSString *,NSArray *> *)listeners{
    if (!_listeners) {
        _listeners = [NSMutableDictionary dictionary];
    }
    return _listeners;
}


#pragma mark - interface

// TODO: for theard safe add mutex lock here.

-(void)addListener:(NSString *)destination listener:(id<CPipelineListener>)listener{
    NSAssert(destination, @"can't add listener with nil dest.");
    NSAssert(listener, @"can't add listener with nil listener.");
    NSMutableArray *listeners = [self getListener:destination];
    if ([listeners indexOfObject:listener] == NSNotFound) {
        [listeners addObject:listener];
        [self.listeners setObject:listeners forKey:destination];
    }
}

-(void)removeListener:(NSString *)destination listener:(id<CPipelineListener>)listener{
    NSAssert(destination, @"can't remove listener with nil dest.");
    NSAssert(listener, @"can't remove listener with nil listener.");
    NSMutableArray *listeners = [self getListener:destination];
    [listeners removeObject:listener];
}

-(__kindof NSArray<id<CPipelineListener>> *)getListener:(NSString *)destination{
    NSAssert(destination, @"can't get listener with nil dest.");
    NSMutableArray *listeners = [self.listeners objectForKey:destination];
    if (!listeners) {
        listeners = [NSMutableArray array];
    }
    return listeners;
}


-(void)triggerListener:(NSString *)source packet:(CPacket *)packet{
    NSAssert(source, @"can't trigger listener with nil source.");
    NSAssert(packet, @"can't trigger listener with nil packet.");
    NSArray *listeners = [self getListener:source];
    for (id <CPipelineListener> li in listeners) {
        if ([li respondsToSelector:@selector(onReceived:source:packet:)]) {
            [li onReceived:self source:source packet:packet];
        }
    }
}

-(void)triggerCallBack:(NSString *)source packet:(CPacket *)packet callback:(void (^)(CPacket *))callback{
    // subclass hook override.
    if (callback) {
        callback(packet);
    }
}

@end

@implementation CPipeline (SubClassHook)


-(void)open{
    // subclass hook override.
}

-(void)close{
    // subclass hook override.
}

-(void)send:(NSString *)destination packet:(CPacket *)packet response:(void (^)(CPacket *packet))response{
    // subclass hook override.
}


@end

