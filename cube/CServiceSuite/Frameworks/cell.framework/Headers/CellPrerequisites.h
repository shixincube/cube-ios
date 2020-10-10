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

#ifndef CellPrerequisites_h
#define CellPrerequisites_h

#import <Foundation/Foundation.h>
#import <UIKit/UIApplication.h>

#ifndef NULL
#define NULL 0
#endif

#pragma mark Servie Protocol

/*!
 * @brief 标准服务接口。
 */
@protocol CellService <NSObject>

/*!
 * @brief 启动服务。
 * @return 如果启动成功返回 @c YES 。
 */
- (BOOL)startup;

/*!
 * @brief 关闭服务。
 */
- (void)shutdown;

@end



/*!
 * @brief 对话者状态。
 */
typedef enum _CellSpeakState
{
    /*! @brief 连接已断开 */
    Disconnected = 0,

    /*! @brief 正在建立连接 */
    Connecting,

    /*! @brief 连接已建立 */
    Connected,

    /*! @brief 正在断开连接 */
    Disconnecting

} CellSpeakState;



// Util Group

@class CellLogger;
@class CellLoggerManager;
@class CellCryptology;
@class CellInetAddress;
@class CellMessage;
@class CellMessageConnector;
@class CellMessageService;
@class CellNonblockingConnector;
@class CellSession;
@class CellByteBuffer;


// API Group

@class CellNucleus;
@class CellNucleusConfig;
@class CellNucleusTag;
@class CellVersion;


// Talk Group

@class CellDialect;
@class CellDialectFactory;
@class CellActionDialect;
@class CellPrimitive;
@class CellStuff;
@class CellTalkService;
@class CellSpeaker;
@class CellTalkError;
@class CellPrimitiveCapsule;
@class CellHeartbeatContext;
@class CellHeartbeatMachine;
@class CellAcknowledgement;

#endif // CellPrerequisites_h
