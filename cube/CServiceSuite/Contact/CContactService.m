//
//  CContactService.m
//  CServiceSuite
//
//  Created by Ashine on 2020/10/12.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import "CContactService.h"
#import "CAuthService.h"
#import "CContact.h"
#import "CGroup.h"

static NSString *_mName = @"Contact";

@implementation CContactService

- (instancetype)init{
    if (self = [super initWithName:CContactService.mName]) {
    }
    return self;
}

+(NSString *)mName{
    return _mName;
}

-(CPipeline *)pipeline{
    return [[CKernel shareKernel] getPipeline:CCellPipeline.pName];
}

-(void)setCurrentContact:(CContact *)currentContact{
    _currentContact = currentContact;
    
    [self signIn:currentContact];
}


- (void)signIn:(CContact *)contact{
    
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *me = [[contact toJson] mutableCopy];
    
    CAuthService *auth = (CAuthService *)[[CKernel shareKernel] getModule:CAuthService.mName];
    
    // TODO: self object need here.
    CDevice *meDev = [[CDevice alloc] initWithName:@"memememe000" platform:@"iOS"];
    [me setObject:[meDev toJson] forKey:@"device"];
    [me setObject:auth.token.domain forKey:@"domain"]; // why need domain here ?
    
    [data setObject:me forKey:@"self"];
    
    [data setObject:[auth.token toJson] forKey:@"token"];
    
    CPacket *packet = [[CPacket alloc] initWithName:@"signIn" data:data sn:0];
    [((CCellPipeline *)self.pipeline) send:CContactService.mName packet:packet response:nil];
}

-(void)signOut{
    NSDictionary *data = [self.currentContact toJson];
    CPacket *packet = [[CPacket alloc] initWithName:@"signOut" data:data sn:0];
    [((CCellPipeline *)self.pipeline) send:CContactService.mName packet:packet response:nil];
    
    // TODO: clear current contact while callback with success code.
    _currentContact = nil;
}

-(void)createGroup:(NSString *)groupName memebers:(NSArray<CContact*>*)memebers{
        
    CGroup *group = [CGroup new];
    group.name = groupName;
    group.members = memebers;
    CPacket *packet = [[CPacket alloc] initWithName:@"createGroup" data:[group toJson] sn:0];
    [(CCellPipeline *)self.pipeline send:CContactService.mName packet:packet response:^(CPacket *packet) {
            
    }];
}



@end
