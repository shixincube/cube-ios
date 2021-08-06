//
//  KernelTest.m
//  CubeTests
//
//  Created by Ambrose Xu on 2021/8/2.
//

#import <XCTest/XCTest.h>
#import "CKernel.h"
#import "CAuthService.h"

@interface KernelTest : XCTestCase

@property (nonatomic, strong) CKernel * kernel;

@end

@implementation KernelTest

- (void)setUp {
    NSLog(@"setUp");
    self.kernel = [[CKernel alloc] init];

    CAuthService * auth = [[CAuthService alloc] init];
    [self.kernel installModule:auth];
}

- (void)tearDown {
    NSLog(@"tearDown");
    [self.kernel shutdown];
}

- (void)testStartup {
    NSLog(@"testStartup");
    
    XCTestExpectation* expect = [self expectationWithDescription:@"Startup"];

    CKernelConfig * config = [[CKernelConfig alloc] initWithAddress:@"127.0.0.1"
                                                             domain:@"shixincube.com"
                                                             appKey:@"shixin-cubeteam-opensource-appkey"];

    [self.kernel startup:config completion:^ {
        [expect fulfill];
    } failure:^(CError * error) {
        NSLog(@"Error : %@ - %ld", error.module, error.code);
        [expect fulfill];
    }];

    [self waitForExpectationsWithTimeout:5.0f handler:^(NSError * error) {
        NSLog(@"Ready : %@", [self.kernel isReady] ? @"YES" : @"NO");
    }];
}

@end
