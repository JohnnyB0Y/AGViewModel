//
//  AGViewModelDemoTests.m
//  AGViewModelDemoTests
//
//  Created by JohnnyB0Y on 2017/4/23.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AGVMKit.h"

@interface AGViewModelDemoTests : XCTestCase

@end

@implementation AGViewModelDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    // 打印数据
    NSDictionary *menber = @{@"title" : @"🐲", @"desc" : @"xxoo"};
    NSMutableDictionary *dictM = ag_mutableDict(5);
    dictM[@"class"] = @18;
    dictM[@"imageArr"] = @[@"image1", @"image2", @"image3"];
    dictM[@"user"] = @{@"name" : @"Jack", @"age" : @24.};
    dictM[@"menbers"] = @[menber, menber];
    
    [ag_sharedVMPackager() ag_resolveStaticKeyFromObject:dictM
                                              moduleName:@"AGTest"];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
