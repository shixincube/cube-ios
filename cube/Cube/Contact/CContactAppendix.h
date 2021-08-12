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

#ifndef CContactAppendix_h
#define CContactAppendix_h

#import "CJSONable.h"

@class CContact;
@class CContactService;

/*!
 * @brief 联系人附录。
 */
@interface CContactAppendix : CJSONable

/*! 该联系人针对当前签入联系人的备注名。 */
@property (nonatomic, strong, readonly) NSString * remarkName;

/*!
 * @brief 初始化。
 * @param service 指定联系人服务。
 * @param contact 该附录关联的联系人。
 * @param json 包含数据的 JSON 结构。
 * @return 返回对象实例。
 */
- (instancetype)initWithService:(CContactService *)service Contact:(CContact *)contact json:(NSDictionary *)json;

/*!
 * @brief 是否设置了备注名。
 * @return 如果设置了备注名返回 @c TRUE 。
 */
- (BOOL)hasRemarkName;

@end

#endif /* CContactAppendix_h */
