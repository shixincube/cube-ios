//
//  MessagingTest.m
//  CubeTests
//
//  Created by Ambrose Xu on 2021/8/30.
//

#import <XCTest/XCTest.h>
#import "../Cube/Engine/CEngine.h"

@interface MessagingTest : XCTestCase

@property (strong) CMessagingService * messaging;

@end

@implementation MessagingTest

- (void)setUp {
    NSLog(@"Cube Engine version: %@", [CEngine sharedInstance].version);
    
    XCTestExpectation* expect = [self expectationWithDescription:@"setUp"];
    
    CKernelConfig * config = [CKernelConfig configWithAddress:@"127.0.0.1"
                                                       domain:@"shixincube.com"
                                                       appKey:@"shixin-cubeteam-opensource-appkey"];

    [[CEngine sharedInstance] start:config success:^(CEngine * engine) {
        // 启动消息模块
        self.messaging = [engine getMessagingService];
        
        [expect fulfill];
    } failure:^(CError * error) {
        [expect fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0f handler:^(NSError * error) {
        NSLog(@"Started : %@", [[CEngine sharedInstance] hasStarted] ? @"YES" : @"NO");
    }];
}

- (void)tearDown {
}

- (void)testMessaging {
    
}

@end
