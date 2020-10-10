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

#import "CellPrimitive.h"

@interface CellActionDialect : CellPrimitive

/*! @brief 动作名  */
@property (nonatomic, strong) NSString *name;


/*!
 * @brief 用于从原语构造。
 * @param primitive 原语。
 * @return 返回 @ref CellActionDialect 实例。
 */
- (id)initWithPrimitive:(CellPrimitive *)primitive;

/*!
 * @brief 构造函数。
 * @param name 动作名。
 * @return 返回 @ref CellActionDialect 实例。
 */
- (id)initWithName:(NSString *)name;

/*!
 * @brief 是否包含指定键的参数。
 * @param key 指定键。
 * @return 如果包含指定键返回 @c YES ，否则返回 @c NO 。
 */
- (BOOL)containsParam:(NSString *)key;

/*!
 * @brief 添加值为 @c NSString 类型的键值对参数。
 * @param key 指定键。
 * @param value 指定键对应的值。
 */
- (void)appendParam:(NSString *)key stringValue:(NSString *)value;

/*!
 * @brief添加值为 @c int 类型的键值对参数。
 * @param key 指定键。
 * @param value 指定键对应的值。
 */
- (void)appendParam:(NSString *)key intValue:(int)value;

/*!
 * @brief 添加值为  <code>long long</code>  类型的键值对参数。
 * @param key 指定键。
 * @param value 指定键对应的值。
 */
- (void)appendParam:(NSString *)key longlongValue:(long long)value;

/*!
 * @brief 添加值为 @c BOOL 类型的键值对参数。
 * @param key 指定键。
 * @param value 指定键对应的值。
 */
- (void)appendParam:(NSString *)key boolValue:(BOOL)value;

/*!
 * @brief 添加值为 @c float 类型的键值对参数。
 * @param key 指定键。
 * @param value 指定键对应的值。
 */
- (void)appendParam:(NSString *)key floatValue:(float)value;

/*!
 * @brief 添加值为 @c double 类型的键值对参数。
 * @param key 指定键。
 * @param value 指定键对应的值。
 */
- (void)appendParam:(NSString *)key doubleValue:(double)value;

/*!
 * @brief 添加值为 @c JSON 类型的键值对参数。
 * @param key 指定键。
 * @param value 指定键对应的值。
 */
- (void)appendParam:(NSString *)key json:(NSDictionary *)value;

/*!
 * @brief 获取指定键的字符串形式的参数值。
 * @param key 指定键。
 * @return 返回 @c NSString 形式的值。
 */
- (NSString *)getParamAsString:(NSString *)key;

/*!
 * @brief 获取指定键的整数形式的参数值。
 * @param key 指定键。
 * @return 返回 @c int 形式的值。
 */
- (int)getParamAsInt:(NSString *)key;

/*!
 * @brief 取指定键的长整型形式的参数值。
 * @param key 指定键。
 * @return 返回 @c long 形式的值。
 */
- (long)getParamAsLong:(NSString *)key;

/*!
 * @brief 取指定键的64位长整型形式的参数值。
 * @param key 指定键。
 * @return 返回 <code>long long</code> 形式的值。
 */
- (long long)getParamAsLongLong:(NSString *)key;

/*!
 * @brief 获取指定键的布尔型形式的参数值。
 * @param key 指定键。
 * @return 返回 @c BOOL 形式的值。
 */
- (BOOL)getParamAsBool:(NSString *)key;


/*!
 * @brief 获取指定键的 JSON 形式的参数值。
 * @param key 指定键。
 * @return 返回 @c NSDictionary 形式的值。
 */
- (NSDictionary *)getParamAsJson:(NSString *)key;

@end




