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

#import "CContactService+Core.h"
#import "CContactServiceState.h"
#import "CContactEvent.h"
#import "CError.h"
#import "CSelf.h"
#import "CUtils.h"
#import "CObservableEvent.h"

@implementation CContactService (Core)

- (void)listBlockList:(void (^)(NSArray *))handler {
    // TODO
    NSMutableArray * list = [[NSMutableArray alloc] init];
    handler(list);
}


- (void)triggerSignIn:(int)code payload:(NSDictionary *)payload {
//    NSLog(@"Trigger sign-in state: %d", code);

    if (code != CContactServiceStateOk) {
        CObservableEvent * event = [[CObservableEvent alloc] initWithName:CContactEventFault data:[CError errorWithModule:CUBE_MODULE_CONTACT code:code]];
        [self notifyObservers:event];
        return;
    }

    if (self.owner) {
        [self.owner updateWithJSON:payload];
    }
    else {
        self.owner = [[CSelf alloc] initWithJSON:payload];
    }

    __block BOOL gotAppendix = FALSE;
    __block BOOL gotGroups = FALSE;
    __block BOOL gotBlockList = FALSE;

    [self getAppendixWithContact:self.owner handleSuccess:^(CContact * contact, CContactAppendix * appendix) {
        gotAppendix = TRUE;
        NSLog(@"Got appendix");
        if (gotGroups && gotBlockList) {
            [self fireSignInCompleted];
        }
    } handleFailure:^(CError * error) {
        if (gotGroups && gotBlockList) {
            [self fireSignInCompleted];
        }
    }];

    UInt64 now = [CUtils currentTimeMillis];
    [self listGroups:(now - self.retrospectDuration) ending:now handler:^(NSArray * list) {
        gotGroups = TRUE;
        NSLog(@"List groups");
        if (gotAppendix && gotBlockList) {
            [self fireSignInCompleted];
        }
    }];

    [self listBlockList:^(NSArray * list) {
        gotBlockList = TRUE;
        NSLog(@"Got block list");
        if (gotAppendix && gotGroups) {
            [self fireSignInCompleted];
        }
    }];
}

- (void)triggerSignOut {
    CObservableEvent * event = [[CObservableEvent alloc] initWithName:CContactEventSignOut data:self.owner];
    [self notifyObservers:event];

    self.owner = nil;
}

@end
