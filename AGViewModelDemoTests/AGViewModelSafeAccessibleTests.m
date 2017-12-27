//
//  AGViewModelSafeAccessibleTests.m
//  AGViewModelDemoTests
//
//  Created by JohnnyB0Y on 2017/12/27.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  安全存取测试用例

#import <XCTest/XCTest.h>
#import "AGVMKit.h"

static NSString * const kSafeKey1 = @"kSafeKey1";
static NSString * const kSafeKey2 = @"kSafeKey2";
static NSString * const kSafeKey3 = @"kSafeKey3";
static NSString * const kSafeKey4 = @"kSafeKey4";



@interface AGViewModelSafeAccessibleTests : XCTestCase

@end

@implementation AGViewModelSafeAccessibleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testEmpty
{
	NSArray *empty = nil;
	NSNull *null = [NSNull null];
	// number
	AGViewModel *numberVM = [AGViewModel ag_viewModelWithModel:nil];
	NSArray *numberArr1 = [numberVM ag_safeSetNumber:empty forKey:kSafeKey1];
	NSArray *numberArr2 = [numberVM ag_safeSetNumber:null forKey:kSafeKey2];
	
	XCTAssertTrue(numberArr1 == nil, @"返回数据不对!");
	XCTAssertTrue(numberArr2 == nil, @"返回数据不对!");
	XCTAssertTrue(numberVM[kSafeKey1] == numberArr1, @"错误数据存入字典!");
	XCTAssertTrue(numberVM[kSafeKey2] == numberArr2, @"错误数据存入字典!");
	
	
	
}

- (void)testSafeNumber
{
	NSNumber *number = @1;
	NSString *string = @"2";
	
	AGViewModel *vm = [AGViewModel ag_viewModelWithModel:nil];
	// true
	NSNumber *newNumber = [vm ag_safeSetNumber:number forKey:kSafeKey1];
	XCTAssertTrue(newNumber == number, @"返回数据不对!");
	XCTAssertTrue(vm[kSafeKey1] == number, @"数据未存入字典!");
	// false
	NSNumber *newNumber2 = [vm ag_safeSetNumber:string forKey:kSafeKey2];
	XCTAssertTrue(newNumber2 == nil, @"返回数据不对!");
	XCTAssertTrue(vm[kSafeKey2] == nil, @"错误数据存入字典!");
	
	
	NSNumber *number2 = @3;
	NSString *string2 = @"4";
	// true
	NSNumber *newNumber3 = [vm ag_safeSetNumber:number2 forKey:kSafeKey3 completion:^(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == YES, @"数据判断不对!");
	}];
	XCTAssertTrue(newNumber3 == number2, @"返回数据不对!");
	
	// false
	NSNumber *newNumber4 = [vm ag_safeSetNumber:string2 forKey:kSafeKey4 completion:^(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == NO, @"数据判断不对!");
	}];
	XCTAssertTrue(vm[kSafeKey4] == nil, @"错误数据存入字典!");
	XCTAssertTrue(newNumber4 == nil, @"返回数据不对!");
	
	// 取
	NSNumber *newNumber5 = [vm ag_safeNumberForKey:kSafeKey1];
	NSNumber *newNumber6 = [vm ag_safeNumberForKey:kSafeKey2];
	XCTAssertTrue(newNumber5 == number, @"返回数据不对!");
	XCTAssertTrue(newNumber6 == nil, @"返回数据不对!");
	
	NSNumber *newNumber7 = [vm ag_safeNumberForKey:kSafeKey1 completion:^id _Nullable(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == YES, @"数据判断不对!");
		return nil;
	}];
	NSNumber *returnNum = @11;
	NSNumber *newNumber8 = [vm ag_safeNumberForKey:kSafeKey2 completion:^id _Nullable(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == NO, @"数据判断不对!");
		return returnNum;
	}];
	XCTAssertTrue(newNumber7 == number, @"返回数据不对!");
	XCTAssertTrue(newNumber8 == returnNum, @"返回数据不对!");
	
}

- (void)testSafeString
{
	NSNumber *number = @1;
	NSString *string = @"2";
	
	AGViewModel *vm = [AGViewModel ag_viewModelWithModel:nil];
	// true
	NSString *newString = [vm ag_safeSetString:string forKey:kSafeKey1];
	XCTAssertTrue(newString == string, @"返回数据不对!");
	XCTAssertTrue(vm[kSafeKey1] == string, @"数据未存入字典!");
	// false
	NSString *newString2 = [vm ag_safeSetString:number forKey:kSafeKey2];
	XCTAssertTrue(newString2 == nil, @"返回数据不对!");
	XCTAssertTrue(vm[kSafeKey2] == nil, @"错误数据存入字典!");
	
	
	NSNumber *number2 = @3;
	NSString *string2 = @"4";
	// true
	NSString *newString3 = [vm ag_safeSetString:string2 forKey:kSafeKey3 completion:^(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == YES, @"数据判断不对!");
	}];
	XCTAssertTrue(newString3 == string2, @"返回数据不对!");
	
	// false
	NSString *newString4 = [vm ag_safeSetString:number2 forKey:kSafeKey4 completion:^(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == NO, @"数据判断不对!");
	}];
	XCTAssertTrue(vm[kSafeKey4] == nil, @"错误数据存入字典!");
	XCTAssertTrue(newString4 == nil, @"返回数据不对!");
	
	// 取
	NSString *newString5 = [vm ag_safeStringForKey:kSafeKey1];
	NSString *newString6 = [vm ag_safeStringForKey:kSafeKey2];
	XCTAssertTrue(newString5 == string, @"返回数据不对!");
	XCTAssertTrue(newString6 == nil, @"返回数据不对!");
	
	NSString *newString7 = [vm ag_safeStringForKey:kSafeKey1 completion:^id _Nullable(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == YES, @"数据判断不对!");
		return nil;
	}];
	NSString *returnStr = @"11";
	NSString *newString8 = [vm ag_safeStringForKey:kSafeKey2 completion:^id _Nullable(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == NO, @"数据判断不对!");
		return returnStr;
	}];
	XCTAssertTrue(newString7 == string, @"返回数据不对!");
	XCTAssertTrue(newString8 == returnStr, @"返回数据不对!");
	
}

- (void)testSafeArray
{
	NSArray *arr = @[@1];
	NSDictionary *dict = @{@"2" : @2};
	
	AGViewModel *vm = [AGViewModel ag_viewModelWithModel:nil];
	// true
	NSArray *newArr = [vm ag_safeSetArray:arr forKey:kSafeKey1];
	XCTAssertTrue(newArr == arr, @"返回数据不对!");
	XCTAssertTrue(vm[kSafeKey1] == arr, @"数据未存入字典!");
	// false
	NSArray *newArr2 = [vm ag_safeSetArray:dict forKey:kSafeKey2];
	XCTAssertTrue(newArr2 == nil, @"返回数据不对!");
	XCTAssertTrue(vm[kSafeKey2] == nil, @"错误数据存入字典!");
	
	
	NSArray *arr2 = @[@3];
	NSDictionary *dict2 = @{@"4" : @4};
	// true
	NSArray *newArr3 = [vm ag_safeSetArray:arr2 forKey:kSafeKey3 completion:^(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == YES, @"数据判断不对!");
	}];
	XCTAssertTrue(newArr3 == arr2, @"返回数据不对!");
	
	// false
	NSArray *newString4 = [vm ag_safeSetArray:dict2 forKey:kSafeKey4 completion:^(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == NO, @"数据判断不对!");
	}];
	XCTAssertTrue(vm[kSafeKey4] == nil, @"错误数据存入字典!");
	XCTAssertTrue(newString4 == nil, @"返回数据不对!");
	
	// 取
	NSArray *newArr5 = [vm ag_safeArrayForKey:kSafeKey1];
	NSArray *newArr6 = [vm ag_safeArrayForKey:kSafeKey2];
	XCTAssertTrue(newArr5 == arr, @"返回数据不对!");
	XCTAssertTrue(newArr6 == nil, @"返回数据不对!");
	
	NSArray *newArr7 = [vm ag_safeArrayForKey:kSafeKey1 completion:^id _Nullable(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == YES, @"数据判断不对!");
		return nil;
	}];
	NSArray *returnArr = @[@11];
	NSArray *newArr8 = [vm ag_safeArrayForKey:kSafeKey2 completion:^id _Nullable(AGViewModel * _Nonnull vm, id  _Nullable value, BOOL safe) {
		XCTAssertTrue(safe == NO, @"数据判断不对!");
		return returnArr;
	}];
	XCTAssertTrue(newArr7 == arr, @"返回数据不对!");
	XCTAssertTrue(newArr8 == returnArr, @"返回数据不对!");
	
}

- (void)testSafeDictionary
{
	//NSDictionary *dict = @{@"test" : @"1"};
	
	
	
}

- (void)testSafeValueType
{
	
	
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
