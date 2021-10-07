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

#ifndef CubeMessageBarDelegate_h
#define CubeMessageBarDelegate_h

#import "CubeMessageBarDefinition.h"

@class CubeMessageBar;

@protocol CubeMessageBarDelegate <NSObject>

/*!
 * @brief 工作状态变更。
 */
- (void)messageBar:(CubeMessageBar *)messageBar changeStatusFrom:(CubeMessageBarStatus)fromStatus to:(CubeMessageBarStatus)toStatus;

/*!
 * @brief 输入框高度改变。
 */
- (void)messageBar:(CubeMessageBar *)messageBar didChangeTextViewHeight:(CGFloat)height;

/*!
 * @brief 发出文本。
 */
- (void)messageBar:(CubeMessageBar *)messageBar sendText:(NSString *)text;

/*!
 * @brief 加载草稿。
 */
- (void)messageBarLoadDraft:(CubeMessageBar *)messageBar completion:(void (^)(CMessageDraft * draft))completion;

/*!
 * @brief 保存草稿。
 */
- (void)messageBarSaveDraft:(CubeMessageBar *)messageBar draft:(CMessageDraft *)draft;

/*!
 * @brief 删除草稿。
 */
- (void)messageBarDeleteDraft:(CubeMessageBar *)messageBar;

- (void)messageBarStartRecording:(CubeMessageBar *)messageBar;

- (void)messageBarWillCancelRecording:(CubeMessageBar *)messageBar cancel:(BOOL)cancel;

- (void)messageBarDidCancelRecording:(CubeMessageBar *)messageBar;

- (void)messageBarFinishedRecoding:(CubeMessageBar *)messageBar;

@end

#endif /* CubeMessageBarDelegate_h */
