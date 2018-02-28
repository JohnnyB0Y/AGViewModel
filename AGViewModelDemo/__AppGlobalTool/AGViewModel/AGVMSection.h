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

@interface AGVMSection : NSObject <NSCopying, NSMutableCopying>
/** common vm */
@property (nonatomic, strong, readonly, nullable, getter=cvm) AGViewModel *commonVM;

@property (nonatomic, strong, readonly, nullable) AGViewModel *headerVM;
@property (nonatomic, strong, readonly, nullable) AGViewModel *footerVM;

/** 会合并到 itemArr中的每个viewModel */
@property (nonatomic, strong, readonly, nullable) AGViewModel *itemMergeVM;
@property (nonatomic, strong, readonly, nullable) NSMutableArray<AGViewModel *> *itemArrM;
@property (nonatomic, assign, readonly) NSInteger count;

/** first item vm */
@property (nonatomic, weak, readonly, nullable, getter=fvm) AGViewModel *firstViewModel;
/** last item vm */
@property (nonatomic, weak, readonly, nullable, getter=lvm) AGViewModel *lastViewModel;

/**
 Quickly create vms
 
 @param capacity itemArrM 每次增量拷贝的内存大小
 @return vms
 */
+ (instancetype) newWithItemCapacity:(NSInteger)capacity;
- (instancetype) initWithItemCapacity:(NSInteger)capacity NS_DESIGNATED_INITIALIZER;

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

/** 拼装 itemArr 中每个 viewModel 的合并数据模型 */
- (AGViewModel *) ag_packageItemMergeData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                                 capacity:(NSInteger)capacity;

/** 拼装组头数据 */
- (AGViewModel *) ag_packageHeaderData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                              capacity:(NSInteger)capacity;

/** 拼装 item 数据 */
- (AGViewModel *) ag_packageItemData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                            capacity:(NSInteger)capacity;

- (NSArray<AGViewModel *> *) ag_packageItems:(NSArray *)items
                                     inBlock:(AGVMPackageDatasBlock)block;

- (NSArray<AGViewModel *> *) ag_packageItems:(nullable NSArray *)items
                                     inBlock:(nullable NS_NOESCAPE AGVMPackageDatasBlock)block
                                    capacity:(NSInteger)capacity;

/** 拼装组尾数据 */
- (AGViewModel *) ag_packageFooterData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                              capacity:(NSInteger)capacity;

/** 拼装公共数据 */
- (AGViewModel *) ag_packageCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                              capacity:(NSInteger)capacity;

#pragma mark capacity 默认为 6
- (AGViewModel *) ag_packageHeaderData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;
- (AGViewModel *) ag_packageItemData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;
- (AGViewModel *) ag_packageFooterData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;
- (AGViewModel *) ag_packageCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;
- (AGViewModel *) ag_packageItemMergeData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;


#pragma mark - 增删改查
#pragma mark 新增
- (AGVMSection *) ag_addItem:(AGViewModel *)item;
- (AGVMSection *) ag_addItemsFromSection:(AGVMSection *)vms;
- (AGVMSection *) ag_addItemsFromArray:(NSArray<AGViewModel *> *)vmArr;

#pragma mark 插入
- (AGVMSection *) ag_insertItem:(AGViewModel *)item
                        atIndex:(NSInteger)index;

- (AGVMSection *) ag_insertItemsFromSection:(AGVMSection *)vms
                                    atIndex:(NSInteger)index;

- (AGVMSection *) ag_insertItemsFromArray:(NSArray<AGViewModel *> *)vmArr
                                  atIndex:(NSInteger)index;

- (AGVMSection *) ag_insertItemPackage:(NS_NOESCAPE AGVMPackageDataBlock)package
                               atIndex:(NSInteger)index;

- (AGVMSection *) ag_insertItemPackage:(NS_NOESCAPE AGVMPackageDataBlock)package
                               atIndex:(NSInteger)index
                              capacity:(NSInteger)capacity;

#pragma mark 移除
- (AGVMSection *) ag_removeAllItems;
- (AGVMSection *) ag_removeLastObject;
- (AGVMSection *) ag_removeItem:(AGViewModel *)vm; //
- (AGVMSection *) ag_removeItemAtIndex:(NSInteger)index;
- (AGVMSection *) ag_removeItemsFromSection:(AGVMSection *)vms; //
- (AGVMSection *) ag_removeItemsFromArray:(NSArray<AGViewModel *> *)vmArr; //

#pragma mark 更新
- (AGVMSection *) ag_updateItemInBlock:(NS_NOESCAPE AGVMUpdateModelBlock)block
                               atIndex:(NSInteger)index;

- (AGVMSection *) ag_refreshItemByUpdateModelInBlock:(NS_NOESCAPE AGVMUpdateModelBlock)block
                                             atIndex:(NSInteger)index;

- (AGVMSection *) ag_refreshItemsByUpdateModelInBlock:(NS_NOESCAPE AGVMUpdateModelBlock)block;

- (void) setObject:(AGViewModel *)vm
atIndexedSubscript:(NSInteger)idx;

#pragma mark 取出
- (nullable AGViewModel *) objectAtIndexedSubscript:(NSInteger)idx;

/**
 找出对应 key 的所有对象

 @param key 从 AGViewModel 取值的 key
 @return 找到的对象数组
 */
- (nullable NSArray *) ag_findValueInItemArrWithKey:(NSString *)key;

#pragma mark 合并
/** 合并 headerVM、 footerVM、 commonVM、itemMergeVM、itemArr */
- (AGVMSection *) ag_mergeFromSection:(AGVMSection *)vms;

#pragma mark 交换
- (AGVMSection *) ag_exchangeItemAtIndex:(NSInteger)idx1 withItemAtIndex:(NSInteger)idx2;

#pragma mark 替换
- (AGVMSection *) ag_replaceItemAtIndex:(NSInteger)index withItem:(AGViewModel *)item;

#pragma mark 遍历
/** 遍历所有 item */
- (AGVMSection *) ag_enumerateItemsUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel *vm, NSUInteger idx, BOOL *stop))block;

/** 遍历 header、footer vm */
- (AGVMSection *) ag_enumerateHeaderFooterVMsUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel *vm, NSUInteger idx, BOOL *stop))block;


#pragma mark - map、filter、reduce
- (AGVMSection *) map:(NS_NOESCAPE AGVMMapBlock)block;
- (AGVMSection *) filter:(NS_NOESCAPE AGVMFilterBlock)block;
- (void) reduce:(NS_NOESCAPE AGVMReduceBlock)block;


// ...
- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

@end


#pragma mark - 数据转换
@interface AGVMSection (AGVMJSONTransformable) <AGVMJSONTransformable>

@end

NS_ASSUME_NONNULL_END
