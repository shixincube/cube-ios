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
 * @brief 消息会话描述。
 */
@interface CellSession : NSObject

/*!
 * @brief 指定消息服务实例和地址初始化。
 * @param address 会话连接的地址。
 * @return 返回 @ref CellSession 实例。
 */
- (id)initWithAddress:(CellInetAddress *)address;

/*!
 * @brief 获取会话的 ID 。
 * @return 返回会话的 ID 。
 */
- (int64_t)getId;

/*!
 * @brief 获取会话的网络地址。
 * @return 返回会话的网络地址。
 */
- (CellInetAddress *)getAddress;

/*!
 * @brief 是否是安全连接。
 * @return 如果当前连接是安全连接返回 @c YES  ，否则返回 @c NO  。
 */
- (BOOL)isSecure;

/*!
 * @brief 使用密钥激活加密模式。
 * @param key 指定密钥数据。
 * @param keyLength 指定密钥长度。
 * @return 激活成功返回 @c YES 。
 */
- (BOOL)activeSecretKey:(const char *)key keyLength:(int)keyLength;

/*!
 * @brief 吊销密钥，不使用加密模式。
 */
- (void)deactiveSecretKey;

/*!
 * @brief 获取安全密钥。
 * @return 返回安全密钥。
 */
- (const char *)getSecretKey;

/*!
 * @brief 获取安全密钥长度。
 * @return 返回安全密钥长度。
 */
- (int)getSecretKeyLength;

/*!
 * @brief 复制密钥，并返回密钥长度。
 * @param output 接收复制数据的缓存。
 * @return 返回密钥长度。
 */
- (int)copySecretKey:(char *)output;

@end
