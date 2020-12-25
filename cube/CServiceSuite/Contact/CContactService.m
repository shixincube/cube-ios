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


#import "CContactService.h"
#import "CAuthService.h"
#import "CContact.h"
#import "CGroup.h"

static NSString *_name = @"Contact";

@implementation CContactService

- (instancetype)init{
    if (self = [super initWithName:CContactService.mName]) {
    }
    return self;
}

+(NSString *)mName{
    return _name;
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
