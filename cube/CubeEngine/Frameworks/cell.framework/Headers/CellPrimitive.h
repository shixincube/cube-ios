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

#include "CellPrerequisites.h"
#include "CellStuff.h"

@interface CellPrimitive : NSObject

/*! @brief 语素清单。 */
@property (nonatomic, strong, readonly) NSMutableArray *stuffList;

/*! @brief 创建时的时间戳。 */
@property (nonatomic, assign, readonly) int64_t timestamp;

/*!
 * @brief 从原语创建。
 * @param primtive 指定原语。
 * @return 返回 @c CellPrimitive 实例。
 */
- (id)initWithPrimitive:(CellPrimitive *)primtive;

/*!
 * @brief 使用指定序号初始化。
 * @param sn 指定原语序号。
 * @return 返回 @c CellPrimitive 实例。
 */
- (id)initWithSN:(char *)sn;

/*!
 * @brief 获得原语的 SN 。
 * @return 返回4字节的 SN 。
 */
- (char *)getSN;

/*!
 * @brief 提交语素。
 * @param stuff 指定需提交的语素。
 */
- (void)commit:(CellStuff *)stuff;

/*!
 * @brief 获取指定索引位置处的语素。
 * @param index 指定索引。
 * @return 返回语素。
 */
- (CellStuff *)getStuff:(NSUInteger)index;

/*!
 * @brief 删除指定索引位置的语素。
 * @param index 指定索引。
 * @return 返回被删除的语素。
 */
- (CellStuff *)removeStuff:(NSUInteger)index;

/*!
 * @brief 获取当前原语包含的语素数量。
 * @return 返回当前原语包含的语素数量。
 */
- (NSUInteger)numStuff;

@end
