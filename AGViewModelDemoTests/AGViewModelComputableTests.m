//
//  AGViewModelComputableTests.m
//  AGViewModelDemoTests
//
//  Created by JohnnyB0Y on 2019/7/25.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AGVMKit.h"

static NSString * const kAGVMNumber1 = @"kAGVMNumber1";
static NSString * const kAGVMNumber2 = @"kAGVMNumber2";
static NSString * const kAGVMNumberPlus = @"kAGVMNumberPlus";
static NSString * const kAGVMNumberMinus = @"kAGVMNumberMinus";

@interface AGViewModelComputableTests : XCTestCase

@end

@implementation AGViewModelComputableTests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    AGViewModel *vm = ag_newAGViewModel(nil);
    
    [vm ag_setCommandBlock:^id _Nullable(AGVMCommand * _Nonnull command, AGViewModel * _Nonnull viewModel) {
        
        NSNumber *num1 = viewModel[kAGVMNumber1];
        NSNumber *num2 = viewModel[kAGVMNumber2];
        
        return @(num1.integerValue + num2.integerValue);
        
    } forKey:kAGVMNumberPlus];
    
    vm[kAGVMNumber1] = @(1);
    vm[kAGVMNumber2] = @(2);
    
    NSNumber *plus = vm[kAGVMNumberPlus];
    XCTAssertTrue(plus == nil, @"返回数据不对!");
    
    [vm ag_setNeedsExecuteCommandForKey:kAGVMNumberPlus];
    plus = [vm ag_executeCommandIfNeededForKey:kAGVMNumberPlus];
    XCTAssertTrue(plus.integerValue == 3, @"返回数据不对!");
    
    [vm ag_setCommandBlock:^id _Nullable(AGVMCommand * _Nonnull command, AGViewModel * _Nonnull viewModel) {
        
        NSNumber *plus = viewModel[kAGVMNumberPlus];
        NSNumber *num1 = viewModel[kAGVMNumber1];
        NSNumber *num2 = viewModel[kAGVMNumber2];
        
        return @(plus.integerValue - num1.integerValue - num2.integerValue);
    } forKey:kAGVMNumberMinus];
    
    NSNumber *minus = [vm ag_executeCommandForKey:kAGVMNumberMinus];
    XCTAssertTrue(minus.integerValue == 0, @"返回数据不对!");
    
    // ........
    AGViewModel *vm2 = ag_newAGViewModel(nil);
    vm2[kAGVMNumber1] = @(1);
    vm2[kAGVMNumber2] = @(2);
    
    [vm2 ag_setCommandBlock:^id _Nullable(AGVMCommand * _Nonnull command, AGViewModel * _Nonnull viewModel) {
        
        NSNumber *num1 = viewModel[kAGVMNumber1];
        NSNumber *num2 = viewModel[kAGVMNumber2];
        NSNumber *plus = viewModel[kAGVMNumberPlus]; // 累计
        
        return @(plus.integerValue + num1.integerValue + num2.integerValue);
        
    } forKey:kAGVMNumberPlus];
    
    NSNumber *plus2 = vm2[kAGVMNumberPlus];
    XCTAssertTrue(plus2 == nil, @"返回数据不对!");
    
    plus2 = [vm2 ag_executeCommandIfNeededForKey:kAGVMNumberPlus];
    XCTAssertTrue(plus2.integerValue == 3, @"返回数据不对!");
    
    plus2 = [vm2 ag_executeCommandIfNeededForKey:kAGVMNumberPlus];
    XCTAssertTrue(plus2.integerValue == 3, @"返回数据不对!");
    
    plus2 = [vm2 ag_executeCommandForKey:kAGVMNumberPlus];
    XCTAssertTrue(plus2.integerValue == 6, @"返回数据不对!");
    
    plus2 = [vm2 ag_executeCommandForKey:kAGVMNumberPlus];
    XCTAssertTrue(plus2.integerValue == 9, @"返回数据不对!");
    
    plus2 = [vm2 ag_executeCommandIfNeededForKey:kAGVMNumberPlus];
    XCTAssertTrue(plus2.integerValue == 9, @"返回数据不对!");
    
    plus2 = vm2[kAGVMNumberPlus];
    XCTAssertTrue(plus2.integerValue == 9, @"返回数据不对!");
    
    [vm2 ag_setNeedsExecuteCommandForKey:kAGVMNumberPlus];
    plus2 = [vm2 ag_executeCommandIfNeededForKey:kAGVMNumberPlus];
    XCTAssertTrue(plus2.integerValue == 12, @"返回数据不对!");
    
    plus2 = [vm2 ag_executeCommandIfNeededForKey:kAGVMNumberPlus];
    XCTAssertTrue(plus2.integerValue == 12, @"返回数据不对!");
    
    plus2 = [vm2 ag_executeCommandForKey:kAGVMNumberPlus];
    XCTAssertTrue(plus2.integerValue == 15, @"返回数据不对!");
    
    AGViewModel *vm3 = [vm2 mutableCopy];
    
    // vm2 删除
    [vm2 ag_removeCommandForKey:kAGVMNumberPlus];
    plus2 = [vm2 ag_executeCommandIfNeededForKey:kAGVMNumberPlus]; // 移除后，就直接取值
    XCTAssertTrue(plus2.integerValue == 15, @"返回数据不对!");
    plus2 = [vm2 ag_executeCommandForKey:kAGVMNumberPlus]; // 移除后，就直接取值
    XCTAssertTrue(plus2.integerValue == 15, @"返回数据不对!");
    
    // vm3 删除
    [vm3 ag_setNeedsExecuteCommandForKey:kAGVMNumberPlus];
    NSNumber *plus3 = [vm3 ag_executeCommandIfNeededForKey:kAGVMNumberPlus];
    XCTAssertTrue(plus3.integerValue == 18, @"返回数据不对!");
    
    [vm3 ag_setNeedsExecuteCommandForKey:kAGVMNumberPlus];
    [vm3 ag_removeCommandForKey:kAGVMNumberPlus];
    plus3 = [vm3 ag_executeCommandIfNeededForKey:kAGVMNumberPlus]; // 移除后，就直接取值
    XCTAssertTrue(plus3.integerValue == 18, @"返回数据不对!");
    plus3 = [vm3 ag_executeCommandForKey:kAGVMNumberPlus]; // 移除后，就直接取值
    XCTAssertTrue(plus3.integerValue == 18, @"返回数据不对!");
    
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
