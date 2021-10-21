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

#ifndef CubeMessagePanelViewDelegate_h
#define CubeMessagePanelViewDelegate_h

#import <Foundation/Foundation.h>

@class CubeMessagePanelView;

@protocol CubeMessagePanelViewDelegate <NSObject>

- (void)messagePanelViewDidTouched:(CubeMessagePanelView *)panelView;

/*!
 * @brief 下拉刷新获取指定起始时间的消息记录。
 * @param panelView 消息面板。
 * @param beginningTime 起始时间。
 * @param count 数量。
 * @param completed 结果回调。
 */
- (void)getMessages:(CubeMessagePanelView *)panelView
  fromBeginningTime:(NSDate *)beginningTime
              count:(NSUInteger)count
          completed:(void (^)(NSDate *, NSArray *, BOOL))completed;


@optional

/*!
 * @brief 消息被删除。
 */
- (void)messagePanelView:(CubeMessagePanelView *)panelView
        didDeleteMessage:(CMessage *)message;

/*!
 * @brief 点击联系人头像。
 */
- (void)messagePanelView:(CubeMessagePanelView *)panelView
   didClickContactAvatar:(CContact *)contact;

/*!
 * @brief 点击消息。
 */
- (void)messagePanelView:(CubeMessagePanelView *)panelView
         didClickMessage:(CMessage *)message;

/*!
 * @brief 双击消息。
 */
- (void)messagePanelView:(CubeMessagePanelView *)panelView
   didDoubleClickMessage:(CMessage *)message;

@end

#endif /* CubeMessagePanelViewDelegate_h */
