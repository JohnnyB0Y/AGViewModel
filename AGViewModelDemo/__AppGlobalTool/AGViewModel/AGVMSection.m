//
//  AGVMSection.m
//  
//
//  Created by JohnnyB0Y on 2017/7/10.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  一组 View Model 数据

#import "AGVMSection.h"
#import "AGVMFunction.h"

@interface AGVMSection ()

@property (nonatomic, strong) NSMutableArray<AGViewModel *> *itemArrM;

@end

@implementation AGVMSection {
    NSInteger _capacity;
}

/**
 Quickly create vms
 
 @param capacity itemArrM 每次增量拷贝的内存大小
 @return vms
 */
+ (instancetype) newWithItemCapacity:(NSInteger)capacity
{
    return [[self alloc] initWithItemCapacity:capacity];
}

- (instancetype) initWithItemCapacity:(NSInteger)capacity
{
    self = [super init];
    if (self) {
        _capacity = capacity;
        _itemArrM = ag_mutableArray(capacity);
    }
    return self;
}

#pragma mark - ---------- Public Methods ----------
- (AGViewModel *) ag_packageHeaderData:(AGVMPackageDataBlock)package
{
    return [self ag_packageHeaderData:package capacity:6];
}

- (AGViewModel *) ag_packageItemData:(AGVMPackageDataBlock)package
{
    return [self ag_packageItemData:package capacity:6];
}

- (AGVMSection *) ag_packageItems:(NSArray *)items
						  inBlock:(AGVMPackageDatasBlock)block
{
	return [self ag_packageItems:items inBlock:block capacity:6];
}

- (AGVMSection *) ag_packageItems:(NSArray *)items
						  inBlock:(AGVMPackageDatasBlock)block
						 capacity:(NSInteger)capacity
{
	NSArray *arr = [ag_sharedVMPackager() ag_packageItems:items
												  mergeVM:_itemMergeVM
												  inBlock:block
												 capacity:capacity];
	[self ag_addItemsFromArray:arr];
	return self;
}

- (AGViewModel *) ag_packageFooterData:(AGVMPackageDataBlock)package
{
    return [self ag_packageFooterData:package capacity:6];
}

- (AGViewModel *)ag_packageCommonData:(AGVMPackageDataBlock)package
{
    return [self ag_packageCommonData:package capacity:6];
}

- (AGViewModel *) ag_packageHeaderData:(AGVMPackageDataBlock)package
                              capacity:(NSInteger)capacity
{
    _headerVM = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _headerVM;
}

- (AGViewModel *) ag_packageItemData:(AGVMPackageDataBlock)package
                            capacity:(NSInteger)capacity
{
    AGViewModel *vm =
    [ag_sharedVMPackager() ag_package:package mergeVM:_itemMergeVM capacity:capacity];
    if (vm) [self.itemArrM addObject:vm];
    return vm;
}

- (AGViewModel *) ag_packageFooterData:(AGVMPackageDataBlock)package
                              capacity:(NSInteger)capacity
{
    _footerVM = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _footerVM;
}

- (AGViewModel *)ag_packageCommonData:(AGVMPackageDataBlock)package
                             capacity:(NSInteger)capacity
{
    _cvm = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _cvm;
}

/** 拼装 itemArr 中 viewModel 的共同字典数据 */
- (AGViewModel *) ag_packageItemMergeData:(AGVMPackageDataBlock)package
                                 capacity:(NSInteger)capacity
{
    _itemMergeVM = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _itemMergeVM;
}

- (AGViewModel *) ag_packageItemMergeData:(AGVMPackageDataBlock)package
{
    return [self ag_packageItemMergeData:package capacity:6];
}

#pragma mark AGVMPackagable
/** 通过 packager 拼装组头数据 */
- (AGViewModel *) ag_packageHeaderData:(NSDictionary *)data
                              packager:(id<AGVMPackagable>)packager
                             forObject:(id)obj
{
    if ( [packager respondsToSelector:@selector(ag_packageData:forObject:)] ) {
        _headerVM = [packager ag_packageData:data forObject:(id)obj];
    }
    return _headerVM;
}

/** 通过 packager 拼装 item 数据 */
- (AGViewModel *) ag_packageItemData:(NSDictionary *)data
                            packager:(id<AGVMPackagable>)packager
                           forObject:(id)obj
{
    AGViewModel *vm;
    if ( [packager respondsToSelector:@selector(ag_packageData:forObject:)] ) {
        vm = [packager ag_packageData:data forObject:obj];
        if (vm) [self.itemArrM addObject:vm];
    }
    return vm;
}

- (AGVMSection *)ag_packageItems:(NSArray *)items
						packager:(id<AGVMPackagable>)packager
					   forObject:(id)obj
{
	for (NSDictionary *dict in items) {
		[self ag_packageItemData:dict packager:packager forObject:obj];
	}
	return self;
}

/** 通过 packager 拼装组尾数据 */
- (AGViewModel *) ag_packageFooterData:(NSDictionary *)data
                              packager:(id<AGVMPackagable>)packager
                             forObject:(id)obj
{
    if ( [packager respondsToSelector:@selector(ag_packageData:forObject:)] ) {
        _footerVM = [packager ag_packageData:data forObject:obj];
    }
    return _footerVM;
}

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    AGVMSection *vms = [[self.class allocWithZone:zone] initWithItemCapacity:_capacity];
    vms->_cvm = [_cvm copy];
    vms->_headerVM = [_headerVM copy];
    vms->_footerVM = [_footerVM copy];
    vms->_itemMergeVM = [_itemMergeVM copy];
    [vms ag_addItemsFromSection:self];
    return vms;
}

- (id)mutableCopyWithZone:(NSZone *)zone
{
    AGVMSection *vms = [[self.class allocWithZone:zone] initWithItemCapacity:_capacity];
    vms->_cvm = [_cvm mutableCopy];
    vms->_headerVM = [_headerVM mutableCopy];
    vms->_footerVM = [_footerVM mutableCopy];
    vms->_itemMergeVM = [_itemMergeVM mutableCopy];
    [self ag_enumerateItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSUInteger idx, BOOL * _Nonnull stop) {
        [vms ag_addItem:[vm mutableCopy]];
    }];
    return vms;
}

#pragma mark - 增删改查
#pragma mark 插入
- (AGVMSection *) ag_insertItemsFromSection:(AGVMSection *)vms atIndex:(NSInteger)index
{
    return [self ag_insertItemsFromArray:vms.itemArrM atIndex:index];
}

- (AGVMSection *) ag_insertItemsFromArray:(NSArray<AGViewModel *> *)vmArr
                                  atIndex:(NSInteger)index
{
    if ( index == self.count ) {
        [self ag_addItemsFromArray:vmArr];
    }
    else if ( index < self.count ) {
        NSIndexSet *indexSet =
        [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, vmArr.count)];
        [self.itemArrM insertObjects:vmArr atIndexes:indexSet];
    }
    
    return self;
}

- (AGVMSection *) ag_insertItemPackage:(AGVMPackageDataBlock)package
                               atIndex:(NSInteger)index
                              capacity:(NSInteger)capacity
{
    AGViewModel *vm = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return [self ag_insertItem:vm atIndex:index];
}

- (AGVMSection *) ag_insertItemPackage:(AGVMPackageDataBlock)package
                               atIndex:(NSInteger)index
{
    return [self ag_insertItemPackage:package atIndex:index capacity:6];
}

- (AGVMSection *)ag_insertItem:(AGViewModel *)item atIndex:(NSInteger)index
{
    item ? [self setObject:item atIndexedSubscript:index] : nil;
    return self;
}

- (void)setObject:(AGViewModel *)vm atIndexedSubscript:(NSInteger)idx
{
    if ( idx == self.count ) {
        [self.itemArrM addObject:vm];
    }
    else if ( idx < self.count ) {
        [self.itemArrM insertObject:vm atIndex:idx];
    }
    else {
        NSAssert(NO, @"VMSection insert object cross the border !");
    }
}

#pragma mark 增加
- (AGVMSection *) ag_addItemsFromSection:(AGVMSection *)vms
{
    return [self ag_addItemsFromArray:vms.itemArrM];
}

- (AGVMSection *) ag_addItemsFromArray:(NSArray<AGViewModel *> *)vmArr
{
    vmArr.count > 0 ? [self.itemArrM addObjectsFromArray:vmArr] : nil;
    return self;
}

- (AGVMSection *) ag_addItem:(AGViewModel *)item
{
    item ? [self.itemArrM addObject:item] : nil;
    return self;
}

#pragma mark 更新
- (AGVMSection *) ag_refreshItemByUpdateModelInBlock:(AGVMUpdateModelBlock)block
                                             atIndex:(NSInteger)index
{
	AGViewModel *vm = self[index];
	vm ? [vm ag_refreshUIByUpdateModelInBlock:block] : nil;
    return self;
}

- (AGVMSection *) ag_refreshItemsByUpdateModelInBlock:(AGVMUpdateModelBlock)block
{
	[self ag_enumerateItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSUInteger idx, BOOL * _Nonnull stop) {
		[vm ag_refreshUIByUpdateModelInBlock:block];
	}];
    return self;
}

#pragma mark 移除
- (AGVMSection *) ag_removeAllItems
{
    [self.itemArrM removeAllObjects];
    return self;
}

- (AGVMSection *) ag_removeItemAtIndex:(NSInteger)index
{
    index < self.count ? [self.itemArrM removeObjectAtIndex:index] : nil;
    return self;
}

- (AGVMSection *) ag_removeLastObject
{
    [self.itemArrM removeLastObject];
    return self;
}

- (AGVMSection *) ag_removeItem:(AGViewModel *)vm
{
	if (vm == nil) return self;
    [self.itemArrM removeObject:vm];
    return self;
}

- (AGVMSection *) ag_removeItemsFromArray:(NSArray<AGViewModel *> *)vmArr
{
	if (vmArr == nil) return self;
    [self.itemArrM removeObjectsInArray:vmArr];
    return self;
}

- (AGVMSection *) ag_removeItemsFromSection:(AGVMSection *)vms
{
    [self ag_removeItemsFromArray:vms.itemArrM];
    return self;
}

#pragma mark 选中
- (AGViewModel *) objectAtIndexedSubscript:(NSInteger)idx
{
    return idx < self.count ? [self.itemArrM objectAtIndex:idx] : nil;
}

#pragma mark 合并
- (AGVMSection *) ag_mergeFromSection:(AGVMSection *)vms
{
	if (vms == nil) return self;
    if ( vms.headerVM ) {
        _headerVM = _headerVM ?: ag_viewModel(nil);
    }
    if ( vms.footerVM ) {
        _footerVM = _footerVM ?: ag_viewModel(nil);
    }
    if ( vms.cvm ) {
        _cvm = _cvm ?: ag_viewModel(nil);
    }
    if ( vms.itemMergeVM ) {
        _itemMergeVM = _itemMergeVM ?: ag_viewModel(nil);
    }
    // 合并所有数据
    [self.headerVM ag_mergeModelFromViewModel:vms.headerVM];
    [self.footerVM ag_mergeModelFromViewModel:vms.footerVM];
    [self.cvm ag_mergeModelFromViewModel:vms.cvm];
    [self.itemMergeVM ag_mergeModelFromViewModel:vms.itemMergeVM];
    
    [self ag_addItemsFromSection:vms];
    
    return self;
}

#pragma mark 交换
- (AGVMSection *) ag_exchangeItemAtIndex:(NSInteger)idx1 withItemAtIndex:(NSInteger)idx2
{
    if ( idx1 < self.count && idx2 < self.count )
        [self.itemArrM exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    
    return self;
}

#pragma mark 替换
- (AGVMSection *) ag_replaceItemAtIndex:(NSInteger)index withItem:(AGViewModel *)item
{
	if (item == nil) return self;
    index < self.count ? [self.itemArrM replaceObjectAtIndex:index withObject:item] : nil;
    return self;
}

#pragma mark 遍历
- (AGVMSection *) ag_enumerateItemsUsingBlock:(void (^)(AGViewModel * _Nonnull, NSUInteger, BOOL * _Nonnull))block
{
    if ( ! block ) return self;
	
    [self.itemArrM enumerateObjectsUsingBlock:block];
    return self;
}

/** 遍历所有 section 的 header、footer vm */
- (AGVMSection *) ag_enumerateHeaderFooterVMsUsingBlock:(void (^)(AGViewModel * _Nonnull, NSUInteger, BOOL * _Nonnull))block
{
    if ( ! block ) return self;
    
    NSMutableArray *arrM = ag_mutableArray(2);
    _headerVM ? [arrM addObject:_headerVM] : nil;
    _footerVM ? [arrM addObject:_footerVM] : nil;
    [arrM enumerateObjectsUsingBlock:block];
    return self;
}

#pragma mark - map、filter、reduce
- (AGVMSection *) map:(AGVMMapBlock)block
{
	if ( ! block ) return self;
	AGVMSection *vms = ag_VMSection(self.count);
	[self.itemArrM enumerateObjectsUsingBlock:^(AGViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ( [obj isKindOfClass:[AGViewModel class]] ) {
			AGViewModel *newVM = [obj mutableCopy];
			block(newVM);
			[vms ag_addItem:newVM];
		}
	}];
	return vms;
}

- (AGVMSection *) filter:(AGVMFilterBlock)block
{
	if ( ! block ) return self;
	AGVMSection *vms = ag_VMSection(self.count);
	[self.itemArrM enumerateObjectsUsingBlock:^(AGViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ( [obj isKindOfClass:[AGViewModel class]] && block(obj) ) {
			[vms ag_addItem:[obj mutableCopy]];
		}
	}];
	return vms;
}

- (void) reduce:(AGVMReduceBlock)block
{
	if ( ! block ) return;
	[self.itemArrM enumerateObjectsUsingBlock:^(AGViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ( [obj isKindOfClass:[AGViewModel class]] ) {
			block(obj, idx);
		}
	}];
}

#pragma mark - ---------- Private Methods ----------


#pragma mark - ----------- Getter Methods ----------
- (NSInteger) count
{
    return self.itemArrM.count;
}

- (AGViewModel *)fvm
{
    return [self.itemArrM firstObject];
}

- (AGViewModel *)lvm
{
    return [self.itemArrM lastObject];
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

- (NSString *) ag_debugString
{
    return [self _debugStringIncludeDetail:YES];
}

- (NSString *) _debugStringIncludeDetail:(BOOL)yesOrNo
{
    NSMutableString *strM = [NSMutableString string];
    [strM appendFormat:@"  _cvm         (strong) : %@, \n", _cvm];
    [strM appendFormat:@"  _headerVM    (strong) : %@, \n", _headerVM];
    [strM appendFormat:@"  _footerVM    (strong) : %@, \n", _footerVM];
    [strM appendFormat:@"  _itemMergeVM (strong) : %@, \n", _itemMergeVM];
    
    if ( yesOrNo ) {
        NSMutableString *arrStrM = [NSMutableString stringWithString:@"(\n"];
        NSInteger maxIdx = self.count - 1;
        [_itemArrM enumerateObjectsUsingBlock:^(AGViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ( idx == maxIdx ) {
                [arrStrM appendFormat:@"♦️%@%@ \n", @(idx), [obj ag_debugString]];
            }
            else {
                [arrStrM appendFormat:@"♦️%@%@, \n", @(idx), [obj ag_debugString]];
            }
        }];
        
        [arrStrM appendFormat:@")"];
        
        [strM appendFormat:@"  _itemArrM - Capacity:%@ - Count:%@ : %@", @(_capacity), @(self.count), arrStrM];
    }
    else {
        [strM appendFormat:@"  _itemArrM - Capacity:%@ - Count:%@ : %@", @(_capacity), @(self.count), _itemArrM];
    }
    
    return [NSString stringWithFormat:@"🔷 <%@: %p> --- {\n%@\n}", [self class] , self, strM];
}

@end


@implementation AGVMSection (AGVMJSONTransformable)
- (NSString *) ag_toJSONStringWithExchangeKey:(AGViewModel *)vm
                              customTransform:(AGVMJSONTransformBlock)block
{
    NSMutableDictionary *dictM = ag_mutableDict(4);
    dictM[kAGVMCommonVM] = _cvm;
    dictM[kAGVMHeaderVM] = _headerVM;
    dictM[kAGVMArray] = _itemArrM;
    dictM[kAGVMFooterVM] = _footerVM;
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

/** Quickly create AGVMSection instance */
AGVMSection * ag_VMSection(NSInteger capacity)
{
    return [AGVMSection newWithItemCapacity:capacity];
}


