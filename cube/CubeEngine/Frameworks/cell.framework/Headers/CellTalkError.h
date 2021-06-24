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

#import "CellMessageService.h"

typedef enum _TalkError
{
    /*! @brief 网络一般错误。 */
    CellTalkErrorNetworkError = 1000,
    /*! @brief 网络链路错误。 */
    CellTalkErrorNetworkLinkError = 1010,
    /*! @brief 网络 Socket 错误。 */
    CellTalkErrorNetworkSocketError = 1020,
    /*! @brief 网络 I/O 错误。 */
    CellTalkErrorNetworkIOError = 1030,
    /*! @brief 心跳超时。 */
    CellTalkErrorHeartbeatTimeout = 1040,
    /*! @brief 握手错误。 */
    CellTalkErrorHandshakeError = 2000,
    /*! @brief 握手超时。 */
    CellTalkErrorHandshakeTimeout = 2001
    
} TalkError;

/*!
 * @brief 故障描述。
 */
@interface CellTalkError : NSObject

/*!
 * @brief 错误码。
 * @see TalkError
 */
@property (nonatomic, assign) NSInteger errorCode;

/*! @brief 故障描述信息。 */
@property (nonatomic, copy) NSString *desc;

/*!
 * @brief 将消息层错误代码转为错误描述。
 * @param messageError 消息错误码。
 * @return 返回错误描述 @c CellTalkError 。
 */
+ (CellTalkError *)transformError:(CellMessageErrorCode)messageError;

/*!
 * @brief 通过错误码和描述信息初始化。
 * @param code 错误码。
 * @param desc 描述信息。
 */
- (instancetype)initWithCode:(NSInteger)code andDesc:(NSString *)desc;

@end
