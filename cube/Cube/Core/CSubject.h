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

#ifndef CSubject_h
#define CSubject_h

#import "CObserver.h"
#import "CObservableEvent.h"

@interface CSubject : NSObject

/*!
 * @brief 添加无事件观察者。
 * @param observer 指定观察者对象。
 */
- (void)attach:(CObserver *)observer;

/*!
 * @brief 添加指定事件名观察者。
 * @param name 指定事件名称。
 * @param observer 指定观察者对象。
 */
- (void)attachWithName:(NSString *)name observer:(CObserver *)observer;

/*!
 * @brief 移除无事件观察者。
 * @param observer 指定观察者对象。
 */
- (void)detach:(CObserver *)observer;

/*!
 * @brief 移除指定事件名观察者。
 * @param name 指定事件名称。
 * @param observer 指定观察者对象。
 */
- (void)detachWithName:(NSString *)name observer:(CObserver *)observer;

/*!
 * @brief 通知观察者有新事件更新。
 * @param event 指定新的事件。
 */
- (void)notifyObservers:(CObservableEvent *)event;

@end

#endif /* CSubject_h */
