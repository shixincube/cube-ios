/*
 * This file is part of Cube.
 *
 * The MIT License (MIT)
 *
 * Copyright (c) 2020-2022 Cube Team.
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

#ifndef CNetworkStatusManager_h
#define CNetworkStatusManager_h

#import <Foundation/Foundation.h>

/*!
 * @brief 网络状态枚举。
 */
typedef NS_ENUM(NSInteger, CNetworkStatus) {
    CNetworkStatusUnknown   = -1,
    CNetworkStatusNone      = 0,
    CNetworkStatusWWAN      = 1,
    CNetworkStatusWiFi      = 2
};

/*!
 * @brief 网络连接类型枚举。
 */
typedef NS_ENUM(NSInteger, CNetworkType) {
    CNetworkTypeUnknown = -1,
    CNetworkTypeNone    = 0,
    CNetworkTypeWiFi    = 1,
    CNetworkType2G      = 2,
    CNetworkType3G      = 3,
    CNetworkType4G      = 4,
    CNetworkType5G      = 5
};

/*!
 * @brief 网络详细类型枚举。
 */
typedef NS_ENUM(NSInteger, CNetworkDetailType) {
    CNetworkDetailTypeNOTREACHABLE  = -1,
    CNetworkDetailTypeUNKNOWN       = 0,
    CNetworkDetailTypeGPRS          = 1,
    CNetworkDetailTypeEDGE          = 2,
    CNetworkDetailTypeUMTS          = 3,
    CNetworkDetailTypeCDMA          = 4,
    CNetworkDetailTypeEVDO_0        = 5,
    CNetworkDetailTypeEVDO_A        = 6,
    CNetworkDetailType1xRTT         = 7,
    CNetworkDetailTypeHSDPA         = 8,
    CNetworkDetailTypeHSUPA         = 9,
    CNetworkDetailTypeHSPA          = 10,
    CNetworkDetailTypeIDEN          = 11,
    CNetworkDetailTypeEVDO_B        = 12,
    CNetworkDetailTypeLTE           = 13,
    CNetworkDetailTypeEHRPD         = 14,
    CNetworkDetailTypeHSPAP         = 15,
    CNetworkDetailTypeGSM           = 16,
    CNetworkDetailTypeTD_SCDMA      = 17,
    CNetworkDetailTypeIWLAN         = 18,
    CNetworkDetailTypeNRNSA         = 19,
    CNetworkDetailTypeNR            = 20,
    CNetworkDetailTypeWIFI          = 99
};


@protocol CNetworkStatusDelegate <NSObject>

- (void)networkStatusChanged:(CNetworkStatus)status;

@end


/*!
 * @brief 网络状态管理器。
 */
@interface CNetworkStatusManager : NSObject

/*! @brief 网络状态描述。 */
@property (nonatomic, assign, readonly) CNetworkStatus networkStatus;

/*! @brief 网络连接类型描述。 */
@property (nonatomic, assign, readonly) CNetworkType networkType;

/*! @brief 网络详细类型描述。 */
@property (nonatomic, assign, readonly) CNetworkDetailType networkDetailType;


/*!
 * @brief 获取对象单例。
 */
+ (CNetworkStatusManager *)sharedInstance;

/*!
 * @brief 开始网络状态监控。
 */
- (void)startMonitoring;

/*!
 * @brief 停止网络状态监控。
 */
- (void)stopMonitoring;

- (void)addDelegate:(id<CNetworkStatusDelegate>)delegate;

- (void)removeDelegate:(id<CNetworkStatusDelegate>)delegate;

@end

#endif /* CNetworkStatusManager_h */
