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


#import "CMessage.h"
#import "CJsonableUtil.h"
#import <cell/cell.h>

@implementation CMessage

-(instancetype)initWithPayload:(NSDictionary *)payload{
    if (self = [super initWithLifeSpan:10 * 60 * 1000]) {
        self.messageId = [CellUtil generateUnsignedSerialNumber];
        self.entityId = 239948;
        self.domain = @"shixincube.com";
        self.payload = payload;
    }
    return self;
}

-(void)clone:(CMessage *)src{
    self.messageId = src.messageId;
    self.domain = src.domain;
    self.from = src.from;
    self.to = src.to;
    self.source = src.source;
    self.localTS = src.localTS;
    self.remoteTS = src.remoteTS;
    self.payload = src.payload;
    self.state = src.state;
}

#pragma mark - jsonable

-(NSDictionary *)toJson{
    return [CJsonableUtil translateObjectToJsonObject:self];
}

+(id)fromJson:(NSDictionary *)json{
    return [CJsonableUtil generateObjectOfClass:[self class] fromJsonObject:json];
}

+(NSDictionary *)keysMap{
    return @{
        @"messageId":@[@"id"],
        @"localTS":@[@"lts"],
        @"remoteTS":@[@"rts"],
    };
}





@end
