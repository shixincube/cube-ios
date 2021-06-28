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

#ifndef CellLiteralBase_h
#define CellLiteralBase_h

/*!
 * @brief 原语语素字面义定义。
 */
typedef enum _CellLiteralBase
{
    /*! @brief 字符串类型。 */
    CCLiteralBaseString = 'S',

    /*! @brief 整数型。 */
    CCLiteralBaseInt = 'I',

    /*! @brief 长整型。 */
    CCLiteralBaseLong = 'L',

    /*! @brief 浮点型。 */
    CCLiteralBaseFloat = 'F',

    /*! @brief 双精浮点型。 */
    CCLiteralBaseDouble = 'D',

    /*! @brief 布尔型。 */
    CCLiteralBaseBool = 'B',

    /*! @brief JSON 类型。 */
    CCLiteralBaseJSON = 'J',

    /*! @brief 二进制类型。 */
    CCLiteralBaseBin = 'N'

} CellLiteralBase;

/*!
 * @brief 解析字面义。
 * @param code 字面义编码。
 * @return 返回 @c CellLiteralBase 描述的字面义。
 */
CellLiteralBase parseLiteralBase(char code);

#endif /* CellLiteralBase_h */
