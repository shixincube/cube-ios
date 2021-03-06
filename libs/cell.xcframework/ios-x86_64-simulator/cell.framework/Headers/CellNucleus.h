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
#import "CellTalkService.h"

/*!
 * @brief 内核对象。所有 API 对象的根入口。
 */
@interface CellNucleus : NSObject

/*! @brief 内核标签。 */
@property (nonatomic, strong, readonly) CellNucleusTag * tag;

/*! @brief 内核配置信息。 */
@property (nonatomic, strong, readonly) CellNucleusConfig * config;

/*! @brief 内核的会话服务。 */
@property (nonatomic, strong, readonly) CellTalkService * talkService;

/*!
 * @brief 初始化内核。
 */
- (id)init;

/*!
 * @brief 通过指定配置信息初始化内核。
 * @param config 指定配置信息。
 */
- (id)initWithConfig:(CellNucleusConfig *)config;

/*!
 * @brief 重置内核标签。
 */
- (void)resetTag;

/*!
 * @brief 销毁内核。
 */
- (void)destroy;

@end
