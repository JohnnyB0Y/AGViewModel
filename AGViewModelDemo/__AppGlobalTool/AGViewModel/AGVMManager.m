//
//  AGVMManager.m
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/7.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  

#import "AGVMManager.h"
#import "AGVMFunction.h"
#import <objc/runtime.h>

@interface AGVMManager ()

@property (nonatomic, strong) NSMutableArray<AGVMSection *> *sectionArrM;

@end


@implementation AGVMManager {
    NSInteger _capacity;
}

#pragma mark - ----------- Life Cycle ----------
/**
 Quickly create vmm
 
 @param capacity itemArr 的 capacity
 @return vmm
 */
+ (instancetype) newWithItemCapacity:(NSInteger)capacity
{
    return [[self alloc] initWithItemCapacity:capacity];
}

- (instancetype)initWithItemCapacity:(NSInteger)capacity
{
    self = [super init];
    if (self) {
        _capacity = capacity;
        _sectionArrM = ag_mutableArray(capacity);
    }
    return self;
}

#pragma mark - ---------- Public Methods ----------
- (AGViewModel *)ag_packageCommonData:(AGVMPackageDataBlock)package
{
    return [self ag_packageCommonData:package capacity:6];
}

- (AGViewModel *)ag_packageCommonData:(AGVMPackageDataBlock)package
                             capacity:(NSInteger)capacity
{
    _commonVM = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _commonVM;
}

#pragma mark -
/** 拼装 section 数据 capacity */
- (AGVMSection *) ag_packageSection:(AGVMPackageSectionBlock)block capacity:(NSInteger)capacity
{
    AGVMSection *vms = ag_VMSection(capacity);
    if ( block ) block(vms);
    [self.sectionArrM addObject:vms];
    return vms;
}

- (NSArray<AGVMSection *> *) ag_packageSections:(NSArray *)sections
                                        inBlock:(AGVMPackageSectionsBlock)block
{
    return [self ag_packageSections:sections inBlock:block capacity:sections.count];
}

- (NSArray<AGVMSection *> *) ag_packageSections:(NSArray *)sections
                                        inBlock:(AGVMPackageSectionsBlock)block
                                       capacity:(NSInteger)capacity
{
    NSMutableArray *arrM = ag_mutableArray(sections.count);
    [sections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        AGVMSection *vms = ag_VMSection(capacity);
        block ? block(vms, obj, idx) : nil;
        [arrM addObject:vms];
    }];
    [self ag_addSectionsFromArray:arrM];
    
    return [arrM copy];
}

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    AGVMManager *vmm = [[self.class allocWithZone:zone] initWithItemCapacity:_capacity];
    vmm->_commonVM = [_commonVM copy];
    [vmm ag_addSectionsFromManager:self];
    return vmm;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    AGVMManager *vmm = [[self.class allocWithZone:zone] initWithItemCapacity:_capacity];
    vmm->_commonVM = [_commonVM mutableCopy];
    [self ag_enumerateSectionsUsingBlock:^(AGVMSection * _Nonnull vms, NSUInteger idx, BOOL * _Nonnull stop) {
        [vmm ag_addSection:[vms mutableCopy]];
    }];
    return vmm;
}

#pragma mark - 修改数据
#pragma mark 添加
- (void) ag_addSection:(AGVMSection *)section
{
    section ? [self.sectionArrM addObject:section] : nil;
}

- (void) ag_addSectionsFromArray:(NSArray<AGVMSection *> *)sections;
{
    sections.count > 0 ? [self.sectionArrM addObjectsFromArray:sections] : nil;
}

- (void) ag_addSectionsFromManager:(AGVMManager *)vmm
{
    [self ag_addSectionsFromArray:vmm.sectionArrM];
}

#pragma mark 插入
- (void) ag_insertSectionsFromManager:(AGVMManager *)vmm
                              atIndex:(NSInteger)index
{
    [self ag_insertSectionsFromArray:vmm.sectionArrM atIndex:index];
}

- (void) ag_insertSectionsFromArray:(NSArray<AGVMSection *> *)vmsArr
                            atIndex:(NSInteger)index
{
    if ( index == self.count ) {
        [self ag_addSectionsFromArray:vmsArr];
    }
    else if ( index < self.count ) {
        NSIndexSet *indexSet =
        [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, vmsArr.count)];
        [self.sectionArrM insertObjects:vmsArr atIndexes:indexSet];
    }
}

- (void) ag_insertSection:(AGVMSection *)section
                  atIndex:(NSInteger)index
{
    section ? [self setObject:section atIndexedSubscript:index] : nil;
}

- (void) ag_insertSectionPackage:(AGVMPackageSectionBlock)package
                         atIndex:(NSInteger)index
{
    [self ag_insertSectionPackage:package atIndex:index capacity:6];
}

- (void) ag_insertSectionPackage:(AGVMPackageSectionBlock)package
                         atIndex:(NSInteger)index
                        capacity:(NSInteger)capacity
{
    if ( package ) {
        AGVMSection *vms = ag_VMSection(capacity);
        package(vms);
        return [self ag_insertSection:vms atIndex:index];
    }
}

#pragma mark 移除
- (void) ag_removeAllSections
{
    [self.sectionArrM removeAllObjects];
}

- (void) ag_removeLastObject
{
    [self.sectionArrM removeLastObject];
}

- (void) ag_removeSectionAtIndex:(NSInteger)index
{
    index < self.count ? [self.sectionArrM removeObjectAtIndex:index] : nil;
}

#pragma mark 合并
/** 合并 commonVM、sectionArrM */
- (void) ag_mergeFromManager:(AGVMManager *)vmm
{
    if ( vmm.commonVM ) {
        _commonVM = _commonVM ?: ag_viewModel(nil);
    }
    [self.commonVM ag_mergeModelFromViewModel:vmm.commonVM];
    [self ag_addSectionsFromArray:vmm.sectionArrM];
}

#pragma mark 更新
- (void) ag_updateSectionPackage:(AGVMPackageSectionBlock)package
                         atIndex:(NSInteger)index
{
    if ( package ) {
        AGVMSection *vms = self[index];
        if ( vms ) package(vms);
    }
}

- (void)setObject:(AGVMSection *)vms atIndexedSubscript:(NSInteger)idx
{
    if ( idx == self.count ) {
        [self.sectionArrM addObject:vms];
    }
    else if ( idx < self.count ) {
        [self.sectionArrM insertObject:vms atIndex:idx];
    }
}

#pragma mark 取出
- (AGVMSection *)objectAtIndexedSubscript:(NSInteger)idx
{
    return idx < self.count ? [self.sectionArrM objectAtIndex:idx] : nil;
}

#pragma mark 交换
- (void) ag_exchangeSectionAtIndex:(NSInteger)idx1 withSectionAtIndex:(NSInteger)idx2
{
    if ( idx1 < self.count && idx2 < self.count )
        [self.sectionArrM exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

#pragma mark 替换
- (void) ag_replaceSectionAtIndex:(NSInteger)index withSection:(AGVMSection *)section
{
    index < self.count ? [self.sectionArrM replaceObjectAtIndex:index withObject:section] : nil;
}

#pragma mark 遍历
- (void) ag_enumerateSectionsUsingBlock:(void (^)(AGVMSection * _Nonnull, NSUInteger, BOOL * _Nonnull))block
{
    if ( ! block ) return;
    
    [self.sectionArrM enumerateObjectsUsingBlock:block];
}

- (void) ag_enumerateSectionItemsUsingBlock:(void (^)(AGViewModel * _Nonnull, NSIndexPath * _Nonnull, BOOL * _Nonnull))block
{
    if ( ! block ) return;
    
    __block BOOL _stop = NO;
    [self ag_enumerateSectionsUsingBlock:^(AGVMSection * _Nonnull vms, NSUInteger section, BOOL * _Nonnull stop) {
        [vms ag_enumerateItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSUInteger item, BOOL * _Nonnull stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            block(vm, indexPath, &_stop);
            if ( _stop ) *stop = _stop;
        }];
        if ( _stop ) *stop = _stop;
    }];
}

/** 遍历所有 section 的 header、footer vm */
- (void) ag_enumerateSectionHeaderFooterVMsUsingBlock:(void (^)(AGViewModel * _Nonnull, NSIndexPath * _Nonnull, BOOL * _Nonnull))block
{
    if ( ! block ) return;
    
    __block BOOL _stop = NO;
    [self ag_enumerateSectionsUsingBlock:^(AGVMSection * _Nonnull vms, NSUInteger section, BOOL * _Nonnull stop) {
        [vms ag_enumerateHeaderFooterVMsUsingBlock:^(AGViewModel * _Nonnull vm, NSUInteger item, BOOL * _Nonnull stop) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:section];
            
            block(vm, indexPath, &_stop);
            if ( _stop ) *stop = _stop;
        }];
        if ( _stop ) *stop = _stop;
    }];
}

#pragma mark - ----------- Getter Methods ----------
- (NSInteger) count
{
    return self.sectionArrM.count;
}

- (AGVMSection *)firstSection
{
    return [self.sectionArrM firstObject];
}

- (AGVMSection *)fs
{
    return [self.sectionArrM firstObject];
}

- (AGVMSection *)lastSection
{
    return [self.sectionArrM lastObject];
}

- (AGVMSection *)ls
{
    return [self.sectionArrM lastObject];
}

#pragma mark - ----------- Override Methods ----------
- (NSString *) debugDescription
{
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictM = ag_mutableDict(count);
    for ( int i = 0; i<count; i++ ) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        id value = [self valueForKey:name] ?: @"nil";
        [dictM setObject:value forKey:name];
    }
    
    free(properties);
    return [NSString stringWithFormat:@"<%@: %p> -- %@", [self class] , self, dictM];
}

@end


@implementation AGVMManager (AGVMJSONTransformable)
- (NSString *) ag_toJSONStringWithExchangeKey:(AGViewModel *)vm
                              customTransform:(AGVMJSONTransformBlock)block
{
    NSMutableDictionary *dictM = ag_mutableDict(2);
    dictM[kAGVMCommonVM] = _commonVM;
    dictM[kAGVMArray] = _sectionArrM;
    return ag_JSONStringWithDict(dictM, vm, block);
}

- (NSString *)ag_toJSONStringWithCustomTransform:(AGVMJSONTransformBlock)block
{
    return [self ag_toJSONStringWithExchangeKey:nil customTransform:block];
}

- (NSString *)ag_toJSONString
{
    return [self ag_toJSONStringWithCustomTransform:nil];
}

@end

/** Quickly create AGVMManager instance */
AGVMManager * ag_VMManager(NSInteger capacity)
{
    return [AGVMManager newWithItemCapacity:capacity];
}


