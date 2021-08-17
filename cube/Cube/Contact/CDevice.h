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

#ifndef CDevice_h
#define CDevice_h

#import "CJSONable.h"

/*!
 * @brief 设备描述。
 */
@interface CDevice : CJSONable

/*! 设备名。 */
@property (nonatomic, strong, readonly) NSString * name;

/*! 设备平台描述。 */
@property (nonatomic, strong, readonly) NSString * platform;

/*!
 * @brief 使用当前设备信息初始化。
 */
- (instancetype)init;

/*!
 * @brief 使用指定设备信息初始化。
 * @param name 指定设备名称。
 * @param platform 指定设备平台信息。
 */
- (instancetype)initWithName:(NSString *)name platform:(NSString *)platform;

/*!
 * @brief 从 JSON 数据格式创建设备对象实例。
 * @param json 指定设备的 JSON 数据。
 */
- (instancetype)initWithJSON:(NSDictionary *)json;

/*!
 * @brief 判断数据是否相同。
 * @return 如果数据相同返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)isEqual:(id)object;

/*!
 * @brief 从 JSON 数据格式创建设备对象实例。
 * @param json 指定设备的 JSON 数据。
 * @return 返回 @c CDevice 实例。
 */
+ (CDevice *)deviceWithJSON:(NSDictionary *)json;

@end

#endif /* CDevice_h */
