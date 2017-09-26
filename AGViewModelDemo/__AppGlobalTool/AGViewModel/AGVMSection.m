//
//  AGVMSection.m
//  
//
//  Created by JohnnyB0Y on 2017/7/10.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  一组 View Model 数据

#import "AGVMSection.h"
#import <objc/runtime.h>

@interface AGVMSection ()

@property (nonatomic, strong) NSMutableArray<AGViewModel *> *itemArrM;

@end

@implementation AGVMSection {
    NSUInteger _capacity;
}

/**
 fast create vms
 
 @param capacity itemArrM 每次增量拷贝的内存大小
 @return vms
 */
+ (instancetype) ag_VMSectionWithItemCapacity:(NSUInteger)capacity
{
    return [[self alloc] initWithItemCapacity:capacity];
}

- (instancetype) initWithItemCapacity:(NSUInteger)capacity
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

- (NSArray<AGViewModel *> *) ag_packageItems:(NSArray *)items
                                     inBlock:(AGVMPackageDatasBlock)block
{
    return [self ag_packageItems:items inBlock:block capacity:items.count];
}

- (NSArray<AGViewModel *> *) ag_packageItems:(NSArray *)items
                                     inBlock:(AGVMPackageDatasBlock)block
                                    capacity:(NSUInteger)capacity
{
    NSArray *arr = [ag_sharedVMPackager() ag_packageItems:items
                                                 commonVM:_itemCommonVM
                                                  inBlock:block
                                                 capacity:capacity];
    [self ag_addItemsFromArray:arr];
    return arr;
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
                              capacity:(NSUInteger)capacity
{
    _headerVM = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _headerVM;
}

- (AGViewModel *) ag_packageItemData:(AGVMPackageDataBlock)package
                            capacity:(NSUInteger)capacity
{
    AGViewModel *vm =
    [ag_sharedVMPackager() ag_package:package commonVM:_itemCommonVM capacity:capacity];
    if (vm) [self.itemArrM addObject:vm];
    return vm;
}

- (AGViewModel *) ag_packageFooterData:(AGVMPackageDataBlock)package
                              capacity:(NSUInteger)capacity
{
    _footerVM = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _footerVM;
}

- (AGViewModel *)ag_packageCommonData:(AGVMPackageDataBlock)package
                             capacity:(NSUInteger)capacity
{
    _commonVM = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _commonVM;
}

/** 拼装 itemArr 中 viewModel 的共同字典数据 */
- (AGViewModel *) ag_packageItemCommonData:(AGVMPackageDataBlock)package
                                  capacity:(NSUInteger)capacity
{
    _itemCommonVM = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return _itemCommonVM;
}

- (AGViewModel *) ag_packageItemCommonData:(AGVMPackageDataBlock)package
{
    return [self ag_packageItemCommonData:package capacity:6];
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

- (AGViewModel *)ag_packageHeaderData:(NSDictionary *)data
                             packager:(id<AGVMPackagable>)packager
{
    return [self ag_packageHeaderData:data packager:packager forObject:nil];
}

/** 通过 packager 拼装 item 数据 */
- (AGViewModel *) ag_packageItemData:(NSDictionary *)data
                            packager:(id<AGVMPackagable>)packager
                           forObject:(id)obj
{
    AGViewModel *vm;
    if ( [packager respondsToSelector:@selector(ag_packageData:forObject:)] ) {
        vm = [packager ag_packageData:data forObject:(id)obj];
        if (vm) [self.itemArrM addObject:vm];
    }
    return vm;
}

- (AGViewModel *)ag_packageItemData:(NSDictionary *)data
                           packager:(id<AGVMPackagable>)packager
{
    return [self ag_packageItemData:data packager:packager forObject:nil];
}

/** 通过 packager 拼装组尾数据 */
- (AGViewModel *) ag_packageFooterData:(NSDictionary *)data
                              packager:(id<AGVMPackagable>)packager
                             forObject:(id)obj
{
    if ( [packager respondsToSelector:@selector(ag_packageData:forObject:)] ) {
        _footerVM = [packager ag_packageData:data forObject:(id)obj];
    }
    return _footerVM;
}

- (AGViewModel *)ag_packageFooterData:(NSDictionary *)data
                             packager:(id<AGVMPackagable>)packager
{
    return [self ag_packageFooterData:data packager:packager forObject:nil];
}

#pragma mark - NSCopying
- (id)copyWithZone:(nullable NSZone *)zone
{
    AGVMSection *vms = [[self.class allocWithZone:zone] initWithCapacity:_capacity];
    vms->_commonVM = [_commonVM copy];
    vms->_headerVM = [_headerVM copy];
    vms->_footerVM = [_footerVM copy];
    vms->_itemCommonVM = [_itemCommonVM copy];
    [vms ag_addItemsFromSection:self];
    return vms;
}

#pragma mark - 增删改查
#pragma mark 插入
- (AGVMSection *) ag_insertItemsFromSection:(AGVMSection *)vms atIndex:(NSUInteger)index
{
    return [self ag_insertItemsFromArray:vms.itemArrM atIndex:index];
}

- (AGVMSection *) ag_insertItemsFromArray:(NSArray<AGViewModel *> *)vmArr
                                  atIndex:(NSUInteger)index
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
                               atIndex:(NSUInteger)index
                              capacity:(NSUInteger)capacity
{
    AGViewModel *vm = [ag_sharedVMPackager() ag_package:package capacity:capacity];
    return [self ag_insertItem:vm atIndex:index];
}

- (AGVMSection *) ag_insertItemPackage:(AGVMPackageDataBlock)package
                               atIndex:(NSUInteger)index
{
    return [self ag_insertItemPackage:package atIndex:index capacity:6];
}

- (AGVMSection *)ag_insertItem:(AGViewModel *)item atIndex:(NSUInteger)index
{
    item ? [self setObject:item atIndexedSubscript:index] : nil;
    return self;
}

- (void)setObject:(AGViewModel *)vm atIndexedSubscript:(NSUInteger)idx
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
- (AGVMSection *) ag_updateItemInBlock:(AGVMUpdateModelBlock)block
                               atIndex:(NSUInteger)index
{
    if ( block ) {
        AGViewModel *vm = self[index];
        vm ? block(vm.bindingModel) : NSLog(@"你要更新的 View Model 不存在！");
    }
    return self;
}

- (AGVMSection *) ag_refreshItemByUpdateModelInBlock:(NS_NOESCAPE AGVMUpdateModelBlock)block
                                             atIndex:(NSUInteger)index
{
    NSAssert(block, @"block nonnull.");
    if ( block ) {
        AGViewModel *vm = self[index];
        vm ? [vm ag_refreshViewByUpdateModelInBlock:block] : nil;
    }
    return self;
}

- (AGVMSection *) ag_refreshItemsByUpdateModelInBlock:(AGVMUpdateModelBlock)block
{
    NSAssert(block, @"block nonnull.");
    if ( block ) {
        [self ag_enumerateItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSUInteger idx, BOOL * _Nonnull stop) {
            [vm ag_refreshViewByUpdateModelInBlock:block];
        }];
    }
    return self;
}

#pragma mark 移除
- (AGVMSection *) ag_removeAllItems
{
    [self.itemArrM removeAllObjects];
    return self;
}

- (AGVMSection *) ag_removeItemAtIndex:(NSUInteger)index
{
    index < self.count ? [self.itemArrM removeObjectAtIndex:index] : nil;
    return self;
}

- (AGVMSection *) ag_removeLastObject
{
    [self.itemArrM removeLastObject];
    return self;
}

#pragma mark 选中
- (AGViewModel *) objectAtIndexedSubscript:(NSUInteger)idx
{
    return idx < self.count ? [self.itemArrM objectAtIndex:idx] : nil;
}

- (NSArray *) ag_findValueInItemArrWithKey:(NSString *)key
{
    NSMutableArray *arrM = ag_mutableArray(self.count);
    [self.itemArrM enumerateObjectsUsingBlock:^(AGViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        id findObj = obj[key];
        if ( findObj ) [arrM addObject:findObj];
    }];
    
    return [arrM copy];
}

#pragma mark 合并
- (AGVMSection *) ag_mergeFromSection:(AGVMSection *)vms
{
    // 合并所有数据
    [self.headerVM ag_mergeModelFromViewModel:vms.headerVM];
    [self.footerVM ag_mergeModelFromViewModel:vms.footerVM];
    [self.commonVM ag_mergeModelFromViewModel:vms.commonVM];
    [self.itemCommonVM ag_mergeModelFromViewModel:vms.itemCommonVM];
    [self ag_addItemsFromSection:vms];
    
    return self;
}

#pragma mark 交换
- (AGVMSection *) ag_exchangeItemAtIndex:(NSUInteger)idx1 withItemAtIndex:(NSUInteger)idx2
{
    if ( idx1 < self.count && idx2 < self.count )
        [self.itemArrM exchangeObjectAtIndex:idx1 withObjectAtIndex:idx2];
    
    return self;
}

#pragma mark 替换
- (AGVMSection *) ag_replaceItemAtIndex:(NSUInteger)index withItem:(AGViewModel *)item
{
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

#pragma mark - ---------- Private Methods ----------


#pragma mark - ----------- Getter Methods ----------
- (NSUInteger) count
{
    return self.itemArrM.count;
}

- (AGViewModel *)firstViewModel
{
    return [self.itemArrM firstObject];
}

- (AGViewModel *)lastViewModel
{
    return [self.itemArrM lastObject];
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

/** fast create AGVMSection instance */
AGVMSection * ag_VMSection(NSUInteger capacity)
{
    return [AGVMSection ag_VMSectionWithItemCapacity:capacity];
}


