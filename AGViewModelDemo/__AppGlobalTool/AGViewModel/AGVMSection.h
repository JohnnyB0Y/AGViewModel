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
<NSCopying, NSMutableCopying, NSSecureCoding, AGVMJSONTransformable>

/** common vm */
@property (nonatomic, strong, nullable) AGViewModel *cvm;

@property (nonatomic, strong, nullable) AGViewModel *headerVM;
@property (nonatomic, strong, nullable) AGViewModel *footerVM;

/** 会合并到 itemArr中的每个vm 中 */
@property (nonatomic, strong, nullable) AGViewModel *itemMergeVM;
@property (nonatomic, strong, readonly, nullable) NSMutableArray<AGViewModel *> *itemArrM;
@property (nonatomic, assign, readonly) NSInteger count;

/** first item vm */
@property (nonatomic, weak, readonly, nullable) AGViewModel *fvm;
/** last item vm */
@property (nonatomic, weak, readonly, nullable) AGViewModel *lvm;

/**
 Quickly create vms
 
 @param capacity itemArrM 每次增量拷贝的内存大小
 @return vms
 */
+ (instancetype) newWithItemCapacity:(NSInteger)capacity;
- (instancetype) initWithItemCapacity:(NSInteger)capacity;

+ (instancetype) newWithItems:(NSMutableArray<AGViewModel *> *)itemArrM;
- (instancetype) initWithItems:(NSMutableArray<AGViewModel *> *)itemArrM NS_DESIGNATED_INITIALIZER;

#pragma mark - 通过 packager 拼装数据
/**
 通过 packager 拼装组头数据
 
 @param data 数据
 @param packager 遵守AGVMPackagable的对象
 @param obj 传入的对象
 @return headerVM
 */
- (AGViewModel *) ag_packageHeaderData:(nullable NSDictionary *)data
							  packager:(id<AGVMPackagable>)packager
							 forObject:(nullable id)obj;

/**
 通过 packager 拼装 item 数据
 
 @param data 数据
 @param packager 遵守AGVMPackagable的对象
 @param obj 传入的对象
 @return viewModle对象
 */
- (AGViewModel *) ag_packageItemData:(nullable NSDictionary *)data
							packager:(id<AGVMPackagable>)packager
						   forObject:(nullable id)obj;

/**
 通过 packager 拼装 一组item 数据
 
 @param items 一组数据
 @param packager 遵守AGVMPackagable的对象
 @param obj 传入的对象
 @return section对象
 */
- (AGVMSection *) ag_packageItems:(nullable NSArray *)items
						 packager:(id<AGVMPackagable>)packager
						forObject:(nullable id)obj;

/**
 通过 packager 拼装组尾数据
 
 @param data 数据
 @param packager 遵守AGVMPackagable的对象
 @param obj 传入的对象
 @return footerVM
 */
- (AGViewModel *) ag_packageFooterData:(nullable NSDictionary *)data
							  packager:(id<AGVMPackagable>)packager
							 forObject:(nullable id)obj;


#pragma mark - 自己拼装数据 （不用担心循环引用问题）
/**
 拼装组头数据
 
 @param package 存放数据的字典 Block
 @param capacity 数据字典每次增量拷贝的内存大小
 @return headerVM
 */
- (AGViewModel *) ag_packageHeaderData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
							  capacity:(NSInteger)capacity;

/**
 拼装组头数据（数据字典每次增量拷贝的内存大小为6）
 
 @param package 存放数据的字典 Block
 @return headerVM
 */
- (AGViewModel *) ag_packageHeaderData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;

/**
 拼装 item 数据
 
 @param package 存放数据的字典 Block
 @param capacity 数据字典每次增量拷贝的内存大小
 @return viewModel对象
 */
- (AGViewModel *) ag_packageItemData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
							capacity:(NSInteger)capacity;

/**
 拼装 item 数据（数据字典每次增量拷贝的内存大小为6）
 
 @param package 存放数据的字典 Block
 @return viewModel对象
 */
- (AGViewModel *) ag_packageItemData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;

/**
 拼装多条 item 数据
 
 @param items 一组数据
 @param block 存放数据的字典 Block
 @param capacity 每条 item 中 数据字典每次增量拷贝的内存大小
 @return section对象
 */
- (AGVMSection *) ag_packageItems:(nullable NSArray *)items
						  inBlock:(nullable NS_NOESCAPE AGVMPackageDatasBlock)block
						 capacity:(NSInteger)capacity;

/**
 拼装多条 item 数据（每条 item 中 数据字典每次增量拷贝的内存大小为6）
 
 @param items 一组数据
 @param block 存放数据的字典 Block
 @return section对象
 */
- (AGVMSection *) ag_packageItems:(nullable NSArray *)items
						  inBlock:(nullable NS_NOESCAPE AGVMPackageDatasBlock)block;

/**
 拼装组尾数据
 
 @param package 存放数据的字典 Block
 @param capacity 数据字典每次增量拷贝的内存大小
 @return footerVM
 */
- (AGViewModel *) ag_packageFooterData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
							  capacity:(NSInteger)capacity;

/**
 拼装组尾数据（数据字典每次增量拷贝的内存大小为6）
 
 @param package 存放数据的字典 Block
 @return footerVM
 */
- (AGViewModel *) ag_packageFooterData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;

/**
 拼装公共数据
 
 @param package 存放数据的字典 Block
 @param capacity 数据字典每次增量拷贝的内存大小
 @return commonVM
 */
- (AGViewModel *) ag_packageCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
							  capacity:(NSInteger)capacity;

/**
 拼装公共数据（数据字典每次增量拷贝的内存大小为6）
 
 @param package 存放数据的字典 Block
 @return commonVM
 */
- (AGViewModel *) ag_packageCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;

/**
 拼装 itemArr 中每个 viewModel 的合并数据模型
 
 @param package 存放数据的字典 Block
 @param capacity 数据字典每次增量拷贝的内存大小
 @return itemMergeVM
 */
- (AGViewModel *) ag_packageItemMergeData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
								 capacity:(NSInteger)capacity;

/**
 拼装 itemArr 中每个 viewModel 的合并数据模型（数据字典每次增量拷贝的内存大小为6）
 
 @param package 存放数据的字典 Block
 @return itemMergeVM
 */
- (AGViewModel *) ag_packageItemMergeData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;


#pragma mark - 增删改查
#pragma mark 新增
- (void) ag_addItem:(nullable AGViewModel *)item;
- (void) ag_addItemsFromSection:(nullable AGVMSection *)vms;
- (void) ag_addItemsFromArray:(nullable NSArray<AGViewModel *> *)vmArr;

#pragma mark 插入
- (void) ag_insertItem:(nullable AGViewModel *)item
               atIndex:(NSInteger)index;

- (void) ag_insertItemsFromSection:(nullable AGVMSection *)vms
                           atIndex:(NSInteger)index;

- (void) ag_insertItemsFromArray:(nullable NSArray<AGViewModel *> *)vmArr
                         atIndex:(NSInteger)index;

- (void) ag_insertItemPackage:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                      atIndex:(NSInteger)index;

- (void) ag_insertItemPackage:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
                      atIndex:(NSInteger)index
                     capacity:(NSInteger)capacity;

#pragma mark 移除
- (void) ag_removeAllItems;
- (void) ag_removeLastObject;
- (void) ag_removeItem:(nullable AGViewModel *)vm; //
- (void) ag_removeItemAtIndex:(NSInteger)index;
- (void) ag_removeItemsFromSection:(nullable AGVMSection *)vms; //
- (void) ag_removeItemsFromArray:(nullable NSArray<AGViewModel *> *)vmArr; //

#pragma mark 更新
- (void) ag_refreshItemByUpdateModelInBlock:(nullable NS_NOESCAPE AGVMUpdateModelBlock)block
                                             atIndex:(NSInteger)index;

- (void) ag_refreshItemsByUpdateModelInBlock:(nullable NS_NOESCAPE AGVMUpdateModelBlock)block;

- (void) setObject:(nullable AGViewModel *)vm atIndexedSubscript:(NSInteger)idx;

#pragma mark 取出
- (nullable AGViewModel *) objectAtIndexedSubscript:(NSInteger)idx;

#pragma mark 合并
/** 合并 headerVM、 footerVM、 commonVM、itemMergeVM、itemArr */
- (void) ag_mergeFromSection:(nullable AGVMSection *)vms;

#pragma mark 交换
- (void) ag_exchangeItemAtIndex:(NSInteger)idx1 withItemAtIndex:(NSInteger)idx2;

#pragma mark 替换
- (void) ag_replaceItemAtIndex:(NSInteger)index withItem:(nullable AGViewModel *)item;

#pragma mark 遍历
/** 遍历所有 item */
- (void) ag_enumerateItemsUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel *vm, NSUInteger idx, BOOL *stop))block;

/** 遍历 header、footer vm */
- (void) ag_enumerateHeaderFooterVMsUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel *vm, NSUInteger idx, BOOL *stop))block;


#pragma mark 归档持久化相关
/** 添加到支持 归档(NSKeyedArchiver)、转Json字符串当中的 Key。*/
- (void) ag_addArchivedCommonVMKey:(NSString *)key;
- (void) ag_addArchivedHeaderVMKey:(NSString *)key;
- (void) ag_addArchivedFooterVMKey:(NSString *)key;
- (void) ag_addArchivedItemArrMKey:(NSString *)key;

/** 添加到支持 归档(NSKeyedArchiver)、转Json字符串当中的 Key，使用类内置的key */
- (void) ag_addAllArchivedObjectUseDefaultKeys;

/** 移除要归档和转字符串的 keys */
- (void) ag_removeArchivedCommonVMKey;
- (void) ag_removeArchivedHeaderVMKey;
- (void) ag_removeArchivedFooterVMKey;
- (void) ag_removeArchivedItemArrMKey;
- (void) ag_removeAllArchivedObjectKeys;


#pragma mark - map、filter、reduce
- (AGVMSection *) map:(NS_NOESCAPE AGVMMapBlock)block;
- (AGVMSection *) filter:(NS_NOESCAPE AGVMFilterBlock)block;
- (void) reduce:(NS_NOESCAPE AGVMReduceBlock)block;


// ...
- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;
- (NSString *) ag_debugString;

@end

NS_ASSUME_NONNULL_END
