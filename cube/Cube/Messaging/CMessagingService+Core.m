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

#import "CMessagingService+Core.h"
#import "CMessagingEvent.h"
#import "CContactEvent.h"
#import "CContactService.h"
#import "CMessage.h"
#import "CMessagingStorage.h"
#import "CPluginSystem.h"
#import "CInstantiateHook.h"
#import "CUtils.h"

@implementation CMessagingService (Core)

- (void)fireContactEvent:(CObservableEvent *)event {
    if ([event.name isEqualToString:CContactEventSignIn] ||
        [event.name isEqualToString:CContactEventSelfReady]) {
        @synchronized (self) {
            if (!_serviceReady) {
                // 准备数据
                [self prepare:(CContactService *)event.subject completedHandler:^ {
                    // 服务就绪
                    self->_serviceReady = TRUE;

                    // 事件通知
                    CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventReady data:self];
                    [self notifyObservers:event];
                }];
            }
        }
    }
    else if ([event.name isEqualToString:CContactEventSignOut]) {
        _serviceReady = FALSE;
    }
}

- (void)triggerNotify:(NSDictionary *)messageJson {
    CMessage * message = [[CMessage alloc] initWithJSON:messageJson];

    // 填充消息相关实体对象
    [self fillMessage:message];

    // 数据写入数据库
    BOOL exists = [_storage updateMessage:message];

    if (message.remoteTS > _lastMessageTime) {
        _lastMessageTime = message.remoteTS;
    }

    // TODO 标准 Token

    if (!exists) {
        // 获取事件钩子
        CHook * hook = [self.pluginSystem getHook:CInstantiateHookName];
        CMessage * compMessage = [hook apply:message];

        CObservableEvent * event = [[CObservableEvent alloc] initWithName:CMessagingEventNotify data:compMessage];
        [self notifyObservers:event];
    }
}

- (void)triggerPull:(int)code payload:(NSDictionary *)payload {
    if (nil != _pullTimer) {
        [_pullTimer invalidate];

        // 触发回调，通知应用已收到服务器数据
        [self firePullCompletedHandler];

        _pullTimer = nil;
    }

    int total = [[payload valueForKey:@"total"] intValue];
    UInt64 beginning = [[payload valueForKey:@"beginning"] unsignedLongLongValue];
    UInt64 ending = [[payload valueForKey:@"ending"] unsignedLongLongValue];
    NSArray * messages = [payload valueForKey:@"messages"];

    NSLog(@"Pull messages total: %d # %llu - %llu", total, beginning, ending);

    for (NSDictionary * json in messages) {
        [self triggerNotify:json];
    }
}

@end
