//
//  KernelTest.m
//  CubeTests
//
//  Created by Ambrose Xu on 2021/8/2.
//

#import <XCTest/XCTest.h>
#import "../Cube/Core/CKernel.h"
#import "../Cube/Auth/CAuthService.h"
#import "../Cube/Contact/CContactService.h"
#import "../Cube/Contact/CSelf.h"

@interface KernelTest : XCTestCase

@property (nonatomic, strong) CKernel * kernel;

@property (nonatomic, strong) NSString * address;

@property (nonatomic, assign) UInt64 selfId;

@end

@implementation KernelTest

- (void)setUp {
    NSLog(@"setUp");
    
    self.address = @"127.0.0.1";
    self.selfId = 600100;

    self.kernel = [[CKernel alloc] init];

    CAuthService * auth = [[CAuthService alloc] init];
    [self.kernel installModule:auth];
    
    CContactService * contact = [[CContactService alloc] init];
    [self.kernel installModule:contact];
}

- (void)tearDown {
    NSLog(@"tearDown");
    [self.kernel shutdown];
}

- (void)testStartup {
    NSLog(@"testStartup");
    
    XCTestExpectation* expect = [self expectationWithDescription:@"Startup"];

    CKernelConfig * config = [[CKernelConfig alloc] initWithAddress:self.address
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

- (void)testSignIn {
    NSLog(@"testSignIn");
    
    NSAssert([self.kernel isReady], @"Kernel is NOT ready");
    
    CContactService * service = (CContactService *) [self.kernel getModule:CUBE_MODULE_CONTACT];
    
    XCTestExpectation* expect = [self expectationWithDescription:@"SignIn"];

    __block CError * cbueError = nil;

    [service signInWith:self.selfId name:@"CubeiOSTest" handleSuccess:^(CSelf * myself) {
        [expect fulfill];
    } handleFailure:^(CError * error) {
        cbueError = error;
        [expect fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:10.0f handler:^(NSError * error) {
        if (cbueError) {
            NSLog(@"Error : %d", (int)cbueError.code);
        }
        else {
            NSLog(@"SignIn is OK : %lld - %@", [service.myself getId], service.myself.name);
        }
    }];
}

@end
