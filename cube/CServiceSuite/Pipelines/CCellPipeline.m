//
//  CCellPipeline.m
//  CServiceSuite
//
//  Created by Ashine on 2020/9/2.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CCellPipeline.h"
#import <cell/cell.h>


@interface CCellPipeline ()<CellTalkListener>
{
    BOOL _isReady;
}

@property (nonatomic , strong) CellNucleus *nucleus;

@property (nonatomic , strong) NSMutableDictionary *responseMap;

@end

@implementation CCellPipeline

@synthesize isReady = _isReady;

+ (instancetype)shareInstance{
    static dispatch_once_t onceToken;
    static CCellPipeline *cellPipeline = nil;
    dispatch_once(&onceToken, ^{
        cellPipeline = [[super allocWithZone:NULL] init];
        cellPipeline.nucleus = [[CellNucleus alloc] initWithConfig:nil];
        cellPipeline.nucleus.talkService.delegate = cellPipeline;
        cellPipeline.responseMap = [NSMutableDictionary dictionary];
    });
    return cellPipeline;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{
    return [self shareInstance];
}

-(instancetype)init{
    if (self = [super initWithName:@"cell"]) {
    }
    return self;
}

- (BOOL)_speakToCellet:(NSString *)cellet action:(NSString *)action params:(NSDictionary *)params{
    CellActionDialect *dialect = [[CellActionDialect alloc] initWithName:action];
    if (params) {
        [dialect appendParam:@"data" json:params[@"data"]];
        [dialect appendParam:@"sn" longlongValue:[params[@"sn"] longLongValue]];
    }
    NSLog(@"send to cellet : %@ , action : %@ , data : %@",cellet,action,params);
    return [self.nucleus.talkService speak:cellet withPrimitive:dialect];
}

@end


@implementation CCellPipeline (SubClassImp)

-(void)open{
    [super open];
    [self.nucleus.talkService call:@"192.168.1.113" withPort:7000 withCellets:@[]];
}

-(void)close{
    [super close];
    [self.nucleus.talkService hangup:@"192.168.1.113" withPort:7000 withNow:YES];
}

-(void)send:(NSString *)destination packet:(CPacket *)packet response:(void (^)(CPacket *packet))response{
    // parse packet
    // get cellet / action / params/
    NSDictionary *param = @{
        @"sn":[NSNumber numberWithLongLong:packet.sn],
        @"data":packet.data,
    };
    
    long timeStamp = [[NSDate date] timeIntervalSince1970] * 1000;
    
    NSString *sn = [NSString stringWithFormat:@"%ld",packet.sn];
    // put response into map cache.
    [self.responseMap setObject:@{
        @"destination":destination,
        @"handle":response,
        @"timestamp":[NSNumber numberWithLong:timeStamp],
        @"action":packet.name
    } forKey:sn];
    
    // TODO: ack time out process. remove response from map cache.
    
    [self _speakToCellet:destination action:packet.name params:param];
}

@end


@implementation CCellPipeline (CellTalkListener)

-(void)onListened:(CellSpeaker *)speaker cellet:(NSString *)cellet primitive:(CellPrimitive *)primitive{
    
    // convert primitive to packet
    // super trigger listeners
    CellActionDialect *action = [[CellActionDialect alloc] initWithPrimitive:primitive];
    
    NSLog(@"cell pipeline on listened destination : %@ , action : %@ , data : %@ ,sn : %ld",cellet,action.name,[action getParamAsJson:@"data"],[action getParamAsLong:@"sn"]);
    
    long sn = [action getParamAsLong:@"sn"];
    CPacket *packet = [CPacket new];
    packet.data = [action getParamAsJson:@"data"];
    packet.name = action.name;
    packet.sn = sn;
    NSDictionary *responseJson = [self.responseMap objectForKey:[NSString stringWithFormat:@"%ld",sn]];
    void (^response)(CPacket *) = responseJson[@"handle"];
    if (response) {
        [super triggerCallBack:cellet packet:packet callback:response];
    }
    [super triggerListener:cellet packet:packet];
}

-(void)onQuitted:(CellSpeaker *)speaker{
    NSLog(@"cell pipeline on quitted.");
}

-(void)onContacted:(CellSpeaker *)speaker{
    NSLog(@"cell pipeline on contacted.");
    _isReady = YES;
}

-(void)onFailed:(CellSpeaker *)speaker error:(CellTalkError *)error{
    NSLog(@"cell pipeline on failed.");
}

@end

