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

#import "CCellPipeline.h"

@interface CCellPipeline () {
    
    BOOL _opening;
    
    BOOL _enabled;
}

@property (nonatomic, strong) CellNucleus * nucleus;

@property (nonatomic, strong) NSMutableDictionary * responseMap;

- (CellActionDialect * )convertPacketToPrimitive:(CPacket *)packet;

- (CPacket *)convertPrimitiveToPacket:(CellActionDialect *)dialect;

- (void)retry:(UInt64)delayInMills;

@end


@implementation CCellPipeline

- (instancetype)init {
    if (self = [super initWithName:@"Cell"]) {
        _opening = FALSE;
        _enabled = FALSE;

        _nucleus = [[CellNucleus alloc] init];
        _nucleus.talkService.delegate = self;

        // 默认端口
        self.port = 7000;

        _responseMap = [[NSMutableDictionary alloc] init];
    }

    return self;
}

- (void)dealloc {
    [[CNetworkStatusManager sharedInstance] stopMonitoring];
}

- (void)open {
    if ([self isReady]) {
        return;
    }

    if (_opening) {
        return;
    }

    _opening = TRUE;
    
    _enabled = TRUE;

    [_nucleus.talkService call:self.address withPort:(int)self.port];

    // 监听网络状态
    [[CNetworkStatusManager sharedInstance] startMonitoring];
    [[CNetworkStatusManager sharedInstance] addDelegate:self];
}

- (void)close {
    // 解除监听
    [[CNetworkStatusManager sharedInstance] removeDelegate:self];

    _enabled = FALSE;

    [_nucleus.talkService hangup:self.address withPort:(int)self.port withNow:TRUE];
}

- (BOOL)isReady {
    return [_nucleus.talkService isCalled:self.address withPort:(int)self.port];
}

- (void)send:(NSString *)destination withPacket:(CPacket *)packet handleResponse:(void (^)(CPacket *))handleResponse {
    // 时间戳
    UInt64 timestamp = [[NSDate date] timeIntervalSince1970] * 1000;

    [self.responseMap setObject:@{
        @"destination": destination,
        @"handle": handleResponse,
        @"timestamp": [NSNumber numberWithUnsignedLongLong:timestamp]
    } forKey:[NSString stringWithFormat:@"%llu", packet.sn]];

    CellActionDialect * dialect = [self convertPacketToPrimitive:packet];
    [self.nucleus.talkService speak:destination withPrimitive:dialect];
}

- (void)send:(NSString *)destination withPacket:(CPacket *)packet {
    CellActionDialect * dialect = [self convertPacketToPrimitive:packet];
    [self.nucleus.talkService speak:destination withPrimitive:dialect];
}

#pragma mark - Private

- (CellActionDialect *)convertPacketToPrimitive:(CPacket *)packet {
    CellActionDialect * dialect = [[CellActionDialect alloc] initWithName:packet.name];
    [dialect appendParam:@"sn" longlongValue:packet.sn];
    [dialect appendParam:@"data" json:packet.data];
    if (nil != self.tokenCode) {
        [dialect appendParam:@"token" stringValue:self.tokenCode];
    }
    return dialect;
}

- (CPacket *)convertPrimitiveToPacket:(CellActionDialect *)dialect {
    CPacket * packet = [[CPacket alloc] initWithName:dialect.name
                                             andData:[dialect getParamAsJson:@"data"]
                                               andSN:[dialect getParamAsLongLong:@"sn"]];
    if ([dialect containsParam:@"state"]) {
        packet.state = [self extractState:[dialect getParamAsJson:@"state"]];
    }
    return packet;
}

- (void)retry:(UInt64)delayInMills {
    NSLog(@"Retry connect : %@:%d", self.address, (int)self.port);

    // 尝试重连
    [_nucleus.talkService hangup:self.address withPort:(int)self.port withNow:TRUE];

    // delayInMills 毫秒后重连
    dispatch_time_t delayInNanoSeconds = dispatch_time(DISPATCH_TIME_NOW, delayInMills * NSEC_PER_MSEC);
    dispatch_after(delayInNanoSeconds, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        if (![self->_nucleus.talkService isCalled:self.address withPort:(int)self.port]) {
            [self->_nucleus.talkService call:self.address withPort:(int)self.port];
        }
    });
}

#pragma mark - CNetworkStatusDelegate

- (void)networkStatusChanged:(CNetworkStatus)status {
    if (_enabled && (status == CNetworkStatusWWAN || status == CNetworkStatusWiFi)) {
        NSLog(@"Network status changed");
    }
}

#pragma mark - CellTalkListener

- (void)onListened:(CellSpeaker *)speaker cellet:(NSString *)cellet primitive:(CellPrimitive *)primitive {
    CellActionDialect * dialect = [[CellActionDialect alloc] initWithPrimitive:primitive];
    // 转为数据包格式
    CPacket *packet = [self convertPrimitiveToPacket:dialect];

    NSString * key = [NSString stringWithFormat:@"%llu", packet.sn];

    NSDictionary * responseEntity = [self.responseMap objectForKey:key];
    if (responseEntity) {
        void (^handle)(CPacket *) = responseEntity[@"handle"];
        handle(packet);
        [self.responseMap removeObjectForKey:key];
    }

    [super triggerListener:cellet packet:packet];
}

- (void)onSpoke:(CellSpeaker *)speaker cellet:(NSString *)cellet primitive:(CellPrimitive *)primitive {
    // Nothing
}

- (void)onContacted:(CellSpeaker *)speaker {
    _opening = FALSE;

    NSMutableArray<id<CPipelineListener>> * listeners = [self getAllListeners];
    for (id<CPipelineListener> listener in listeners) {
        if ([listener respondsToSelector:@selector(didOpen:)]) {
            [listener didOpen:self];
        }
    }
}

- (void)onQuitted:(CellSpeaker *)speaker {
    _opening = FALSE;
    
    NSMutableArray<id<CPipelineListener>> * listeners = [self getAllListeners];
    for (id<CPipelineListener> listener in listeners) {
        if ([listener respondsToSelector:@selector(didClose:)]) {
            [listener didClose:self];
        }
    }
}

- (void)onFailed:(CellSpeaker *)speaker error:(CellTalkError *)error {
    NSMutableArray<id<CPipelineListener>> * listeners = [self getAllListeners];
    for (id<CPipelineListener> listener in listeners) {
        if ([listener respondsToSelector:@selector(faultOccurred:code:desc:)]) {
            [listener faultOccurred:self code:error.errorCode desc:error.desc];
        }
    }

    if (_enabled) {
        if ([CNetworkStatusManager sharedInstance].networkStatus == CNetworkStatusWWAN
            || [CNetworkStatusManager sharedInstance].networkStatus == CNetworkStatusWiFi) {
            [self retry:1000];
        }
    }
}

@end
