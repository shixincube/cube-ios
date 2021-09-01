//
//  CubeTests.m
//  CubeTests
//
//  Created by Ambrose Xu on 2021/6/28.
//

#import <XCTest/XCTest.h>
#import "../Cube/Util/NSString+Cube.h"
#import "../Cube/Messaging/Extension/CHyperTextMessage.h"

@interface CubeTests : XCTestCase

@end

@implementation CubeTests

- (void)setUp {
}

- (void)tearDown {
}

- (void)testParse {
    NSString * c1 = @"ABCD中国";
    CHyperTextMessage * message = [[CHyperTextMessage alloc] initWithText:c1];
    NSLog(@"%@ - |%@| %ld", c1, message.plaintext, message.formattedContents.count);

    NSString * c2 = @"时信魔方[E微笑#1007]";
    message = [[CHyperTextMessage alloc] initWithText:c2];
    NSLog(@"%@ - |%@| %ld", c2, message.plaintext, message.formattedContents.count);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
