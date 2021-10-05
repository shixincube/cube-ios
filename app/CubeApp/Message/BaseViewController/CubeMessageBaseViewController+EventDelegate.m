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

#import "CubeMessageBaseViewController+EventDelegate.h"
#import "CubeMessageBaseViewController+PanelViewDelegate.h"

@implementation CubeMessageBaseViewController (EventDelegate)

- (void)sendTextMessage:(NSString *)text {
    CHyperTextMessage * message = [[CHyperTextMessage alloc] initWithText:text];
    if (self.contact) {
        [[CEngine sharedInstance].messagingService sendToContact:self.contact message:message];
    }
    else if (self.group) {
        // TODO
    }
    else {
        return;
    }

    [self appendToShowMessage:message];
}

#pragma mark - CMessagingEventDelegate

- (void)messageSending:(CMessage *)message service:(CMessagingService *)service {
    
}

- (void)messageSent:(CMessage *)message service:(CMessagingService *)service {
    
}

- (void)messageReceived:(CMessage *)message service:(CMessagingService *)service {
    if (self.contact && (message.from == self.contact.identity || message.to == self.contact.identity)) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self appendToShowMessage:message];
        });
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [[CEngine sharedInstance].messagingService markReadWithMessage:message handleSuccess:^(id  _Nullable data) {
                // Nothing
            } handleFailure:^(CError * _Nullable error) {
                // Nothing
            }];
        });
    }
//    else if (self.group && message.source == self.group.identity) {
//    }
}

@end
