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
static NSString * const kSafeKey5 = @"kSafeKey5";
static NSString * const kSafeKey6 = @"kSafeKey6";


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

- (void)testEmptyAndUnsafe
{
	id empty = nil;
	NSNull *null = [NSNull null];
    
#pragma mark number
    NSNumber *returnNumber = @11;
	AGViewModel *numberVM = [AGViewModel newWithModel:nil];
	NSNumber *number1 = [numberVM ag_safeSetNumber:empty forKey:kSafeKey1];
	NSNumber *number2 = [numberVM ag_safeSetNumber:null forKey:kSafeKey2];
    NSNumber *number3 = [numberVM ag_safeSetNumber:empty forKey:kSafeKey3 completion:^(id  _Nullable value, BOOL safe) {
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
    }];
    NSNumber *number4 = [numberVM ag_safeSetNumber:null forKey:kSafeKey4 completion:^(id  _Nullable value, BOOL safe) {
        XCTAssertTrue(value == null, @"value传递出错!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
    }];
    NSNumber *number5 = [numberVM ag_safeNumberForKey:kSafeKey1];
    NSNumber *number6 = [numberVM ag_safeNumberForKey:kSafeKey2];
    NSNumber *number7 = [numberVM ag_safeNumberForKey:kSafeKey3 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return returnNumber;
    }];
    NSNumber *number8 = [numberVM ag_safeNumberForKey:kSafeKey4 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return returnNumber;
    }];
    
	XCTAssertTrue(number1 == nil, @"返回数据不对!");
	XCTAssertTrue(number2 == nil, @"返回数据不对!");
    XCTAssertTrue(number3 == nil, @"返回数据不对!");
    XCTAssertTrue(number4 == nil, @"返回数据不对!");
    XCTAssertTrue(number5 == nil, @"返回数据不对!");
    XCTAssertTrue(number5 == number6, @"返回数据不对!");
    XCTAssertTrue(number7 == returnNumber, @"返回数据不对!");
    XCTAssertTrue(number7 == number8, @"返回数据不对!");
	XCTAssertTrue(numberVM[kSafeKey1] == number1, @"错误数据存入字典!");
	XCTAssertTrue(numberVM[kSafeKey2] == number2, @"错误数据存入字典!");
    XCTAssertTrue(numberVM[kSafeKey3] == number3, @"错误数据存入字典!");
    XCTAssertTrue(numberVM[kSafeKey4] == number4, @"错误数据存入字典!");
    
    
    
#pragma mark string
    NSString *returnString = @"returnString";
    AGViewModel *stringVM = [AGViewModel newWithModel:nil];
    NSString *string1 = [stringVM ag_safeSetString:empty forKey:kSafeKey1];
    NSString *string2 = [stringVM ag_safeSetString:null forKey:kSafeKey2];
    NSString *string3 = [stringVM ag_safeSetString:empty forKey:kSafeKey3 completion:^(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
    }];
    NSString *string4 = [stringVM ag_safeSetString:null forKey:kSafeKey4 completion:^(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == null, @"value传递出错!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
    }];
    NSString *string5 = [stringVM ag_safeStringForKey:kSafeKey1];
    NSString *string6 = [stringVM ag_safeStringForKey:kSafeKey2];
    NSString *string7 = [stringVM ag_safeStringForKey:kSafeKey3 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return returnString;
    }];
    NSString *string8 = [stringVM ag_safeStringForKey:kSafeKey4 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return returnString;
    }];
    
    XCTAssertTrue(string1 == nil, @"返回数据不对!");
    XCTAssertTrue(string2 == nil, @"返回数据不对!");
    XCTAssertTrue(string3 == nil, @"返回数据不对!");
    XCTAssertTrue(string4 == nil, @"返回数据不对!");
    XCTAssertTrue(string5 == nil, @"返回数据不对!");
    XCTAssertTrue(string5 == string6, @"返回数据不对!");
    XCTAssertTrue(string7 == returnString, @"返回数据不对!");
    XCTAssertTrue(string7 == string8, @"返回数据不对!");
    XCTAssertTrue(stringVM[kSafeKey1] == string1, @"错误数据存入字典!");
    XCTAssertTrue(stringVM[kSafeKey2] == string2, @"错误数据存入字典!");
    XCTAssertTrue(stringVM[kSafeKey3] == string3, @"错误数据存入字典!");
    XCTAssertTrue(stringVM[kSafeKey4] == string4, @"错误数据存入字典!");
    
    
#pragma mark array
    NSArray *returnArray = @[@1, @2, @3];
    AGViewModel *arrayVM = [AGViewModel newWithModel:nil];
    NSArray *array1 = [arrayVM ag_safeSetArray:empty forKey:kSafeKey1];
    NSArray *array2 = [arrayVM ag_safeSetArray:null forKey:kSafeKey2];
    NSArray *array3 = [arrayVM ag_safeSetArray:empty forKey:kSafeKey3 completion:^(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
    }];
    NSArray *array4 = [arrayVM ag_safeSetArray:null forKey:kSafeKey4 completion:^(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == null, @"value传递出错!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
    }];
    NSArray *array5 = [arrayVM ag_safeArrayForKey:kSafeKey1];
    NSArray *array6 = [arrayVM ag_safeArrayForKey:kSafeKey2];
    NSArray *array7 = [arrayVM ag_safeArrayForKey:kSafeKey3 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return returnArray;
    }];
    NSArray *array8 = [arrayVM ag_safeArrayForKey:kSafeKey4 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return returnArray;
    }];
    
    XCTAssertTrue(array1 == nil, @"返回数据不对!");
    XCTAssertTrue(array2 == nil, @"返回数据不对!");
    XCTAssertTrue(array3 == nil, @"返回数据不对!");
    XCTAssertTrue(array4 == nil, @"返回数据不对!");
    XCTAssertTrue(array5 == nil, @"返回数据不对!");
    XCTAssertTrue(array5 == array6, @"返回数据不对!");
    XCTAssertTrue(array7 == returnArray, @"返回数据不对!");
    XCTAssertTrue(array7 == array8, @"返回数据不对!");
    XCTAssertTrue(arrayVM[kSafeKey1] == array1, @"错误数据存入字典!");
    XCTAssertTrue(arrayVM[kSafeKey2] == array2, @"错误数据存入字典!");
    XCTAssertTrue(arrayVM[kSafeKey3] == array3, @"错误数据存入字典!");
    XCTAssertTrue(arrayVM[kSafeKey4] == array4, @"错误数据存入字典!");
    
    
    
#pragma mark dictionary
    NSDictionary *returnDict = @{@"username" : @"jack"};
    AGViewModel *dictVM = [AGViewModel newWithModel:nil];
    NSDictionary *dict1 = [dictVM ag_safeSetDictionary:empty forKey:kSafeKey1];
    NSDictionary *dict2 = [dictVM ag_safeSetDictionary:null forKey:kSafeKey2];
    NSDictionary *dict3 = [dictVM ag_safeSetDictionary:empty forKey:kSafeKey3 completion:^(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
    }];
    NSDictionary *dict4 = [dictVM ag_safeSetDictionary:null forKey:kSafeKey4 completion:^(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == null, @"value传递出错!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
    }];
    NSDictionary *dict5 = [dictVM ag_safeDictionaryForKey:kSafeKey1];
    NSDictionary *dict6 = [dictVM ag_safeDictionaryForKey:kSafeKey2];
    NSDictionary *dict7 = [dictVM ag_safeDictionaryForKey:kSafeKey3 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return returnDict;
    }];
    NSDictionary *dict8 = [dictVM ag_safeDictionaryForKey:kSafeKey4 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return returnDict;
    }];
    
    XCTAssertTrue(dict1 == nil, @"返回数据不对!");
    XCTAssertTrue(dict2 == nil, @"返回数据不对!");
    XCTAssertTrue(dict3 == nil, @"返回数据不对!");
    XCTAssertTrue(dict4 == nil, @"返回数据不对!");
    XCTAssertTrue(dict5 == nil, @"返回数据不对!");
    XCTAssertTrue(dict5 == dict6, @"返回数据不对!");
    XCTAssertTrue(dict7 == returnDict, @"返回数据不对!");
    XCTAssertTrue(dict7 == dict8, @"返回数据不对!");
    XCTAssertTrue(dictVM[kSafeKey1] == dict1, @"错误数据存入字典!");
    XCTAssertTrue(dictVM[kSafeKey2] == dict2, @"错误数据存入字典!");
    XCTAssertTrue(dictVM[kSafeKey3] == dict3, @"错误数据存入字典!");
    XCTAssertTrue(dictVM[kSafeKey4] == dict4, @"错误数据存入字典!");
    
    
#pragma mark value type
    AGViewModel *valueTypeVM = [AGViewModel newWithModel:nil];
    valueTypeVM[kSafeKey1] = empty;
    valueTypeVM[kSafeKey2] = null;
    
    // double
    double returnDoubleValue = 11.123456789;
    double doubleValue = [valueTypeVM ag_safeDoubleValueForKey:kSafeKey1];
    XCTAssertTrue(doubleValue == 0, @"返回数据不对!");
    
    doubleValue = [valueTypeVM ag_safeDoubleValueForKey:kSafeKey2];
    XCTAssertTrue(doubleValue == 0, @"返回数据不对!");
    
    doubleValue = [valueTypeVM ag_safeDoubleValueForKey:kSafeKey1 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithDouble:returnDoubleValue];
    }];
    XCTAssertTrue(doubleValue == returnDoubleValue, @"返回数据不对!");
    
    doubleValue = [valueTypeVM ag_safeDoubleValueForKey:kSafeKey2 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == null, @"value传递出错!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithDouble:returnDoubleValue];
    }];
    XCTAssertTrue(doubleValue == returnDoubleValue, @"返回数据不对!");
    
    
    // float
    float returnFloatValue = 12.12;
    float floatValue = [valueTypeVM ag_safeFloatValueForKey:kSafeKey1];
    XCTAssertTrue(floatValue == 0, @"返回数据不对!");
    
    floatValue = [valueTypeVM ag_safeFloatValueForKey:kSafeKey2];
    XCTAssertTrue(floatValue == 0, @"返回数据不对!");
    
    floatValue = [valueTypeVM ag_safeFloatValueForKey:kSafeKey1 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithFloat:returnFloatValue];
    }];
    XCTAssertTrue(floatValue == returnFloatValue, @"返回数据不对!");
    
    floatValue = [valueTypeVM ag_safeFloatValueForKey:kSafeKey2 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == null, @"value传递出错!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithFloat:returnFloatValue];
    }];
    XCTAssertTrue(floatValue == returnFloatValue, @"返回数据不对!");
    
    
    // int
    int returnIntValue = 113114;
    int intValue = [valueTypeVM ag_safeIntValueForKey:kSafeKey1];
    XCTAssertTrue(intValue == 0, @"返回数据不对!");
    
    intValue = [valueTypeVM ag_safeIntValueForKey:kSafeKey2];
    XCTAssertTrue(intValue == 0, @"返回数据不对!");
    
    intValue = [valueTypeVM ag_safeIntValueForKey:kSafeKey1 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithInt:returnIntValue];
    }];
    XCTAssertTrue(intValue == returnIntValue, @"返回数据不对!");
    
    intValue = [valueTypeVM ag_safeIntValueForKey:kSafeKey2 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == null, @"value传递出错!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithInt:returnIntValue];
    }];
    XCTAssertTrue(intValue == returnIntValue, @"返回数据不对!");
    
    // NSInteger
    NSInteger returnIntegerValue = 168168;
    NSInteger integerValue = [valueTypeVM ag_safeIntegerValueForKey:kSafeKey1];
    XCTAssertTrue(integerValue == 0, @"返回数据不对!");
    
    integerValue = [valueTypeVM ag_safeIntegerValueForKey:kSafeKey2];
    XCTAssertTrue(integerValue == 0, @"返回数据不对!");
    
    integerValue = [valueTypeVM ag_safeIntegerValueForKey:kSafeKey1 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithInteger:returnIntegerValue];
    }];
    XCTAssertTrue(integerValue == returnIntegerValue, @"返回数据不对!");
    
    integerValue = [valueTypeVM ag_safeIntegerValueForKey:kSafeKey2 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == null, @"value传递出错!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithInteger:returnIntegerValue];
    }];
    XCTAssertTrue(integerValue == returnIntegerValue, @"返回数据不对!");
    
    // long long类型数据
    long long returnLongLongValue = 168168888;
    long long longlongValue = [valueTypeVM ag_safeLongLongValueForKey:kSafeKey1];
    XCTAssertTrue(longlongValue == 0, @"返回数据不对!");
    
    longlongValue = [valueTypeVM ag_safeLongLongValueForKey:kSafeKey2];
    XCTAssertTrue(longlongValue == 0, @"返回数据不对!");
    
    longlongValue = [valueTypeVM ag_safeLongLongValueForKey:kSafeKey1 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithLongLong:returnLongLongValue];
    }];
    XCTAssertTrue(longlongValue == returnLongLongValue, @"返回数据不对!");
    
    longlongValue = [valueTypeVM ag_safeLongLongValueForKey:kSafeKey2 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == null, @"value传递出错!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithLongLong:returnLongLongValue];
    }];
    XCTAssertTrue(longlongValue == returnLongLongValue, @"返回数据不对!");
    
    // BOOL类型数据
    BOOL returnBoolValue = YES;
    BOOL boolValue = [valueTypeVM ag_safeBoolValueForKey:kSafeKey1];
    XCTAssertTrue(boolValue == 0, @"返回数据不对!");
    
    boolValue = [valueTypeVM ag_safeBoolValueForKey:kSafeKey2];
    XCTAssertTrue(boolValue == 0, @"返回数据不对!");
    
    boolValue = [valueTypeVM ag_safeBoolValueForKey:kSafeKey1 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithBool:returnBoolValue];
    }];
    XCTAssertTrue(boolValue == returnBoolValue, @"返回数据不对!");
    
    boolValue = [valueTypeVM ag_safeBoolValueForKey:kSafeKey2 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == null, @"value传递出错!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return [NSNumber numberWithBool:returnBoolValue];
    }];
    XCTAssertTrue(boolValue == returnBoolValue, @"返回数据不对!");
    
    
#pragma mark number string
    NSString *returnNumberString = @"returnNumberString";
    NSString *numberString = [valueTypeVM ag_safeNumberStringForKey:kSafeKey1];
    XCTAssertTrue(numberString == nil, @"返回数据不对!");
    
    numberString = [valueTypeVM ag_safeNumberStringForKey:kSafeKey2];
    XCTAssertTrue(numberString == nil, @"返回数据不对!");
    
    numberString = [valueTypeVM ag_safeNumberStringForKey:kSafeKey1 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == nil, @"value必须为空!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return returnNumberString;
    }];
    XCTAssertTrue([numberString isEqualToString:returnNumberString], @"返回数据不对!");
    
    numberString = [valueTypeVM ag_safeNumberStringForKey:kSafeKey2 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == null, @"value传递出错!");
        XCTAssertTrue(safe == NO, @"数据判断不对!");
        return returnNumberString;
    }];
    XCTAssertTrue([numberString isEqualToString:returnNumberString], @"返回数据不对!");
}

- (void)testSafeNumber
{
    NSNumber *saveObj1 = @10086;
    NSNumber *saveObj2 = @2018;
    AGViewModel *vm = [AGViewModel newWithModel:nil];
    NSNumber *obj1 = [vm ag_safeSetNumber:saveObj1 forKey:kSafeKey1];
    XCTAssertTrue(obj1 == saveObj1, @"返回数据不对!");
    XCTAssertTrue(vm[kSafeKey1] == saveObj1, @"数据未存入字典!");
    
    obj1 = [vm ag_safeNumberForKey:kSafeKey1];
    XCTAssertTrue(obj1 == saveObj1, @"返回数据不对!");
    
    NSNumber *obj2 = [vm ag_safeSetNumber:saveObj2 forKey:kSafeKey2 completion:^(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == saveObj2, @"value传递出错!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
    }];
    XCTAssertTrue(obj2 == saveObj2, @"返回数据不对!");
    XCTAssertTrue(vm[kSafeKey2] == saveObj2, @"数据未存入字典!");
    
    obj2 = [vm ag_safeNumberForKey:kSafeKey2 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == saveObj2, @"value传递出错!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return value;
    }];
    XCTAssertTrue(obj2 == saveObj2, @"返回数据不对!");
}

- (void)testSafeString
{
    NSString *saveObj1 = @"10086";
    NSString *saveObj2 = @"2018";
    AGViewModel *vm = [AGViewModel newWithModel:nil];
    NSString *obj1 = [vm ag_safeSetString:saveObj1 forKey:kSafeKey1];
    XCTAssertTrue(obj1 == saveObj1, @"返回数据不对!");
    XCTAssertTrue(vm[kSafeKey1] == saveObj1, @"数据未存入字典!");
    
    obj1 = [vm ag_safeStringForKey:kSafeKey1];
    XCTAssertTrue(obj1 == saveObj1, @"返回数据不对!");
    
    NSString *obj2 = [vm ag_safeSetString:saveObj2 forKey:kSafeKey2 completion:^(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == saveObj2, @"value传递出错!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
    }];
    XCTAssertTrue(obj2 == saveObj2, @"返回数据不对!");
    XCTAssertTrue(vm[kSafeKey2] == saveObj2, @"数据未存入字典!");
    
    obj2 = [vm ag_safeStringForKey:kSafeKey2 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == saveObj2, @"value传递出错!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return value;
    }];
    XCTAssertTrue(obj2 == saveObj2, @"返回数据不对!");
	
}

- (void)testSafeNumberString
{
    NSString *saveObj1 = @"10086";
    NSNumber *saveObj2 = @2018;
    AGViewModel *vm = [AGViewModel newWithModel:nil];
    vm[kSafeKey1] = saveObj1;
    vm[kSafeKey2] = saveObj2;
    
    NSString *obj1 = [vm ag_safeNumberStringForKey:kSafeKey1];
    XCTAssertTrue([obj1 isEqualToString:saveObj1], @"返回数据不对!");
    obj1 = [vm ag_safeNumberStringForKey:kSafeKey2];
    XCTAssertTrue([obj1 isEqualToString:saveObj2.stringValue], @"返回数据不对!");
    
    NSString *obj2 = [vm ag_safeNumberStringForKey:kSafeKey1 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == saveObj1, @"value传递出错!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return value;
    }];
    XCTAssertTrue([obj2 isEqualToString:saveObj1], @"返回数据不对!");
    obj2 = [vm ag_safeNumberStringForKey:kSafeKey2 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == saveObj2, @"value传递出错!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return [NSString stringWithFormat:@"%@", value];
    }];
    XCTAssertTrue([obj2 isEqualToString:saveObj2.stringValue], @"返回数据不对!");
    
}

- (void)testSafeArray
{
    NSArray *saveObj1 = @[@1, @3, @5];
    NSArray *saveObj2 = @[@11, @33, @55];
    AGViewModel *vm = [AGViewModel newWithModel:nil];
    NSArray *obj1 = [vm ag_safeSetArray:saveObj1 forKey:kSafeKey1];
    XCTAssertTrue(obj1 == saveObj1, @"返回数据不对!");
    XCTAssertTrue(vm[kSafeKey1] == saveObj1, @"数据未存入字典!");
    
    obj1 = [vm ag_safeArrayForKey:kSafeKey1];
    XCTAssertTrue(obj1 == saveObj1, @"返回数据不对!");
    
    NSArray *obj2 = [vm ag_safeSetArray:saveObj2 forKey:kSafeKey2 completion:^(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == saveObj2, @"value传递出错!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
    }];
    XCTAssertTrue(obj2 == saveObj2, @"返回数据不对!");
    XCTAssertTrue(vm[kSafeKey2] == saveObj2, @"数据未存入字典!");
    
    obj2 = [vm ag_safeArrayForKey:kSafeKey2 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == saveObj2, @"value传递出错!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return value;
    }];
    XCTAssertTrue(obj2 == saveObj2, @"返回数据不对!");
	
}

- (void)testSafeDictionary
{
    NSDictionary *saveObj1 = @{@"username" : @"Kobe"};
    NSDictionary *saveObj2 = @{@"age" : @39};
    AGViewModel *vm = [AGViewModel newWithModel:nil];
    NSDictionary *obj1 = [vm ag_safeSetDictionary:saveObj1 forKey:kSafeKey1];
    XCTAssertTrue(obj1 == saveObj1, @"返回数据不对!");
    XCTAssertTrue(vm[kSafeKey1] == saveObj1, @"数据未存入字典!");
    
    obj1 = [vm ag_safeDictionaryForKey:kSafeKey1];
    XCTAssertTrue(obj1 == saveObj1, @"返回数据不对!");
    
    NSDictionary *obj2 = [vm ag_safeSetDictionary:saveObj2 forKey:kSafeKey2 completion:^(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == saveObj2, @"value传递出错!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
    }];
    XCTAssertTrue(obj2 == saveObj2, @"返回数据不对!");
    XCTAssertTrue(vm[kSafeKey2] == saveObj2, @"数据未存入字典!");
    
    obj2 = [vm ag_safeDictionaryForKey:kSafeKey2 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == saveObj2, @"value传递出错!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return value;
    }];
    XCTAssertTrue(obj2 == saveObj2, @"返回数据不对!");
}

- (void)testSafeValueType
{
    // value type
    double returnDoubleValue = 11.123456789;
    float returnFloatValue = 12.12;
    int returnIntValue = 113114;
    NSInteger returnIntegerValue = 168168;
    long long returnLongLongValue = 168168888;
    BOOL returnBoolValue = YES;
    
    AGViewModel *valueTypeVM = [AGViewModel newWithModel:nil];
    valueTypeVM[kSafeKey1] = [NSNumber numberWithDouble:returnDoubleValue];
    valueTypeVM[kSafeKey2] = [NSNumber numberWithFloat:returnFloatValue];
    valueTypeVM[kSafeKey3] = [NSNumber numberWithInt:returnIntValue];
    valueTypeVM[kSafeKey4] = [NSNumber numberWithInteger:returnIntegerValue];
    valueTypeVM[kSafeKey5] = [NSNumber numberWithLongLong:returnLongLongValue];
    valueTypeVM[kSafeKey6] = [NSNumber numberWithBool:returnBoolValue];
    
    // double
    double doubleValue = [valueTypeVM ag_safeDoubleValueForKey:kSafeKey1];
    XCTAssertTrue(doubleValue == returnDoubleValue, @"返回数据不对!");
    doubleValue = [valueTypeVM ag_safeDoubleValueForKey:kSafeKey1 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value != nil, @"value必须有值!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return value;
    }];
    XCTAssertTrue(doubleValue == returnDoubleValue, @"返回数据不对!");
    
    
    // float
    float floatValue = [valueTypeVM ag_safeFloatValueForKey:kSafeKey2];
    XCTAssertTrue(floatValue == returnFloatValue, @"返回数据不对!");
    floatValue = [valueTypeVM ag_safeFloatValueForKey:kSafeKey2 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value != nil, @"value必须有值!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return value;
    }];
    XCTAssertTrue(floatValue == returnFloatValue, @"返回数据不对!");
    
    // int
    int intValue = [valueTypeVM ag_safeIntValueForKey:kSafeKey3];
    XCTAssertTrue(intValue == returnIntValue, @"返回数据不对!");
    intValue = [valueTypeVM ag_safeIntValueForKey:kSafeKey3 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value != nil, @"value必须有值!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return value;
    }];
    XCTAssertTrue(intValue == returnIntValue, @"返回数据不对!");
    
    // NSInteger
    NSInteger integerValue = [valueTypeVM ag_safeIntegerValueForKey:kSafeKey4];
    XCTAssertTrue(integerValue == returnIntegerValue, @"返回数据不对!");
    integerValue = [valueTypeVM ag_safeIntegerValueForKey:kSafeKey4 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value != nil, @"value必须有值!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return value;
    }];
    XCTAssertTrue(integerValue == returnIntegerValue, @"返回数据不对!");
    
    // long long类型数据
    long long longlongValue = [valueTypeVM ag_safeLongLongValueForKey:kSafeKey5];
    XCTAssertTrue(longlongValue == returnLongLongValue, @"返回数据不对!");
    longlongValue = [valueTypeVM ag_safeLongLongValueForKey:kSafeKey5 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value != nil, @"value必须有值!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return value;
    }];
    XCTAssertTrue(longlongValue == returnLongLongValue, @"返回数据不对!");
    
    // BOOL类型数据
    BOOL boolValue = [valueTypeVM ag_safeBoolValueForKey:kSafeKey6];
    XCTAssertTrue(boolValue == returnBoolValue, @"返回数据不对!");
    boolValue = [valueTypeVM ag_safeBoolValueForKey:kSafeKey6 completion:^NSNumber * _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value != nil, @"value必须有值!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return value;
    }];
    XCTAssertTrue(boolValue == returnBoolValue, @"返回数据不对!");
	
}

- (void)testSafeURL
{
    NSString *saveObj1 = @"http://baidu.com";
    AGViewModel *vm = [AGViewModel newWithModel:nil];
    vm[kSafeKey1] = saveObj1;
    
    NSURL *obj1 = [vm ag_safeURLForKey:kSafeKey1];
    XCTAssertTrue([obj1 isKindOfClass:[NSURL class]], @"返回数据不对!");
    
    obj1 = [vm ag_safeURLForKey:kSafeKey1 completion:^id _Nullable(id  _Nullable value, BOOL safe) {
		
        XCTAssertTrue(value == saveObj1, @"value传递出错!");
        XCTAssertTrue(safe == YES, @"数据判断不对!");
        return [NSURL URLWithString:value];
    }];
    XCTAssertTrue([obj1 isKindOfClass:[NSURL class]], @"返回数据不对!");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
