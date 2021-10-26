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
#ifndef CEventJitter_h
#define CEventJitter_h

#import <Foundation/Foundation.h>

@class CObservableEvent;
@class CContact;
@class CGroup;

/*!
 * @brief 用于抑制消息事件的抖动描述。
 */
@interface CEventJitter : NSObject

@property (nonatomic, weak) CContact * contact;

@property (nonatomic, weak) CGroup * group;

@property (atomic, assign) UInt64 timestamp;

@property (nonatomic, strong) CObservableEvent * event;

@property (nonatomic, weak, readonly) NSString * mapKey;

- (instancetype)initWithTimestamp:(UInt64)timestamp event:(CObservableEvent *)event;

@end

#endif /* CEventJitter_h */
