//
//  AGVMManager.m
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/7.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  

#import "AGVMManager.h"
#import "AGVMFunction.h"

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
+ (instancetype) newWithSectionCapacity:(NSInteger)capacity
{
    return [[self alloc] initWithSectionCapacity:capacity];
}

- (instancetype)initWithSectionCapacity:(NSInteger)capacity
{
    self = [super init];
    if (self) {
        _capacity = capacity;
        _sectionArrM = ag_mutableArray(capacity);
    }
    return self;
}

#pragma mark - ---------- Public Methods ----------
- (AGViewModel *)ag_packageCommonData:(NS_NOESCAPE AGVMPackageDataBlock)package
{
    return [self ag_packageCommonData:package capacity:6];
}

- (AGViewModel *)ag_packageCommonData:(NS_NOESCAPE AGVMPackageDataBlock)package
                             capacity:(NSInteger)capacity
{
    _cvm = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _cvm;
}

#pragma mark -
/** 拼装 section 数据 capacity */
- (AGVMSection *) ag_packageSection:(NS_NOESCAPE AGVMPackageSectionBlock)block capacity:(NSInteger)capacity
{
    AGVMSection *vms = ag_VMSection(capacity);
    if ( block ) block(vms);
    [self.sectionArrM addObject:vms];
    return vms;
}

- (AGVMSection *)ag_packageSectionItems:(NSArray *)items packager:(id<AGVMPackagable>)packager forObject:(id)obj
{
	return [self ag_packageSection:^(AGVMSection * _Nonnull vms) {
		[vms ag_packageItems:items packager:packager forObject:obj];
	} capacity:items.count];
}

- (AGVMManager *) ag_packageSections:(NSArray *)sections
							 inBlock:(NS_NOESCAPE AGVMPackageSectionsBlock)block
{
	return [self ag_packageSections:sections inBlock:block capacity:15];
}

- (AGVMManager *) ag_packageSections:(NSArray *)sections
							 inBlock:(NS_NOESCAPE AGVMPackageSectionsBlock)block
							capacity:(NSInteger)capacity
{
	NSAssert([sections isKindOfClass:[NSArray class]], @"ag_packageSections: sections 为 nil 或 类型错误！");
	[sections enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		[self ag_packageSection:^(AGVMSection * _Nonnull vms) {
			block ? block(vms, obj, idx) : nil;
		} capacity:capacity];
	}];
	return self;
}

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    AGVMManager *vmm = [[self.class allocWithZone:zone] initWithSectionCapacity:_capacity];
    vmm->_cvm = [_cvm copy];
    [vmm ag_addSectionsFromManager:self];
    return vmm;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    AGVMManager *vmm = [[self.class allocWithZone:zone] initWithSectionCapacity:_capacity];
    vmm->_cvm = [_cvm mutableCopy];
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
	if (vmsArr == nil) return;
	
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

- (void) ag_insertSectionPackage:(NS_NOESCAPE AGVMPackageSectionBlock)package
                         atIndex:(NSInteger)index
{
    [self ag_insertSectionPackage:package atIndex:index capacity:6];
}

- (void) ag_insertSectionPackage:(NS_NOESCAPE AGVMPackageSectionBlock)package
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
	if (vmm == nil) return;
	
    if ( vmm.cvm ) {
        _cvm = _cvm ?: ag_viewModel(nil);
    }
    [self.cvm ag_mergeModelFromViewModel:vmm.cvm];
    [self ag_addSectionsFromArray:vmm.sectionArrM];
}

#pragma mark 更新
- (void) ag_updateSectionPackage:(NS_NOESCAPE AGVMPackageSectionBlock)package
                         atIndex:(NSInteger)index
{
    if ( package ) {
        AGVMSection *vms = self[index];
        if ( vms ) package(vms);
    }
}

- (void)setObject:(AGVMSection *)vms atIndexedSubscript:(NSInteger)idx
{
	if ( vms == nil ) return;
	
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
	if (section == nil) return;
    index < self.count ? [self.sectionArrM replaceObjectAtIndex:index withObject:section] : nil;
}

#pragma mark 遍历
- (void) ag_enumerateSectionsUsingBlock:(void (^NS_NOESCAPE)(AGVMSection * _Nonnull, NSUInteger, BOOL * _Nonnull))block
{
    if ( ! block ) return;
    
    [self.sectionArrM enumerateObjectsUsingBlock:block];
}

- (void) ag_enumerateSectionItemsUsingBlock:(void (^NS_NOESCAPE)(AGViewModel * _Nonnull, NSIndexPath * _Nonnull, BOOL * _Nonnull))block
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
- (void) ag_enumerateSectionHeaderFooterVMsUsingBlock:(void (^NS_NOESCAPE)(AGViewModel * _Nonnull, NSIndexPath * _Nonnull, BOOL * _Nonnull))block
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

- (AGVMSection *)fs
{
    return [self.sectionArrM firstObject];
}

- (AGVMSection *)ls
{
    return [self.sectionArrM lastObject];
}

#pragma mark - ----------- Override Methods ----------
- (NSString *)debugDescription
{
    return [self _debugStringIncludeDetail:NO];
}

- (id)debugQuickLookObject
{
    return [self _debugStringIncludeDetail:YES];
}

- (NSString *) _debugStringIncludeDetail:(BOOL)yesOrNo
{
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"  _cvm     (strong) : %@, \n", _cvm];
    
    if ( yesOrNo ) {
        NSMutableString *arrStrM = [NSMutableString stringWithString:@"(\n"];
        NSInteger maxIdx = self.count - 1;
        [_sectionArrM enumerateObjectsUsingBlock:^(AGVMSection * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( idx == maxIdx ) {
                [arrStrM appendFormat:@"🔷%@%@ \n", @(idx), [obj ag_debugString]];
            }
            else {
                [arrStrM appendFormat:@"🔷%@%@, \n", @(idx), [obj ag_debugString]];
            }
        }];
        
        [arrStrM appendFormat:@")"];
        
        [strM appendFormat:@"  _sectionArrM - Capacity:%@ - Count:%@ : %@", @(_capacity), @(self.count), arrStrM];
    }
    else {
        [strM appendFormat:@"  _sectionArrM - Capacity:%@ - Count:%@ : %@", @(_capacity), @(self.count), _sectionArrM];
    }
    
    return [NSString stringWithFormat:@"🔵 <%@: %p> --- {\n%@\n}", [self class] , self, strM];
}

@end


@implementation AGVMManager (AGVMJSONTransformable)
- (NSString *) ag_toJSONStringWithExchangeKey:(AGViewModel *)vm
                              customTransform:(NS_NOESCAPE AGVMJSONTransformBlock)block
{
    NSMutableDictionary *dictM = ag_mutableDict(2);
    dictM[kAGVMCommonVM] = _cvm;
    dictM[kAGVMArray] = _sectionArrM;
    return ag_JSONStringWithDict(dictM, vm, block);
}

- (NSString *)ag_toJSONStringWithCustomTransform:(NS_NOESCAPE AGVMJSONTransformBlock)block
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
    return [AGVMManager newWithSectionCapacity:capacity];
}


