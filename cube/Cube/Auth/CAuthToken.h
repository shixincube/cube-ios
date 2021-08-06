/**
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

#ifndef CAuthToken_h
#define CAuthToken_h

#import <Foundation/Foundation.h>
#import "../Util/CJSONable.h"

/*!
 * @brief 主访问主机信息。
 */
@interface CPrimaryDescription : CJSONable

/*! @brief 主机主地址。 */
@property (nonatomic, strong) NSString * address;

/*! @brief 主要配置内容描述。 */
@property (nonatomic, strong) NSDictionary * primaryContent;

/*!
 * @brief 使用服务器地址和主内容初始化。
 * @param address 主机主地址。
 * @param primaryContent 主要配置内容描述。
 * @return 返回实例。
 */
- (instancetype)initWithAddress:(NSString *)address primaryContent:(NSDictionary *)primaryContent;

/*!
 * @brief 使用 JSON 数据初始化。
 * @param json 指定 JSON 结构数据。
 * @return 返回实例。
 */
- (instancetype)initWithJSON:(NSDictionary *)json;

@end


/*!
 * @brief 授权访问的令牌。
 */
@interface CAuthToken : CJSONable
{
@private
    CPrimaryDescription * _description;
}

@property (nonatomic, strong) NSString * code;

@property (nonatomic, strong) NSString * domain;

@property (nonatomic, strong) NSString * appKey;

@property (nonatomic, assign) UInt64 cid;

@property (nonatomic, assign) UInt64 issues;

@property (nonatomic, assign) UInt64 expiry;

@property (nonatomic, strong) CPrimaryDescription * description;

/*!
 * @brief 使用 JSON 结构初始化数据。
 */
- (instancetype)initWithJSON:(NSDictionary *)json;

/*!
 * @brief 令牌是否有效。
 * @return 如果令牌有效返回 @c TRUE ，否则返回 @c FALSE 。
 */
- (BOOL)isValid;

@end

#endif /* CAuthToken_h */
