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

#import "CNetworkStatusManager.h"
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

@interface CNetworkStatusManager ()

@property (atomic, assign) BOOL monitoring;

@property (nonatomic, strong) NSMutableArray< __kindof id<CNetworkStatusDelegate> > * delegates;

- (void)networkStatusChanged:(NSNotification *)notification;

- (void)networkReachabilityStatus:(AFNetworkReachabilityStatus)status;

@end


@implementation CNetworkStatusManager

@synthesize networkStatus = _networkStatus;
@synthesize networkDetailType = _networkDetailType;

+ (CNetworkStatusManager *)sharedInstance
{
    static CNetworkStatusManager * manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[CNetworkStatusManager alloc] init];
    });
    return manager;
}

- (instancetype)init {
    if (self = [super init]) {
        self.monitoring = FALSE;

        self.delegates = [[NSMutableArray alloc] init];

        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChanged:) name:CTServiceRadioAccessTechnologyDidChangeNotification object:nil];

        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
                [self networkReachabilityStatus:status];
            }];
    }

    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    [self.delegates removeAllObjects];
    self.delegates = nil;
}

- (void)startMonitoring {
    if (self.monitoring) {
        return;
    }

    self.monitoring = TRUE;

    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    [self networkReachabilityStatus:[AFNetworkReachabilityManager sharedManager].networkReachabilityStatus];
}

- (void)stopMonitoring {
    if (!self.monitoring) {
        return;
    }

    self.monitoring = FALSE;

    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)addDelegate:(id<CNetworkStatusDelegate>)delegate {
    if ([self.delegates containsObject:delegate]) {
        return;
    }

    [self.delegates addObject:delegate];
}

- (void)removeDelegate:(id<CNetworkStatusDelegate>)delegate {
    [self.delegates removeObject:delegate];
}

#pragma mark - Getters

- (CNetworkType)networkType {
    if (_networkStatus == CNetworkStatusNone) {
        return CNetworkTypeNone;
    }
    else if (_networkStatus == CNetworkStatusWiFi) {
        return CNetworkTypeWiFi;
    }

    switch (_networkDetailType) {
        case CNetworkDetailTypeNOTREACHABLE:
            return CNetworkTypeNone;
        case CNetworkDetailTypeEDGE:
        case CNetworkDetailTypeGPRS:
        case CNetworkDetailTypeCDMA:
            return CNetworkType2G;
        case CNetworkDetailTypeHSDPA:
        case CNetworkDetailTypeUMTS:
        case CNetworkDetailTypeHSUPA:
        case CNetworkDetailTypeEVDO_0:
        case CNetworkDetailTypeEVDO_A:
        case CNetworkDetailTypeEVDO_B:
        case CNetworkDetailTypeEHRPD:
            return CNetworkType3G;
        case CNetworkDetailTypeLTE:
            return CNetworkType4G;
        case CNetworkDetailTypeNRNSA:
        case CNetworkDetailTypeNR:
            return CNetworkType5G;
        case CNetworkDetailTypeWIFI:
            return CNetworkTypeWiFi;
        default:
            break;
    }

    return CNetworkTypeUnknown;
}

#pragma mark - Private

- (void)networkStatusChanged:(NSNotification *)notification {
    if (notification && notification.name && [notification.name isEqualToString:CTServiceRadioAccessTechnologyDidChangeNotification]) {
        NSString *netInfo = notification.object;
        if ([netInfo isEqualToString:CTRadioAccessTechnologyGPRS]) {
            _networkDetailType = CNetworkDetailTypeGPRS;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyEdge]) {
            _networkDetailType = CNetworkDetailTypeEDGE;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyWCDMA]) {
            _networkDetailType = CNetworkDetailTypeUMTS;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyHSDPA]) {
            _networkDetailType = CNetworkDetailTypeHSDPA;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyHSUPA]) {
            _networkDetailType = CNetworkDetailTypeHSUPA;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyCDMA1x]) {
            _networkDetailType = CNetworkDetailTypeCDMA;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyCDMAEVDORev0]) {
            _networkDetailType = CNetworkDetailTypeEVDO_0;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyCDMAEVDORevA]) {
            _networkDetailType = CNetworkDetailTypeEVDO_A;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyCDMAEVDORevB]) {
            _networkDetailType = CNetworkDetailTypeEVDO_B;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyeHRPD]) {
            _networkDetailType = CNetworkDetailTypeEHRPD;
        }
        else if ([netInfo isEqualToString:CTRadioAccessTechnologyLTE]) {
            _networkDetailType = CNetworkDetailTypeLTE;
        }
        else {
            if (@available(iOS 14.0, *)) {
                if ([netInfo isEqualToString:CTRadioAccessTechnologyNRNSA]) {
                    _networkDetailType = CNetworkDetailTypeNRNSA;
                }
                else if ([netInfo isEqualToString:CTRadioAccessTechnologyNR]) {
                    _networkDetailType = CNetworkDetailTypeNR;
                }
                else {
                    _networkDetailType = CNetworkDetailTypeUNKNOWN;
                }
            }
            else {
                _networkDetailType = CNetworkDetailTypeUNKNOWN;
            }
        }
    }
}

- (void)networkReachabilityStatus:(AFNetworkReachabilityStatus)status {
    switch (status) {
        case AFNetworkReachabilityStatusReachableViaWWAN:
            _networkStatus = CNetworkStatusWWAN;
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            _networkStatus = CNetworkStatusWiFi;
            break;
        case AFNetworkReachabilityStatusNotReachable:
            _networkStatus = CNetworkStatusNone;
            _networkDetailType = CNetworkDetailTypeNOTREACHABLE;
            break;
        case AFNetworkReachabilityStatusUnknown:
            _networkStatus = CNetworkStatusUnknown;
            break;
        default:
            break;
    }

    for (id<CNetworkStatusDelegate> delegate in self.delegates) {
        [delegate networkStatusChanged:_networkStatus];
    }
}

@end
