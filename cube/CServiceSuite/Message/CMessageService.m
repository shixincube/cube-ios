//
//  CMessageService.m
//  CServiceSuite
//
//  Created by Ashine on 2020/9/2.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CMessageService.h"
#import "CContactService.h"
#import "CMessagePipelineListener.h"

static NSString *_name = @"message";

@interface CMessageService () <CPipelineListener> // to be optimized. use messagePipeline listener instead.

//@property (nonatomic , weak) <#type#> *<#name#>

@end

@implementation CMessageService

+(NSString *)mName{
    return _name;
}

-(CPipeline *)pipeline{
    return [[CKernel shareKernel] getPipeline:CCellPipeline.pName];
}

-(instancetype)init{
    if (self = [super initWithName:_name]) {
        [self.pipeline addListener:@"Messaging" listener:self];
    }
    return self;
}

-(void)sendToContact:(CContact *)contact message:(CMessage *)message{
    CContactService *contactService = (CContactService *)[[CKernel shareKernel] getModule:CContactService.mName];
    CContact *me = contactService.currentContact;
    
    message.from = me.contactId;
    message.to = contact.contactId;

    message.localTS = [[NSDate date] timeIntervalSince1970] * 1000;
    
    // TODO: put message into message sending queue.
    
    CPacket *packet = [[CPacket alloc] initWithName:@"push" data:[message toJson] sn:0];
    CCellPipeline *pipeline = (CCellPipeline *)self.pipeline;
    [pipeline send:@"Messaging" packet:packet response:^(CPacket *packet) {
        
    }];
}

- (void)triggerNotify:(NSDictionary *)payload{
    // trigger to observer
    NSLog(@"receive notify : %@",payload);
    
    CObserverState *state = [[CObserverState alloc] initWithName:@"Messaging" data:payload];
    [self notifyObservers:state];
}

- (void)triggerPull:(NSDictionary *)payload{
    // trigger to observer
    NSLog(@"receive pull : %@",payload);
}

#pragma mark - cpipeline listener
//接收消息
-(void)onReceived:(CPipeline *)pipeline source:(NSString *)source packet:(CPacket *)packet{
    if ([packet getStateCode] != 1000) {
        NSLog(@"get message pipeline error");
        return;
    }
    
    if ([packet.name isEqualToString:@"notify"]) {
        [self triggerNotify:packet.data];
    }
    else if ([packet.name isEqualToString:@"pull"]){
        [self triggerPull:packet.data];
    }
    
    
}

-(void)onError:(NSError *)error{
    
}




@end
