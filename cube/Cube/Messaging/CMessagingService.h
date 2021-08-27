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

#ifndef CMessagingService_h
#define CMessagingService_h

#import "CModule.h"
#import "CContactService.h"

#ifndef CUBE_MODULE_MESSAGING
/*! @brief 模块名。 */
#define CUBE_MODULE_MESSAGING @"Messaging"
#endif


@class CMessagingPipelineListener;
@class CMessagingStorage;
@class CMessagingObserver;


/*!
 * @brief 消息模块。
 */
@interface CMessagingService : CModule {

@protected
    /*! 管道监听器。 */
    CMessagingPipelineListener * _pipelineListener;

    /*! 本地存储器。 */
    CMessagingStorage * _storage;
    
    /*! 其他模块的观察者。 */
    CMessagingObserver * _observer;
    
    BOOL _serviceReady;
}


/*!
 * @brief 初始化。
 */
- (instancetype)init;



/*!
 * @brief 进行数据加载。
 * @private
 */
- (void)prepare:(CContactService *)contactService;

@end

#endif /* CMessagingService_h */
