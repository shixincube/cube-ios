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

/*!
 * @brief 网络地址描述。
 */
@interface CellInetAddress : NSObject

/*! @brief 网络主机名或主机地址。 */
@property (nonatomic, strong, readonly) NSString *host;
/*! @brief 网络端口号。 */
@property (nonatomic, assign, readonly) NSUInteger port;

/*!
 * @brief 按指定地址和端口号初始化。
 * @param host 网络主机名或地址。
 * @param port 网络主机端口号。
 * @return 对象实例。
 */
- (id)initWithAddress:(NSString *)host port:(NSUInteger)port;

/*!
 * @brief 获取主机地址字符串。
 * @return 返回主机地址字符串。
 */
- (NSString *)getHost;

/*!
 * @brief 获取主机端口号。
 * @return 返回主机端口号。
 */
- (NSUInteger)getPort;

@end
