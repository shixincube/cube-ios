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

#ifndef CContact_h
#define CContact_h

#import "CAbstractContact.h"
#import "CDevice.h"
#import "CContactAppendix.h"

/*!
 * @brief 联系人实体。
 */
@interface CContact : CAbstractContact

/*! 当前有效的设备列表。 */
@property (nonatomic, strong, readonly) NSMutableArray<__kindof CDevice *> * devices;

/*! 联系人附录。 */
@property (nonatomic, strong) CContactAppendix * appendix;


/*!
 * @brief 初始化联系人。
 * @param identity 指定联系人 ID 。
 * @param name 指定联系人名称。
 * @param domain 指定联系人所在的域。
 * @return 返回对象实例。
 */
- (instancetype)initWithId:(UInt64)identity name:(NSString *)name domain:(NSString *)domain;

/*!
 * @brief 获取联系人优先显示的名称。
 * @return 返回联系人优先显示的名称。
 */
- (NSString *)getPriorityName;

/*!
 * @brief 添加联系人使用的设备。
 * @param device 设备描述。
 */
- (void)addDevice:(CDevice *)device;

/*!
 * @brief 移除联系人使用的设备。
 * @param device 设备描述。
 */
- (void)removeDevice:(CDevice *)device;

/*!
 * @brief 获取联系人的最近一次使用的设备。
 * @return 返回最近一次使用的设备。
 */
- (CDevice *)getDevice;

/*!
 * @brief 判断指定联系人实例是否于当前实例数据相同。
 * @return 如果联系人 ID 和域相同返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)isEqual:(id)object;

@end

#endif /* CContact_h */
