//
//  CAuthTests.m
//  CServiceSuiteTests
//
//  Created by Ashine on 2020/10/16.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CServiceSuite/CAuthService.h>
#import <CServiceSuite/CServiceSuite.h>


#define Domain @"shixincube.com"
#define AppKey @"shixin-cubeteam-opensource-appkey"

@interface CAuthTests : XCTestCase

@property (nonatomic , weak) CAuthService *auth;

@end

@implementation CAuthTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.auth = [[CKernel shareKernel] getModule:CAuthService.mName];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)test1ApplyTokenTest{
    ///// test apply token
    XCTestExpectation *getTokenExpectation = [self expectationWithDescription:@"apply token success"];
    [self.auth applyToken:Domain appkey:AppKey completion:^(CAuthToken * _Nonnull token) {
        if (token) {
            [getTokenExpectation fulfill];
        }
    }];
    [self waitForExpectationsWithTimeout:5 handler:nil];
}


// test should be a unstateble function
//- (void)test2CheckTokenTest{
//
//    /// apply token
//
//    ////// test check token
//    XCTestExpectation *checkTokenExpectation = [self expectationWithDescription:@"check token"];
//
//    [self.auth checkToken:^{
//
//    } failure:^{
//
//    }];
//}




@end
