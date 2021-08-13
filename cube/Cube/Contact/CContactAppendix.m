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

#import "CContactAppendix.h"
#import "CContact.h"
#import "CContactService+Core.h"

@interface CContactAppendix () {
    /*! 不对当前联系人进行提示的联系人。 */
    NSMutableArray * _noNoticeContacts;
    
    /*! 不对当前联系人进行提示的群组。 */
    NSMutableArray * _noNoticeGroups;
}

@property (nonatomic, weak) CContactService * service;

@end


@implementation CContactAppendix

- (instancetype)initWithService:(CContactService *)service contact:(CContact *)contact json:(NSDictionary *)json {
    if (self = [super init]) {
        self.service = service;
        _owner = contact;
        
        _remarkName = nil;

        if ([json objectForKey:@"remarkName"]) {
            _remarkName = [json valueForKey:@"remarkName"];
        }

        contact.appendix = self;
    }

    return self;
}

- (BOOL)hasRemarkName {
    return (nil != _remarkName && _remarkName.length > 0);
}

- (NSMutableDictionary *)toJSON {
    NSMutableDictionary * json = [[NSMutableDictionary alloc] init];
    if ([self hasRemarkName]) {
        [json setValue:_remarkName forKey:@"remarkName"];
    }
    return json;
}

- (NSMutableDictionary *)toCompactJSON {
    return [self toJSON];
}

@end
