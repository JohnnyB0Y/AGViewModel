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
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *archivedDictM;

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
    NSMutableArray *itemArrM = [NSMutableArray arrayWithCapacity:capacity];
    return [self initWithItems:itemArrM];
}

+ (instancetype) newWithItems:(NSMutableArray<AGViewModel *> *)itemArrM
{
    return [[self alloc] initWithItems:itemArrM];
}

- (instancetype) initWithItems:(NSMutableArray<AGViewModel *> *)itemArrM
{
    self = [super init];
    if ( self == nil ) return nil;
    _capacity = itemArrM ? itemArrM.count : 6;
    _itemArrM = itemArrM ?: [NSMutableArray arrayWithCapacity:_capacity];
    
    return self;
}

#pragma mark - ---------- Public Methods ----------
- (AGViewModel *) ag_packageHeaderData:(NS_NOESCAPE AGVMPackageDataBlock)package
{
    return [self ag_packageHeaderData:package capacity:6];
}

- (AGViewModel *) ag_packageItemData:(NS_NOESCAPE AGVMPackageDataBlock)package
{
    return [self ag_packageItemData:package capacity:6];
}

- (AGVMSection *) ag_packageItems:(NSArray *)items
						  inBlock:(NS_NOESCAPE AGVMPackageDatasBlock)block
{
	return [self ag_packageItems:items inBlock:block capacity:6];
}

- (AGVMSection *) ag_packageItems:(NSArray *)items
						  inBlock:(NS_NOESCAPE AGVMPackageDatasBlock)block
						 capacity:(NSInteger)capacity
{
	NSArray *arr = [ag_sharedVMPackager() ag_packageItems:items
												  mergeVM:_itemMergeVM
												  inBlock:block
												 capacity:capacity];
	[self ag_addItemsFromArray:arr];
	return self;
}

- (AGViewModel *) ag_packageFooterData:(NS_NOESCAPE AGVMPackageDataBlock)package
{
    return [self ag_packageFooterData:package capacity:6];
}

- (AGViewModel *)ag_packageCommonData:(NS_NOESCAPE AGVMPackageDataBlock)package
{
    return [self ag_packageCommonData:package capacity:6];
}

- (AGViewModel *) ag_packageHeaderData:(NS_NOESCAPE AGVMPackageDataBlock)package
                              capacity:(NSInteger)capacity
{
    _headerVM = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _headerVM;
}

- (AGViewModel *) ag_packageItemData:(NS_NOESCAPE AGVMPackageDataBlock)package
                            capacity:(NSInteger)capacity
{
    AGViewModel *vm =
    [ag_sharedVMPackager() ag_package:package mergeVM:_itemMergeVM capacity:capacity];
    if (vm) [self.itemArrM addObject:vm];
    return vm;
}

- (AGViewModel *) ag_packageFooterData:(NS_NOESCAPE AGVMPackageDataBlock)package
                              capacity:(NSInteger)capacity
{
    _footerVM = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _footerVM;
}

- (AGViewModel *)ag_packageCommonData:(NS_NOESCAPE AGVMPackageDataBlock)package
                             capacity:(NSInteger)capacity
{
    _cvm = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _cvm;
}

/** 拼装 itemArr 中 viewModel 的共同字典数据 */
- (AGViewModel *) ag_packageItemMergeData:(NS_NOESCAPE AGVMPackageDataBlock)package
                                 capacity:(NSInteger)capacity
{
    _itemMergeVM = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _itemMergeVM;
}

- (AGViewModel *) ag_packageItemMergeData:(NS_NOESCAPE AGVMPackageDataBlock)package
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
    vms->_archivedDictM = [_archivedDictM mutableCopy];
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
    vms->_archivedDictM = [_archivedDictM mutableCopy];
    [self ag_enumerateItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSUInteger idx, BOOL * _Nonnull stop) {
        [vms ag_addItem:[vm mutableCopy]];
    }];
    return vms;
}

#pragma mark - NSSecureCoding
+ (BOOL)supportsSecureCoding
{
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    if ( _archivedDictM.count < 0 ) {
        NSLog(@"Please add the keys that need to be archived.");
        return;
    }
    
    NSString *archiveCommonVMKey = self.archivedDictM[kAGVMCommonVM];
    NSString *archiveHeaderVMKey = self.archivedDictM[kAGVMHeaderVM];
    NSString *archiveFooterVMKey = self.archivedDictM[kAGVMFooterVM];
    NSString *archiveItemArrMKey = self.archivedDictM[kAGVMArray];
    [aCoder encodeObject:self.archivedDictM forKey:kAGVMDictionary];
    
    if ( self->_cvm && archiveCommonVMKey )
        [aCoder encodeObject:self->_cvm forKey:archiveCommonVMKey];
    
    if ( self->_headerVM && archiveHeaderVMKey )
        [aCoder encodeObject:self->_headerVM forKey:archiveHeaderVMKey];
    
    if ( self->_footerVM && archiveFooterVMKey )
        [aCoder encodeObject:self->_footerVM forKey:archiveFooterVMKey];
    
    if ( self->_itemArrM.count > 0 && archiveItemArrMKey )
        [aCoder encodeObject:self->_itemArrM forKey:archiveItemArrMKey];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    Class selfCls = self.class;
    NSDictionary *archiveKeyDict = [aDecoder decodeObjectOfClass:selfCls forKey:kAGVMDictionary];
    NSString *archiveItemArrMKey = archiveKeyDict[kAGVMArray];
    
    NSMutableArray *itemArrM;
    if ( archiveItemArrMKey )
        itemArrM = [[aDecoder decodeObjectOfClass:selfCls forKey:archiveItemArrMKey] mutableCopy];
    
    self = [self initWithItems:itemArrM];
    if ( self == nil ) return nil;
    
    NSString *archiveCommonVMKey = archiveKeyDict[kAGVMCommonVM];
    NSString *archiveHeaderVMKey = archiveKeyDict[kAGVMHeaderVM];
    NSString *archiveFooterVMKey = archiveKeyDict[kAGVMFooterVM];
    
    if ( archiveCommonVMKey )
        self->_cvm = [aDecoder decodeObjectOfClass:selfCls forKey:archiveCommonVMKey];
    
    if ( archiveHeaderVMKey )
        self->_headerVM = [aDecoder decodeObjectOfClass:selfCls forKey:archiveHeaderVMKey];
    
    if ( archiveFooterVMKey )
        self->_footerVM = [aDecoder decodeObjectOfClass:selfCls forKey:archiveFooterVMKey];
    
    if ( archiveKeyDict )
        self->_archivedDictM = [archiveKeyDict mutableCopy];
    
    return self;
}

/** 自定义 归档(NSKeyedArchiver)、转Json字符串当中的 Key。*/
- (void) ag_addArchivedCommonVMKey:(NSString *)key
{
    NSParameterAssert(key);
    [self.archivedDictM setObject:key forKey:kAGVMCommonVM];
}

- (void) ag_addArchivedHeaderVMKey:(NSString *)key
{
    NSParameterAssert(key);
    [self.archivedDictM setObject:key forKey:kAGVMHeaderVM];
}

- (void) ag_addArchivedFooterVMKey:(NSString *)key
{
    NSParameterAssert(key);
    [self.archivedDictM setObject:key forKey:kAGVMFooterVM];
}

- (void) ag_addArchivedItemArrMKey:(NSString *)key
{
    NSParameterAssert(key);
    [self.archivedDictM setObject:key forKey:kAGVMArray];
}

/** 添加到支持 归档(NSKeyedArchiver)、转Json字符串当中的 Key，使用类内置的key */
- (void) ag_addAllArchivedObjectUseDefaultKeys
{
    [self.archivedDictM setObject:kAGVMCommonVM forKey:kAGVMCommonVM];
    [self.archivedDictM setObject:kAGVMHeaderVM forKey:kAGVMHeaderVM];
    [self.archivedDictM setObject:kAGVMFooterVM forKey:kAGVMFooterVM];
    [self.archivedDictM setObject:kAGVMArray forKey:kAGVMArray];
}

/** 移除要归档和转字符串的 keys */
- (void) ag_removeArchivedCommonVMKey
{
    [_archivedDictM removeObjectForKey:kAGVMCommonVM];
}

- (void) ag_removeArchivedHeaderVMKey
{
    [_archivedDictM removeObjectForKey:kAGVMHeaderVM];
}

- (void) ag_removeArchivedFooterVMKey
{
    [_archivedDictM removeObjectForKey:kAGVMFooterVM];
}

- (void) ag_removeArchivedItemArrMKey
{
    [_archivedDictM removeObjectForKey:kAGVMArray];
}

- (void) ag_removeAllArchivedObjectKeys
{
    [_archivedDictM removeAllObjects];
}

#pragma mark AGVMJSONTransformable
- (NSString *) ag_toJSONStringWithExchangeKey:(AGViewModel *)vm
                              customTransform:(NS_NOESCAPE AGVMJSONTransformBlock)block
{
    if ( _archivedDictM.count < 0 ) {
        NSLog(@"Please add the keys that need to transform json.");
        return nil;
    }
    
    NSString *archiveCommonVMKey = self.archivedDictM[kAGVMCommonVM];
    NSString *archiveHeaderVMKey = self.archivedDictM[kAGVMHeaderVM];
    NSString *archiveFooterVMKey = self.archivedDictM[kAGVMFooterVM];
    NSString *archiveItemArrMKey = self.archivedDictM[kAGVMArray];
    
    NSMutableDictionary *dictM = ag_newNSMutableDictionary(4);
    
    if ( archiveCommonVMKey )
        dictM[archiveCommonVMKey] = _cvm ?: @"{}";
    
    if ( archiveHeaderVMKey )
        dictM[archiveHeaderVMKey] = _headerVM ?: @"{}";
    
    if ( archiveFooterVMKey )
        dictM[archiveFooterVMKey] = _footerVM ?: @"{}";
    
    if ( archiveItemArrMKey )
        dictM[archiveItemArrMKey] = _itemArrM ?: @"[]";
    
    return ag_newJSONStringWithDictionary(dictM, vm, block);
}

- (NSString *)ag_toJSONStringWithCustomTransform:(NS_NOESCAPE AGVMJSONTransformBlock)block
{
    return [self ag_toJSONStringWithExchangeKey:nil customTransform:block];
}

- (NSString *)ag_toJSONString
{
    return [self ag_toJSONStringWithCustomTransform:nil];
}

#pragma mark - 增删改查
#pragma mark 插入
- (void) ag_insertItemsFromSection:(AGVMSection *)vms atIndex:(NSInteger)index
{
    return [self ag_insertItemsFromArray:vms.itemArrM atIndex:index];
}

- (void) ag_insertItemsFromArray:(NSArray<AGViewModel *> *)vmArr
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
}

- (void) ag_insertItemPackage:(NS_NOESCAPE AGVMPackageDataBlock)package
                      atIndex:(NSInteger)index
                     capacity:(NSInteger)capacity
{
    AGViewModel *vm = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return [self ag_insertItem:vm atIndex:index];
}

- (void) ag_insertItemPackage:(NS_NOESCAPE AGVMPackageDataBlock)package
                      atIndex:(NSInteger)index
{
    return [self ag_insertItemPackage:package atIndex:index capacity:6];
}

- (void)ag_insertItem:(AGViewModel *)item atIndex:(NSInteger)index
{
    item ? [self setObject:item atIndexedSubscript:index] : nil;
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
- (void) ag_addItemsFromSection:(AGVMSection *)vms
{
    [self ag_addItemsFromArray:vms.itemArrM];
}

- (void) ag_addItemsFromArray:(NSArray<AGViewModel *> *)vmArr
{
    vmArr.count > 0 ? [self.itemArrM addObjectsFromArray:vmArr] : nil;
}

- (void) ag_addItem:(AGViewModel *)item
{
    item ? [self.itemArrM addObject:item] : nil;
}

#pragma mark 更新
- (void) ag_makeItemsRefreshUIByUpdateModelInBlock:(NS_NOESCAPE AGVMUpdateModelBlock)block
{
    [self.itemArrM makeObjectsPerformSelector:@selector(ag_refreshUIByUpdateModelInBlock:) withObject:block];
}
- (void)ag_makeHeaderFooterRefreshUIByUpdateModelInBlock:(NS_NOESCAPE AGVMUpdateModelBlock)block
{
    [_headerVM ag_refreshUIByUpdateModelInBlock:block];
    [_footerVM ag_refreshUIByUpdateModelInBlock:block];
}

- (void)ag_makeItemsSetNeedsCachedBindingViewSize
{
    [self.itemArrM makeObjectsPerformSelector:@selector(ag_setNeedsCachedBindingViewSize)];
}
- (void)ag_makeHeaderFooterSetNeedsCachedBindingViewSize
{
    [_headerVM ag_setNeedsCachedBindingViewSize];
    [_footerVM ag_setNeedsCachedBindingViewSize];
}

- (void)ag_makeItemsSetNeedsRefreshUI
{
    [self.itemArrM makeObjectsPerformSelector:@selector(ag_setNeedsRefreshUI)];
}
- (void)ag_makeHeaderFooterSetNeedsRefreshUI
{
    [_headerVM ag_setNeedsRefreshUI];
    [_footerVM ag_setNeedsRefreshUI];
}

#pragma mark 移除
- (void) ag_removeAllItems
{
    [self.itemArrM removeAllObjects];
}

- (void) ag_removeItemAtIndex:(NSInteger)index
{
    index < self.count ? [self.itemArrM removeObjectAtIndex:index] : nil;
}

- (void) ag_removeLastObject
{
    [self.itemArrM removeLastObject];
}

- (void) ag_removeItem:(AGViewModel *)vm
{
	if (vm == nil) return;
    [self.itemArrM removeObject:vm];
}

- (void) ag_removeItemsFromArray:(NSArray<AGViewModel *> *)vmArr
{
	if (vmArr == nil) return;
    [self.itemArrM removeObjectsInArray:vmArr];
}

- (void) ag_removeItemsFromSection:(AGVMSection *)vms
{
    [self ag_removeItemsFromArray:vms.itemArrM];
}

#pragma mark 选中
- (AGViewModel *) objectAtIndexedSubscript:(NSInteger)idx
{
    return idx < self.count ? [self.itemArrM objectAtIndex:idx] : nil;
}

#pragma mark 合并
- (void) ag_mergeFromSection:(AGVMSection *)vms
{
	if (vms == nil) return;
    if ( vms.headerVM ) {
        _headerVM = _headerVM ?: ag_newAGViewModel(nil);
    }
    if ( vms.footerVM ) {
        _footerVM = _footerVM ?: ag_newAGViewModel(nil);
    }
    if ( vms.cvm ) {
        _cvm = _cvm ?: ag_newAGViewModel(nil);
    }
    if ( vms.itemMergeVM ) {
        _itemMergeVM = _itemMergeVM ?: ag_newAGViewModel(nil);
    }
    // 合并所有数据
    [self.headerVM ag_mergeModelFromViewModel:vms.headerVM];
    [self.footerVM ag_mergeModelFromViewModel:vms.footerVM];
    [self.cvm ag_mergeModelFromViewModel:vms.cvm];
    [self.itemMergeVM ag_mergeModelFromViewModel:vms.itemMergeVM];
    
    [self ag_addItemsFromSection:vms];
}

#pragma mark 交换
- (void) ag_exchangeItemAtIndex:(NSInteger)idx1 withItemAtIndex:(NSInteger)idx2
{
    if ( idx1 < self.count && idx2 < self.count )
        [self.itemArrM exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
}

#pragma mark 替换
- (void) ag_replaceItemAtIndex:(NSInteger)index withItem:(AGViewModel *)item
{
	if (item == nil) return;
    index < self.count ? [self.itemArrM replaceObjectAtIndex:index withObject:item] : nil;
}

#pragma mark 遍历
- (void) ag_enumerateItemsUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel * _Nonnull, NSUInteger, BOOL * _Nonnull))block
{
    if ( ! block ) return;
	
    [self.itemArrM enumerateObjectsUsingBlock:block];
}

/** 遍历所有 section 的 header、footer vm */
- (void) ag_enumerateHeaderFooterUsingBlock:(void (NS_NOESCAPE ^)(AGViewModel * _Nonnull, NSUInteger, BOOL * _Nonnull))block
{
    if ( ! block ) return;
    
    NSMutableArray *arrM = ag_newNSMutableArray(2);
    _headerVM ? [arrM addObject:_headerVM] : nil;
    _footerVM ? [arrM addObject:_footerVM] : nil;
    [arrM enumerateObjectsUsingBlock:block];
}

#pragma mark - map、filter、reduce
- (AGVMSection *) map:(NS_NOESCAPE AGVMMapBlock)block
{
	if ( ! block ) return self;
	AGVMSection *vms = ag_newAGVMSection(self.count);
	[self.itemArrM enumerateObjectsUsingBlock:^(AGViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ( [obj isKindOfClass:[AGViewModel class]] ) {
			AGViewModel *newVM = [obj mutableCopy];
			block(newVM);
			[vms ag_addItem:newVM];
		}
	}];
	return vms;
}

- (AGVMSection *) filter:(NS_NOESCAPE AGVMFilterBlock)block
{
	if ( ! block ) return self;
	AGVMSection *vms = ag_newAGVMSection(self.count);
	[self.itemArrM enumerateObjectsUsingBlock:^(AGViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ( [obj isKindOfClass:[AGViewModel class]] && block(obj) ) {
			[vms ag_addItem:[obj mutableCopy]];
		}
	}];
	return vms;
}

- (void) reduce:(NS_NOESCAPE AGVMReduceBlock)block
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

- (NSMutableDictionary<NSString *,id> *)archivedDictM
{
    if (_archivedDictM == nil) {
        _archivedDictM = ag_newNSMutableDictionary(4);
    }
    return _archivedDictM;
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


/** Quickly create AGVMSection instance */
AGVMSection * ag_newAGVMSection(NSInteger capacity)
{
    return [AGVMSection newWithItemCapacity:capacity];
}
