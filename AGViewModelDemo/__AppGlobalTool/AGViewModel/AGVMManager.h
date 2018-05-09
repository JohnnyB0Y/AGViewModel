//
//  AGVMManager.h
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/7.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  

#import "AGVMProtocol.h"
#import "AGVMSection.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - interface
@interface AGVMManager : NSObject <NSCopying, NSMutableCopying>
/** common vm */
@property (nonatomic, strong, nullable) AGViewModel *cvm;

@property (nonatomic, strong, readonly, nullable) NSMutableArray<AGVMSection *> *sectionArrM;
@property (nonatomic, assign, readonly) NSInteger count;

/** first section */
@property (nonatomic, weak, readonly, nullable) AGVMSection *fs;
/** last section */
@property (nonatomic, weak, readonly, nullable) AGVMSection *ls;

#pragma mark - Quickly create vmm
/**
 Quickly create vmm

 @param capacity sectionArrM 每次增量拷贝的内存大小
 @return vmm
 */
+ (instancetype) newWithSectionCapacity:(NSInteger)capacity;
- (instancetype) initWithSectionCapacity:(NSInteger)capacity NS_DESIGNATED_INITIALIZER;

#pragma mark - 自己拼装数据 （不用担心循环引用问题）
/**
 拼装 section 数据
 
 @param block 传递 section 的 block
 @param capacity section 中 itemArr 每次增量拷贝的内存大小
 @return section对象
 */
- (AGVMSection *) ag_packageSection:(nullable NS_NOESCAPE AGVMPackageSectionBlock)block
						   capacity:(NSInteger)capacity;

/**
 通过 packager 拼装 section 数据
 
 @param items 一组数据
 @param packager 遵守AGVMPackagable的对象
 @param obj 传入的对象
 @return section对象
 */
- (AGVMSection *) ag_packageSectionItems:(nullable NSArray *)items
								packager:(id<AGVMPackagable>)packager
							   forObject:(nullable id)obj;

/**
 拼装多条 section 数据 （每条 section 中 itemArr 每次增量拷贝的内存大小为15）
 
 @param sections 多组数据
 @param block 拼装block
 @return manager对象
 */
- (AGVMManager *) ag_packageSections:(nullable NSArray *)sections
							 inBlock:(nullable NS_NOESCAPE AGVMPackageSectionsBlock)block;


/**
 拼装多条 section 数据
 
 @param sections 多组数据
 @param block 拼装block
 @param capacity 每条 section 中 itemArr 每次增量拷贝的内存大小
 @return manager对象
 */
- (AGVMManager *) ag_packageSections:(nullable NSArray *)sections
							 inBlock:(nullable NS_NOESCAPE AGVMPackageSectionsBlock)block
							capacity:(NSInteger)capacity;

/**
 打包公共数据
 
 @param package 打包block
 @param capacity 字典每次增量拷贝的内存大小
 @return 打包好的 View Model
 */
- (AGViewModel *) ag_packageCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package
							  capacity:(NSInteger)capacity;

/**
 打包公共数据
 
 @param package 打包block
 @return 打包好的 View Model
 */
- (AGViewModel *) ag_packageCommonData:(nullable NS_NOESCAPE AGVMPackageDataBlock)package;


#pragma mark - 修改数据
#pragma mark 添加
- (void) ag_addSection:(nullable AGVMSection *)section;
- (void) ag_addSectionsFromManager:(nullable AGVMManager *)vmm;
- (void) ag_addSectionsFromArray:(nullable NSArray<AGVMSection *> *)sections;

#pragma mark 插入
- (void) ag_insertSection:(nullable AGVMSection *)section
                  atIndex:(NSInteger)index;

- (void) ag_insertSectionsFromManager:(nullable AGVMManager *)vmm
                              atIndex:(NSInteger)index;

- (void) ag_insertSectionsFromArray:(nullable NSArray<AGVMSection *> *)vmsArr
                            atIndex:(NSInteger)index;

- (void) ag_insertSectionPackage:(nullable NS_NOESCAPE AGVMPackageSectionBlock)package
                         atIndex:(NSInteger)index;

- (void) ag_insertSectionPackage:(nullable NS_NOESCAPE AGVMPackageSectionBlock)package
                         atIndex:(NSInteger)index
                        capacity:(NSInteger)capacity;

#pragma mark 移除
- (void) ag_removeLastObject;
- (void) ag_removeAllSections;
- (void) ag_removeSectionAtIndex:(NSInteger)index;

#pragma mark 合并
/** 合并 commonVM、sectionArrM */
- (void) ag_mergeFromManager:(nullable AGVMManager *)vmm;

#pragma mark 更新
- (void) ag_updateSectionPackage:(nullable NS_NOESCAPE AGVMPackageSectionBlock)package
                         atIndex:(NSInteger)index;

- (void) setObject:(nullable AGVMSection *)vms atIndexedSubscript:(NSInteger)idx;

#pragma mark 取出
- (AGVMSection *) objectAtIndexedSubscript:(NSInteger)idx;

#pragma mark 交换
- (void) ag_exchangeSectionAtIndex:(NSInteger)idx1 withSectionAtIndex:(NSInteger)idx2;

#pragma mark 替换
- (void) ag_replaceSectionAtIndex:(NSInteger)index withSection:(nullable AGVMSection *)section;

#pragma mark 遍历
/** 遍历所有 section */
- (void) ag_enumerateSectionsUsingBlock:(void (NS_NOESCAPE ^)(AGVMSection *vms, NSUInteger idx, BOOL *stop))block;

/** 遍历所有 section 的 item */
- (void) ag_enumerateSectionItemsUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel *vm, NSIndexPath *indexPath, BOOL *stop))block;

/** 遍历所有 section 的 header、footer vm */
- (void) ag_enumerateSectionHeaderFooterVMsUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel *vm, NSIndexPath *indexPath, BOOL *stop))block;


// ...
- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

@end

#pragma mark - 数据转换
@interface AGVMManager (AGVMJSONTransformable) <AGVMJSONTransformable>

@end

NS_ASSUME_NONNULL_END

