//
//  CPipelineTests.m
//  CServiceSuiteTests
//
//  Created by Ashine on 2020/10/16.
//  Copyright © 2020 Ashine. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CServiceSuite/CServiceSuite.h>


@interface CTListener : NSObject  <CPipelineListener>
@property (nonatomic , copy) NSString *name;

@end

@implementation CTListener

#pragma mark - cpipelinelistener

-(void)onReceived:(CPipeline *)pipeline source:(NSString *)source packet:(CPacket *)packet{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSLog(@"%@ received pipe line packet name : %@ , packet data : %@",self.name,packet.name,packet.data);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"PipelineOnReceived" object:self userInfo:@{@"name":packet.name,@"data":packet.data}];
    });
}

-(void)onError:(NSError *)error{
    
}

@end

@interface CPipelineTests : XCTestCase

@end

@implementation CPipelineTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)test0PipelineSetAddressAndPort{
    CPipeline *pipeline = [[CPipeline alloc] initWithName:@"test"];
    [pipeline setRemoteAddress:@"123.123.123.123" port:10086];
    XCTAssertEqualObjects(pipeline.address, @"123.123.123.123");
    XCTAssertEqual(pipeline.port, 10086);
}

- (void)test1PipelineAddListener{
    
    CTListener *listener1 = [CTListener new];
    listener1.name = @"listener1";
    
    CPipeline *pipeline = [[CPipeline alloc] initWithName:@"test"];
    [pipeline addListener:@"Pipe" listener:listener1];
    
    ///////////////// test get wrong pipe name
    NSArray *listeners = [pipeline getListener:@"pipe"];
    XCTAssertFalse(listeners.count);
    
    ///////////////// test get correct pipe
    NSArray *listeners1 = [pipeline getListener:@"Pipe"];
    XCTAssertTrue(listeners1.count);
    
    id <CPipelineListener> listenerget = listeners1.lastObject;
    XCTAssertEqualObjects(listener1, listenerget);
    
    
    ///////////// test add one more listener.
    CTListener *listener2 = [CTListener new];
    listener2.name = @"listener2";
    
    [pipeline addListener:@"Pipe" listener:listener2];
    
    NSArray *listeners2 = [pipeline getListener:@"Pipe"];
    XCTAssertEqual(listeners2.count, 2);
}

- (void)test2PipelineRemoveListener{
    CTListener *listener1 = [CTListener new];
    listener1.name = @"listener1";
    
    CTListener *listener2 = [CTListener new];
    listener2.name = @"listener2";
    
    CPipeline *pipeline = [[CPipeline alloc] initWithName:@"test"];
    [pipeline addListener:@"Pipe" listener:listener1];
    [pipeline addListener:@"Pipe" listener:listener2];
    
    /////////////// test remove listener1
    [pipeline removeListener:@"Pipe" listener:listener1];
    
    NSArray *listeners = [pipeline getListener:@"Pipe"];
    
    XCTAssertEqualObjects(listeners.lastObject, listener2);
    
    /////// test remove wrong name with listener.
    [pipeline removeListener:@"pipe" listener:listener2];
    XCTAssertEqualObjects(listeners.lastObject, listener2);
}


- (void)test3PipelineTriggerListenerWithPacket{
    
    
    ///Part 1 :  test add two listener and trigger them.
    {
        ///////////// new listener
        CTListener *listener1 = [CTListener new];
        listener1.name = @"listener1";

        CTListener *listener2 = [CTListener new];
        listener2.name = @"listener2";

        //////////// pipeline add listener
        CPipeline *pipeline = [[CPipeline alloc] initWithName:@"test"];
        [pipeline addListener:@"Pipe" listener:listener1];
        [pipeline addListener:@"Pipe" listener:listener2];

        //////////// new packet
        CPacket *packet = [[CPacket alloc] initWithName:@"packet1" data:@{@"name":@"test"} sn:0];

        [self expectationForNotification:@"PipelineOnReceived" object:listener1 handler:^BOOL(NSNotification * _Nonnull notification) {
            CTListener *li = [notification object];
            XCTAssertEqualObjects(li, listener1);
            return YES;
        }];

        [self expectationForNotification:@"PipelineOnReceived" object:listener2 handler:^BOOL(NSNotification * _Nonnull notification) {
            CTListener *li = [notification object];
            XCTAssertEqualObjects(li, listener2);
            return YES;
        }];

        ////////// trigger pipeline listener with packet
        [pipeline triggerListener:@"Pipe" packet:packet];

        [self waitForExpectationsWithTimeout:10 handler:^(NSError * _Nullable error) {
            if (error) {
                XCTFail(@"can't on received listener.");
            }
        }];
    }
    
    
    /// Part 2 : test add two listeners and remove all of them , test  trigger listener.
    {
        ///////////// new listener
        CTListener *listener1 = [CTListener new];
        listener1.name = @"listener1";

        CTListener *listener2 = [CTListener new];
        listener2.name = @"listener2";

        //////////// pipeline add listener
        CPipeline *pipeline = [[CPipeline alloc] initWithName:@"test"];
        [pipeline addListener:@"Pipe" listener:listener1];
        [pipeline addListener:@"Pipe" listener:listener2];

        //////////// new packet
        CPacket *packet = [[CPacket alloc] initWithName:@"packet1" data:@{@"name":@"test"} sn:0];

        ///////  remove all listeners and trigger test again.
        [pipeline removeListener:@"Pipe" listener:listener1];
        [pipeline removeListener:@"Pipe" listener:listener2];

        ////// trigger test.
        [pipeline triggerListener:@"Pipe" packet:packet];

        XCTestExpectation *listenerExpectation = [self expectationForNotification:@"PipelineOnReceived" object:nil handler:nil];

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [listenerExpectation fulfill];
        });

        [self waitForExpectationsWithTimeout:6 handler:nil];
    }
    
    
    /// Part 3 : test trigger packet validate.
    {
        ///////////// new listener
        CTListener *listener = [CTListener new];
        listener.name = @"listener";
        
        //////////// pipeline add listener
        CPipeline *pipeline = [[CPipeline alloc] initWithName:@"test"];
        [pipeline addListener:@"Pipe" listener:listener];
        
        //////////// new packet
        NSDictionary *data = @{@"name":@"test"};
        CPacket *packet = [[CPacket alloc] initWithName:@"TESTPACKET" data:data sn:0];
        
        ////// trigger test.
        [pipeline triggerListener:@"Pipe" packet:packet];
        
        [self expectationForNotification:@"PipelineOnReceived" object:listener handler:^BOOL(NSNotification * _Nonnull notification) {
            NSDictionary *userInfo = notification.userInfo;
            XCTAssertEqualObjects(userInfo[@"data"], data);
            XCTAssertEqualObjects(userInfo[@"name"], @"TESTPACKET");
            return YES;
        }];
        
        [self waitForExpectationsWithTimeout:5 handler:nil];
    }
}

- (void)test4PipelineTriggerListenerCallback{
    ///
    {
        //////////// pipeline add listener
        CPipeline *pipeline = [[CPipeline alloc] initWithName:@"test"];
        
        //////////// new packet
        NSDictionary *data = @{@"name":@"test"};
        CPacket *packet = [[CPacket alloc] initWithName:@"TESTPACKET" data:data sn:0];
        
        XCTestExpectation *waitExpatation = [self expectationWithDescription:@"triggerCallBackExpectation"];
        
        [pipeline triggerCallBack:@"Pipe" packet:packet callback:^(CPacket *p) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                XCTAssertEqualObjects(p.name, packet.name);
                XCTAssertEqualObjects(p.data, packet.data);
                [waitExpatation fulfill];
            });
        }];
        
        [self waitForExpectationsWithTimeout:3 handler:nil];
    }
}

@end
