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

- (void) testVMPackage
{
    NSArray *list = self.userInfo[@"data"];
    
    AGVMManager *vmm = ag_VMManager(1);
    [vmm ag_packageSection:^(AGVMSection * _Nonnull vms) {
        [vms ag_packageItems:list inBlock:^(NSMutableDictionary * _Nonnull package, id  _Nonnull obj, NSUInteger idx) {
            package[kUserInfoFirstName] = obj[@"firstName"];
            package[kUserInfoSecondName] = obj[@"secondName"];
        }];
    } capacity:list.count];
    
    // 验证 section 的个数
    XCTAssertTrue(vmm.count == 1, @"section 个数不对!");
    
    // 验证 section 中 item 个数
    XCTAssertTrue(vmm.firstSection.count == list.count, @"section 中 item 个数不对!");
    
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
