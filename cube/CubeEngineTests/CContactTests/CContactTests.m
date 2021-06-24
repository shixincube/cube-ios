//
//  CContactTests.m
//  CServiceSuiteTests
//
//  Created by Ashine on 2020/10/16.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CServiceSuite/CContactService.h>
#import <CServiceSuite/CServiceSuite.h>

@interface CContactTests : XCTestCase
@property (nonatomic , weak) CContactService *contact;
@end

@implementation CContactTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
    self.contact = [[CKernel shareKernel] getModule:CContactService.mName];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

//- (void)testSignIn{
//
//    CContact *me = [[CContact alloc] initWithId:1234567 domain:@"shixincube.com"];
//    me.name = @"wowowo1";
//    CDevice *device = [[CDevice alloc] initWithName:@"iOS" platform:@"ipod gold"];
//    [me addDevice:device];
//    [self.contact signIn:me];
//
//}



@end
