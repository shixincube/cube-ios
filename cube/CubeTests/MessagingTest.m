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

@property (assign) UInt64 myId;

@end

@implementation MessagingTest

- (void)setUp {
    NSLog(@"setUp");
    
    NSLog(@"Cube Engine version: %@", [CEngine sharedInstance].version);
    
    XCTestExpectation* expect = [self expectationWithDescription:@"setUp"];
    
    self.myId = 50001001L;
    
    CKernelConfig * config = [CKernelConfig configWithAddress:@"127.0.0.1"
                                                       domain:@"shixincube.com"
                                                       appKey:@"shixin-cubeteam-opensource-appkey"];

    [[CEngine sharedInstance] start:config success:^(CEngine * engine) {
        NSLog(@"Engine start success");

        // 启动消息模块
        self.messaging = [engine getMessagingService];
        [self.messaging start];

        // 签入联系人
        CSelf * me = [engine signInWithId:self.myId];
        NSLog(@"SignIn : %lld", me.identity);

        [expect fulfill];
    } failure:^(CError * error) {
        NSLog(@"Engine start failure : %ld", error.code);
        
        [expect fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:^(NSError * error) {
        NSLog(@"Started : %@", [[CEngine sharedInstance] hasStarted] ? @"YES" : @"NO");
    }];
}

- (void)tearDown {
    NSLog(@"tearDown");
    
    [[CEngine sharedInstance] stop];
}

- (void)testMessaging {
    NSLog(@"testMessaging");
    
    
}

@end
