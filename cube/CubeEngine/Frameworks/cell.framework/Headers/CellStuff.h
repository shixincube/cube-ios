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
#include "CellLiteralBase.h"

@interface CellStuff : NSObject

/*! @brief 语素值的字面义。 */
@property (nonatomic, assign, readonly) CellLiteralBase literalBase;

/*!
 * @brief 初始化为字面义为字符串类型。
 * @param value 指定语义为字符串的数据。
 * @return 返回 @c CellStuff 实例。
 */
- (id)initWithString:(NSString *)value;

/*!
 * @brief 初始化为字面义为整数类型。
 * @param value 指定语义为整数的数据。
 * @return 返回 @c CellStuff 实例。
 */
- (id)initWithInt:(int)value;

/*!
 * @brief 初始化为字面义为长整数类型。
 * @param value 指定语义为长整数的数据。
 * @return 返回 @c CellStuff 实例。
 */
- (id)initWithLong:(long long)value;

/*!
 * @brief 初始化为字面义为浮点数类型。
 * @param value 指定语义为浮点数的数据。
 * @return 返回 @c CellStuff 实例。
 */
- (id)initWithFloat:(float)value;

/*!
 * @brief 初始化为字面义为双精浮点类型。
 * @param value 指定语义为双精浮点的数据。
 * @return 返回 @c CellStuff 实例。
 */
- (id)initWithDouble:(double)value;

/*!
 * @brief 初始化为字面义为布尔类型。
 * @param value 指定语义为布尔值的数据。
 * @return 返回 @c CellStuff 实例。
 */
- (id)initWithBool:(BOOL)value;

/*!
 * @brief 初始化为字面义为 JSON 对象类型。
 * @param value 指定语义为 JSON 对象的数据。
 * @return 返回 @c CellStuff 实例。
 */
- (id)initWithDictionary:(NSDictionary *)value;

/*!
 * @brief 初始化为字面义为 JSON 数组类型。
 * @param value 指定语义为 JSON 数组的数据。
 * @return 返回 @c CellStuff 实例。
 */
- (id)initWithArray:(NSArray *)value;

/*!
 * @brief 初始化为字面义为二进制类型。
 * @param value 指定语义为二进制的数据。
 * @return 返回 @c CellStuff 实例。
 */
- (id)initWithData:(NSData *)value;

/*!
 * @brief 初始化为指定字面义类型。
 * @param literal 指定字面义。
 * @param value 指定数据。
 * @param length 指定数据长度。
 * @return 返回 @c CellStuff 实例。
 */
- (id)initWithLiteral:(CellLiteralBase)literal value:(char *)value length:(NSUInteger)length;

/*!
 * @brief 按照二进制形式返回值。
 * @return 返回字节数组形式的二进制数据。
 */
- (NSData *)getValue;

/*!
 * @brief 按照字符串形式返回值。
 * @return 返回字符串数据。
 */
- (NSString *)getValueAsString;

/*!
 * @brief 按照整数形式返回值。
 * @return 返回整数数据。
 */
- (int)getValueAsInt;

/*!
 * @brief 按照长整数形式返回值。
 * @return 返回长整数数据。
 */
- (long long)getValueAsLong;

/*!
 * @brief 按照浮点数形式返回值。
 * @return 返回浮点数数据。
 */
- (float)getValueAsFloat;

/*!
 * @brief 按照双精浮点数形式返回值。
 * @return 返回双精浮点数数据。
 */
- (double)getValueAsDouble;

/*!
 * @brief 按照布尔值形式返回值。
 * @return 返回布尔值数据。
 */
- (BOOL)getValueAsBool;

/*!
 * @brief 按照 JSON 对象格式返回值。
 * @return 返回 JSON 对象数据。
 */
- (NSDictionary *)getValueAsDictionary;

/*!
 * @brief 按照 JSON 数组格式返回值。
 * @return 返回 JSON 数组数据。
 */
- (NSArray *)getValueAsArray;

@end
