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
 * @brief 日志等级。
 */
typedef enum _CellLogLevel
{
    /*! @brief Debug 等级。 */
    LL_DEBUG = 1,

    /*! @brief Info 等级。 */
    LL_INFO = 3,

    /*! @brief Warning 等级。 */
    LL_WARN = 5,

    /*! @brief Error 等级。 */
    LL_ERROR = 7

} CellLogLevel;


/*!
 * @brief 日志事件委派。
 */
@protocol CellLogDelegate <NSObject>

/*!
 * @brief 以 Debug 等级记录日志。
 * @param text 日志文本内容。
 */
- (void)logDebug:(NSString *)text;

/*!
 * @brief 以 Info 等级记录日志。
 * @param text 日志文本内容。
 */
- (void)logInfo:(NSString *)text;

/*!
 * @brief 以 Warning 等级记录日志。
 * @param text 日志文本内容。
 */
- (void)logWarn:(NSString *)text;

/*!
 * @brief 以 Error 等级记录日志。
 * @param text 日志文本内容。
 */
- (void)logError:(NSString *)text;

@end // CellLogDelegate


/*!
 * @brief 日志管理器。
 */
@interface CellLoggerManager : NSObject

/*! @brief 日志事件委派。 */
@property (nonatomic, strong) id<CellLogDelegate> delegate;

/*! @brief 当前日志级别。 */
@property (nonatomic, assign) CellLogLevel level;

/*!
 * @brief 返回日志管理器的单例。
 */
+ (CellLoggerManager *)sharedSingleton;

/*!
 * @brief 记录日志。
 * @param text 日志文本内容。
 * @param level 日志等级。
 */
- (void)log:(NSString *)text level:(CellLogLevel)level;

/*!
 * @brief 记录日志。
 * @param level 日志等级。
 * @param format 日志格式化文本内容。
 */
- (void)log:(CellLogLevel)level textFormat:(NSString *)format, ...;

@end
