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

#import "CContactService+Core.h"
#import "CContactServiceState.h"
#import "CContactEvent.h"
#import "CError.h"
#import "CSelf.h"
#import "CUtils.h"

@implementation CContactService (Core)

- (void)listBlockList:(void (^)(NSArray *))handler {
    // TODO
    NSMutableArray * list = [[NSMutableArray alloc] init];
    handler(list);
}

- (void)listTopList:(void (^)(NSArray *))handler {
    // TODO
    NSMutableArray * list = [[NSMutableArray alloc] init];
    handler(list);
}

- (void)triggerSignIn:(int)code payload:(NSDictionary *)payload {
    if (code != CSC_Contact_Ok) {
        CObservableEvent * event = [[CObservableEvent alloc] initWithName:CContactEventFault data:[CError errorWithModule:CUBE_MODULE_CONTACT code:code]];
        [self notifyObservers:event];
        return;
    }

    if (self.myself) {
        [self.myself updateWithJSON:payload];
    }
    else {
        self.myself = [[CSelf alloc] initWithJSON:payload];
    }
    
    __block BOOL gotAppendix = FALSE;
    __block BOOL gotGroups = FALSE;
    __block BOOL gotBlockList = FALSE;
    __block BOOL gotTopList = FALSE;
    
    [self getAppendixWithContact:self.myself handleSuccess:^(CContact * contact, CContactAppendix * appendix) {
        gotAppendix = TRUE;
        if (gotGroups && gotBlockList && gotTopList) {
            [self fireSignInCompleted];
        }
    } handleFailure:^(CError * error) {
        if (gotGroups && gotBlockList && gotTopList) {
            [self fireSignInCompleted];
        }
    }];
    
    UInt64 now = [CUtils currentTimeMillis];
    [self listGroups:(now - self.defaultRetrospect) ending:now handler:^(NSArray * list) {
        gotGroups = TRUE;
        if (gotAppendix && gotBlockList && gotTopList) {
            [self fireSignInCompleted];
        }
    }];
    
    [self listBlockList:^(NSArray * list) {
        gotBlockList = TRUE;
        if (gotAppendix && gotGroups && gotTopList) {
            [self fireSignInCompleted];
        }
    }];
    
    [self listTopList:^(NSArray * list) {
        gotTopList = TRUE;
        if (gotAppendix && gotBlockList && gotGroups) {
            [self fireSignInCompleted];
        }
    }];
}

- (void)triggerSignOut {
    CObservableEvent * event = [[CObservableEvent alloc] initWithName:CContactEventSignOut data:self.myself];
    [self notifyObservers:event];
}

@end
