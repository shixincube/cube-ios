/*
This source file is part of Cell.

The MIT License (MIT)

Copyright (c) 2020 Shixin Cube Team.

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.
 
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
*/

#import "CellPrerequisites.h"

/*!
 * @brief 原语与会话上下文进行映射的封装结构。
 */
@interface CellPrimitiveCapsule : NSObject

/*!
 * @brief 对应的数据映射。
 */
@property (nonatomic, strong) NSMutableDictionary * data;

/*!
 * @brief 关联的会话。
 */
@property (nonatomic, strong) CellSession *session;

/*!
 * @brief 使用指定的会话构造。
 * @param session 消息层的会话上下文。
 * @return 返回 @c CellPrimitiveCapsule 实例。
 */
- (id)initWithSession:(CellSession *)session;

/*!
 * @brief 添加待管理原语。
 * @param cellet 目标 Cellet 名称。
 * @param primitive 原语。
 */
- (void)addPrimitive:(NSString *)cellet primitive:(CellPrimitive *)primitive;

/*!
 * @brief 移除原语。
 * @param cellet 目标 Cellet 名称。
 * @param sn 原语的序号。
 * @return 返回被移除的原语实例。
 */
- (CellPrimitive *)removePrimitive:(NSString *)cellet sn:(const char *)sn;

/*!
 * @brief 清空所有数据。
 */
- (void)clean;

@end
