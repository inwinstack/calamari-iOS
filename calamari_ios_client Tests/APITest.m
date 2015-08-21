//
//  APITest.m
//  calamari_ios_client
//
//  Created by Francis on 2015/8/21.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "CephAPI.h"
#import "Cookies.h"
#import "ClusterData.h"
#import "APIRecord.h"

@interface APITest : XCTestCase {
    XCTestExpectation *_expectation;
}

@end

@implementation APITest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void) testURL {
    _expectation = [self expectationWithDescription:@"Login request"];
    [[CephAPI shareInstance] startGetSessionWithIP:@"10.20.0.21" Port:@"8008" Account:@"admin" Password:@"admin" completion:^(BOOL finished) {
        if (finished) {
            [[CephAPI shareInstance] startGetClusterListWithIP:@"10.20.0.21" Port:@"8008" completion:^(BOOL finished) {
                if (finished) {
                    for (NSDictionary *object in [ClusterData shareInstance].clusterArray ) {
                        [[CephAPI shareInstance] startGetClusterDetailWithIP:@"10.20.0.21" Port:@"8008" ClusterID:object[@"id"] completion:^(BOOL finished) {
                            if (finished) {
                                [[CephAPI shareInstance] startGetClusterDataWithIP:@"10.20.0.21" Port:@"8008" Version:[APIRecord shareInstance].APIDictionary[@"Space"][0] ClusterID:object[@"id"] Kind:[APIRecord shareInstance].APIDictionary[@"Space"][1] completion:^(BOOL finished) {
                                    if (finished) {
                                        [_expectation fulfill];
                                    }
                                } error:^(id error) {
                                    XCTFail(@"DidReceiveSpaceError:%@",error);
                                }];
                            }
                        } error:^(id error) {
                            XCTFail(@"DidReceiveDetailError:%@",error);
                        }];
                    }
                }
            } error:^(id error) {
                XCTFail(@"DidReceiveListError:%@", error);
            }];
        }
    } error:^(id error) {
        XCTFail(@"DidReceiveSessionError:%@", error);
    }];
    [self waitForExpectationsWithTimeout:30 handler:^(NSError *error) {
        if (error != nil) {
            XCTFail(@"login timeout error: %@", error);
        }
    }];
}

- (void)testExample {
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
