//
//  AGVMSection.h
//  
//
//  Created by JohnnyB0Y on 2017/7/10.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  一组 View Model 数据

#import "AGVMProtocol.h"
#import "AGViewModel.h"
#import "AGVMPackager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGVMSection : NSObject

@property (nonatomic, strong, readonly, nullable) AGViewModel *commonVM;

@property (nonatomic, strong, readonly, nullable) AGViewModel *headerVM;
@property (nonatomic, strong, readonly, nullable) AGViewModel *footerVM;

/** itemArr 中 viewModel 的共同数据模型 */
@property (nonatomic, strong, readonly, nullable) AGViewModel *itemCommonVM;
@property (nonatomic, strong, readonly, nullable) NSMutableArray<AGViewModel *> *itemArrM;
@property (nonatomic, assign, readonly) NSUInteger count;

@property (nonatomic, weak, readonly, nullable) AGViewModel *firstViewModel;
@property (nonatomic, weak, readonly, nullable) AGViewModel *lastViewModel;

/**
 fast create vms
 
 @param capacity itemArrM 每次增量拷贝的内存大小
 @return vms
 */
+ (instancetype) ag_VMSectionWithItemCapacity:(NSUInteger)capacity;
- (instancetype) initWithItemCapacity:(NSUInteger)capacity NS_DESIGNATED_INITIALIZER;

#pragma mark - 通过 packager 拼装数据
/** 通过 packager 拼装组头数据 */
- (AGViewModel *) ag_packageHeaderData:(NSDictionary *)data
                              packager:(id<AGVMPackagable>)packager
                             forObject:(nullable id)obj;

- (AGViewModel *) ag_packageHeaderData:(NSDictionary *)data
                              packager:(id<AGVMPackagable>)packager;

/** 通过 packager 拼装 item 数据 */
- (AGViewModel *) ag_packageItemData:(NSDictionary *)data
                            packager:(id<AGVMPackagable>)packager
                           forObject:(nullable id)obj;

- (AGViewModel *) ag_packageItemData:(NSDictionary *)data
                            packager:(id<AGVMPackagable>)packager;

/** 通过 packager 拼装组尾数据 */
- (AGViewModel *) ag_packageFooterData:(NSDictionary *)data
                              packager:(id<AGVMPackagable>)packager
                             forObject:(nullable id)obj;

- (AGViewModel *) ag_packageFooterData:(NSDictionary *)data
                              packager:(id<AGVMPackagable>)packager;

#pragma mark - 自己拼装数据 （不用担心循环引用问题）
/**
 拼装数据
 @param package 存放数据的字典 Block
 @param capacity 数据字典每次增量拷贝的内存大小
 */

/** 拼装 itemArr 中 viewModel 的共同数据模型 */
- (AGViewModel *) ag_packageItemCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                                  capacity:(NSUInteger)capacity;

/** 拼装组头数据 */
- (AGViewModel *) ag_packageHeaderData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                              capacity:(NSUInteger)capacity;

/** 拼装 item 数据 */
- (AGViewModel *) ag_packageItemData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                            capacity:(NSUInteger)capacity;

/** 拼装组尾数据 */
- (AGViewModel *) ag_packageFooterData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                              capacity:(NSUInteger)capacity;

/** 拼装公共数据 */
- (AGViewModel *) ag_packageCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                              capacity:(NSUInteger)capacity;

#pragma mark capacity 默认为 6
- (AGViewModel *) ag_packageHeaderData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;
- (AGViewModel *) ag_packageItemData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;
- (AGViewModel *) ag_packageFooterData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;
- (AGViewModel *) ag_packageCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;
- (AGViewModel *) ag_packageItemCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;


#pragma mark - 增删改查
#pragma mark 新增
- (AGVMSection *) ag_addItemsFromSection:(AGVMSection *)vms;
- (AGVMSection *) ag_addItemsFromArray:(NSArray<AGViewModel *> *)vmArr;
- (AGVMSection *) ag_addItem:(AGViewModel *)item;

#pragma mark 插入
- (AGVMSection *) ag_insertItemsFromSection:(AGVMSection *)vms
                                    atIndex:(NSUInteger)index;

- (AGVMSection *) ag_insertItemsFromArray:(NSArray<AGViewModel *> *)vmArr
                                  atIndex:(NSUInteger)index;

- (AGVMSection *) ag_insertItem:(AGViewModel *)item
                        atIndex:(NSUInteger)index;

- (AGVMSection *) ag_insertItemPackage:(NS_NOESCAPE AGVMPackageDataBlock)package
                               atIndex:(NSUInteger)index;

- (AGVMSection *) ag_insertItemPackage:(NS_NOESCAPE AGVMPackageDataBlock)package
                               atIndex:(NSUInteger)index
                              capacity:(NSUInteger)capacity;

#pragma mark 移除
- (AGVMSection *) ag_removeItemAtIndex:(NSUInteger)index;
- (AGVMSection *) ag_removeLastObject;
- (AGVMSection *) ag_removeAllItems;

#pragma mark 更新
- (AGVMSection *) ag_updateItemInBlock:(NS_NOESCAPE AGVMUpdateModelBlock)block
                               atIndex:(NSUInteger)index;

- (void) setObject:(AGViewModel *)vm
atIndexedSubscript:(NSUInteger)idx;

#pragma mark 取出
- (nullable AGViewModel *) objectAtIndexedSubscript:(NSUInteger)idx;

/**
 找出对应 key 的所有对象

 @param key 从 AGViewModel 取值的 key
 @return 找到的对象数组
 */
- (nullable NSArray *) ag_findValueInItemArrWithKey:(NSString *)key;

#pragma mark 合并
/** 合并 headerVM、 footerVM、 commonVM、itemCommonVM、itemArr */
- (AGVMSection *) ag_mergeFromSection:(AGVMSection *)vms;

#pragma mark 交换
- (AGVMSection *) ag_exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2;

#pragma mark 替换
- (AGVMSection *) ag_replaceItemAtIndex:(NSUInteger)index withItem:(AGViewModel *)item;

#pragma mark 遍历
/** 遍历所有 item */
- (AGVMSection *) ag_enumerateItemsUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel *vm, NSUInteger idx, BOOL *stop))block;

/** 遍历 header、footer vm */
- (AGVMSection *) ag_enumerateHeaderFooterVMsUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel *vm, NSUInteger idx, BOOL *stop))block;


// 不使用
- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

/** fast create AGVMSection instance */
AGVMSection * ag_VMSection(NSUInteger capacity);


NS_ASSUME_NONNULL_END
