//
//  AGViewModelDemoTests.m
//  AGViewModelDemoTests
//
//  Created by JohnnyB0Y on 2017/4/23.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AGVMKit.h"

static NSString * const kUserInfoFirstName = @"kUserInfoFirstName";
static NSString * const kUserInfoSecondName = @"kUserInfoSecondName";

@interface AGViewModelDemoTests : XCTestCase

/** user info */
@property (nonatomic, strong) NSDictionary *userInfo;

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
    NSMutableDictionary *dictM = ag_newNSMutableDictionary(5);
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

- (void) testVMArchive
{
    
}

- (void) testVMPackage
{
    NSArray *list = self.userInfo[@"data"];
    
    AGVMManager *vmm = ag_newAGVMManager(1);
    [vmm ag_packageSection:^(AGVMSection * _Nonnull vms) {
        [vms ag_packageItems:list inBlock:^(AGViewModel * _Nonnull package, id  _Nonnull obj, NSInteger idx) {
            package[kUserInfoFirstName] = obj[@"firstName"];
            package[kUserInfoSecondName] = obj[@"secondName"];
        }];
    } capacity:list.count];
    
    // 验证 section 的个数
    XCTAssertTrue(vmm.count == 1, @"section 个数不对!");
    
    // 验证 section 中 item 个数
    XCTAssertTrue(vmm.fs.count == list.count, @"section 中 item 个数不对!");
    
    // 验证 数据是否正确
    [vmm ag_enumerateSectionItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSIndexPath * _Nonnull indexPath, BOOL * _Nonnull stop) {
        // 原数据
        NSDictionary *user = list[indexPath.item];
        NSString *firstName = user[@"firstName"];
        NSString *secondName = user[@"secondName"];
        // 数据对比
        XCTAssertTrue([vm[kUserInfoFirstName] isEqualToString:firstName], @"firstName 数据不对!");
        XCTAssertTrue([vm[kUserInfoSecondName] isEqualToString:secondName], @"secondName 数据不对!");
    }];
    
    [vmm ag_enumerateSectionsUsingBlock:^(AGVMSection * _Nonnull vms, NSUInteger idx, BOOL * _Nonnull stop) {
        [vms ag_enumerateItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSUInteger idx, BOOL * _Nonnull stop) {
            // 原数据
            NSDictionary *user = list[idx];
            NSString *firstName = user[@"firstName"];
            NSString *secondName = user[@"secondName"];
            // 数据对比
            XCTAssertTrue([vm[kUserInfoFirstName] isEqualToString:firstName], @"firstName 数据不对!");
            XCTAssertTrue([vm[kUserInfoSecondName] isEqualToString:secondName], @"secondName 数据不对!");
        }];
    }];
    
}

- (void) testFastFuntion
{
	NSSet *set = [NSSet set];
	
	// 测试字典
	NSDictionary *dict = [NSDictionary dictionary];
	dict = ag_safeDictionary(dict);
	XCTAssertTrue(dict, @"ag_safeDictionary() 判断错误!");
	dict = ag_safeDictionary(set);
	XCTAssertTrue(dict == nil, @"ag_safeDictionary() 判断错误!");
	
	NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
	dictM = ag_safeMutableDictionary(dictM);
	XCTAssertTrue(dictM, @"ag_safeMutableDictionary() 判断错误!");
	dictM = ag_safeMutableDictionary(set);
	XCTAssertTrue(dictM == nil, @"ag_safeMutableDictionary() 判断错误!");
	
	
	// 测试数组
	NSArray *array = [NSArray array];
	array = ag_safeArray(array);
	XCTAssertTrue(array, @"ag_safeArray() 判断错误!");
	array = ag_safeArray(set);
	XCTAssertTrue(array == nil, @"ag_safeArray() 判断错误!");
	
	NSMutableArray *arrayM = [NSMutableArray array];
	arrayM = ag_safeMutableArray(arrayM);
	XCTAssertTrue(arrayM, @"ag_safeMutableArray() 判断错误!");
	arrayM = ag_safeMutableArray(set);
	XCTAssertTrue(arrayM == nil, @"ag_safeMutableArray() 判断错误!");
	
	
	// 测试字符串
	NSString *string = [NSString string];
	string = ag_safeString(string);
	XCTAssertTrue(string, @"ag_safeString() 判断错误!");
	string = ag_safeString(set);
	XCTAssertTrue(string == nil, @"ag_safeString() 判断错误!");
	
	// 测试数字类型
	NSNumber *number = [NSNumber numberWithBool:YES];
	number = ag_safeNumber(number);
	XCTAssertTrue(number, @"ag_safeNumber() 判断错误!");
	number = ag_safeNumber(set);
	XCTAssertTrue(number == nil, @"ag_safeNumber() 判断错误!");
	
}

#pragma mark - ---------- Private Methods ----------


#pragma mark - ----------- Getter Methods ----------
- (NSDictionary *)userInfo
{
    if (_userInfo == nil) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:3];
        NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:5];
        
        NSArray *firstNames = @[@"科比", @"凯文", @"特雷西", @"摩西", @"贝勒"];
        NSArray *secondNames = @[@"布莱恩特", @"加内特", @"麦格雷迪", @"马龙", @"爷"];
        
        for (NSInteger i = 0; i<firstNames.count; i++) {
            NSString *firstName = firstNames[i];
            NSString *secondName = secondNames[i];
            [arrM addObject:@{@"firstName" : firstName, @"secondName" : secondName}];
        }
        
        dictM[@"data"] = arrM;
        _userInfo = [dictM copy];
    }
    return _userInfo;
}

@end
