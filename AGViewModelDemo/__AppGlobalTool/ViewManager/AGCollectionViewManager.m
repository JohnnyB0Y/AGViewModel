//
//  AGCollectionViewManager.m
//
//
//  Created by JohnnyB0Y on 2017/9/14.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGCollectionViewManager.h"

@interface AGCollectionViewManager ()
{
    struct AGLayoutDelegateResponeMethods {
        
        unsigned int ag_sizeForItem                         : 1;
        unsigned int ag_insetForSection                     : 1;
        unsigned int ag_intervalForItem                     : 1;
        unsigned int ag_numberOfCols                        : 1;
        unsigned int ag_aspectRatioOfRow                    : 1;
        unsigned int ag_widthForCollectionView              : 1;
        unsigned int ag_layoutDirectionForCollectionView    : 1;
        
    } _layoutDelegateResponeMethod;
    
    struct AGCustomizableDelegateResponeMethods {
        
        unsigned int ag_classForItemAtIndexPath             : 1;
        unsigned int ag_classForHeaderViewAtIndexPath       : 1;
        unsigned int ag_classForFooterViewAtIndexPath       : 1;
        
    } _customizableDelegateResponeMethod;
    
    struct AGSetupDelegateResponeMethods {
        
        unsigned int ag_willSetupCellModel                  : 1;
        unsigned int ag_willSetupHeaderModel                : 1;
        unsigned int ag_willSetupFooterModel                : 1;
        
    } _setupDelegateResponeMethod;
    
    // 布局方向
    AGCollectionLayoutDirection _layoutDirection;
    CGSize                      _itemSize;
    CGSize                      _interval;
    UIEdgeInsets                _inset;
    CGFloat                     _aspectRatio;
    NSUInteger                  _cols;
}



@end

@implementation AGCollectionViewManager
@synthesize vmm = _vmm, view = _view,
headerRefreshingBlock = _headerRefreshingBlock,
footerRefreshingBlock = _footerRefreshingBlock,
itemClickBlock = _itemClickBlock;

#pragma mark - ----------- Life Cycle ----------
- (instancetype)initWithCellClasses:(NSArray<Class<AGCollectionCellReusable>> *)classes
                    originVMManager:(AGVMManager *)vmm
{
    return [self initWithCollectionView:nil cellClasses:classes originVMManager:vmm];
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView
                           cellClasses:(NSArray<Class<AGCollectionCellReusable>> *)classes
                       originVMManager:(AGVMManager *)vmm
{
    self = [super init];
    if ( self ) {
        // 赋值
        collectionView ? [self setView:collectionView] : nil;
        _vmm = vmm;
        _inset = UIEdgeInsetsZero;
        _interval = CGSizeZero;
        _itemSize = CGSizeZero;
        _aspectRatio = 1;
        _cols = 0;
        _layoutDirection = AGCollectionLayoutDirectionNone;
        
        // 注册 cell
        [classes enumerateObjectsUsingBlock:^(Class<AGCollectionCellReusable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            Class cellClass = obj;
            if ( [cellClass conformsToProtocol:@protocol(AGCollectionCellReusable)] ) {
                [cellClass ag_registerCellBy:self.view];
            }
            
        }];
        
        // set ui
        if (@available(iOS 11.0, *)) {
            _view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        else {
            // Fallback on earlier versions
            
        }
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.vmm.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.vmm[section].count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    AGViewModel *vm = self.vmm[indexPath.section][indexPath.item];
    // setup vm
    if ( _setupDelegateResponeMethod.ag_willSetupCellModel ) {
        [_setupDelegate collectionViewManager:self willSetupCellModel:vm atIndexPath:indexPath];
    }
    
    // get class
    Class<AGCollectionCellReusable> cellClass;
    if ( _customizableDelegateResponeMethod.ag_classForItemAtIndexPath ) {
        cellClass = [_customizableDelegate collectionViewManager:self classForItemAtIndexPath:indexPath];
    }
    Class cls = vm[kAGVMViewClass];
    if ( cls == nil ) {
        NSString *className = vm[kAGVMViewClassName];
        cls = NSClassFromString(className);
        vm[kAGVMViewClass] = cls;
    }
    cellClass = cls ?: cellClass;
    
    // dequeue cell
    UICollectionViewCell<AGVMResponsive> *cell = [collectionView ag_dequeueCellWithClass:cellClass for:indexPath];
    
    NSAssert(cell, @"AGCollectionViewManager error: collectionViewCell can not be nil!");
    
    vm.setBindingView(cell).setDelegate(self.vmDelegate).setIndexPath(indexPath);
    [cell setViewModel:vm];
    return  cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView<AGVMResponsive> *supplementary;
    AGViewModel *vm;
    
    if ( kind == UICollectionElementKindSectionHeader ) {
        vm = self.vmm[indexPath.section].headerVM;
        // setup vm
        if ( _setupDelegateResponeMethod.ag_willSetupHeaderModel ) {
            [_setupDelegate collectionViewManager:self willSetupHeaderModel:vm atIndexPath:indexPath];
        }
        
        // get class
        Class<AGCollectionHeaderViewReusable> supplementaryClass;
        if ( _customizableDelegateResponeMethod.ag_classForHeaderViewAtIndexPath ) {
            supplementaryClass = [_customizableDelegate collectionViewManager:self classForHeaderViewAtIndexPath:indexPath];
        }
        Class cls = vm[kAGVMViewClass];
        if ( cls == nil ) {
            NSString *className = vm[kAGVMViewClassName];
            cls = NSClassFromString(className);
            vm[kAGVMViewClass] = cls;
        }
        supplementaryClass = cls ?: supplementaryClass;
        
        // dequeue header view
        supplementary = [collectionView ag_dequeueHeaderViewWithClass:supplementaryClass for:indexPath];
        
    }
    else if ( kind == UICollectionElementKindSectionFooter ) {
        vm = self.vmm[indexPath.section].footerVM;
        // setup vm
        if ( _setupDelegateResponeMethod.ag_willSetupFooterModel ) {
            [_setupDelegate collectionViewManager:self willSetupFooterModel:vm atIndexPath:indexPath];
        }
        
        // get class
        Class<AGCollectionFooterViewReusable> supplementaryClass;
        if ( _customizableDelegateResponeMethod.ag_classForFooterViewAtIndexPath ) {
            supplementaryClass = [_customizableDelegate collectionViewManager:self classForFooterViewAtIndexPath:indexPath];
        }
        Class cls = vm[kAGVMViewClass];
        if ( cls == nil ) {
            NSString *className = vm[kAGVMViewClassName];
            cls = NSClassFromString(className);
            vm[kAGVMViewClass] = cls;
        }
        supplementaryClass = cls ?: supplementaryClass;
        
        // dequeue footer view
        supplementary = [collectionView ag_dequeueFooterViewWithClass:supplementaryClass for:indexPath];
        
    }
    
    if ( supplementary && vm ) {
        [supplementary setViewModel:vm];
        vm.setBindingView(supplementary).setDelegate(self.vmDelegate).setIndexPath(indexPath);
    }
    
    return supplementary;
}

#pragma mark - UICollectionViewDelegate
#pragma mark - 选中 item
- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    AGViewModel *vm = self.vmm[indexPath.section][indexPath.item];
    vm.indexPath = indexPath;
    _itemClickBlock ? _itemClickBlock(collectionView, indexPath, vm) : nil;
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout*)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 1
    if ( _layoutDirection == AGCollectionLayoutDirectionNone ) {
        // 自定义 item size
        AGViewModel *vm = self.vmm[indexPath.section][indexPath.item];
        CGSize cellS = [vm ag_sizeOfBindingView];
        UIEdgeInsets insets = [self _insetForSection];
        if ( cellS.width <= 0 ) {
            cellS.width = collectionView.bounds.size.width - insets.left - insets.right;
        }
        return cellS;
    }
    return [self _sizeForItem];
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    // 2
    return [self _insetForSection];
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    // 4
    return [self _intervalForItem].height;
}

- (CGFloat) collectionView:(UICollectionView *)collectionView
                    layout:(UICollectionViewLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    // 3
    return [self _intervalForItem].width;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    AGViewModel *vm = self.vmm[section].headerVM;
    return [vm ag_sizeOfBindingView];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    AGViewModel *vm = self.vmm[section].footerVM;
    return [vm ag_sizeOfBindingView];
}

#pragma mark - ---------- Public Methods ----------
- (void)handleVMManager:(AGVMManager *)vmm inBlock:(NS_NOESCAPE ATVMManagerHandleBlock)block
{
    block ? block(self.vmm) : nil;
    
    [self stopRefresh];
    
    // 是否没有更多数据
    if ( vmm && ( ( vmm.count <= 0 ) || ( vmm.fs.count <= 0 && ( vmm.fs.headerVM == nil && vmm.fs.footerVM == nil ) ) ) ) {
        //self.vmm
        [self noMoreData];
    }
    else {
        
        if ( _layoutDelegateResponeMethod.ag_layoutDirectionForCollectionView ) {
            _layoutDirection = [_layoutDelegate layoutDirectionForCollectionView:self];
        }
    }
    // 刷新界面
    [self.view reloadData];
}

/**
 没有更多数据
 */
- (void) noMoreData
{
    [self.view.mj_footer endRefreshingWithNoMoreData];
}

/**
 开始刷新
 */
- (void) startRefresh
{
    [self.view.mj_header beginRefreshing];
}

- (void) stopRefresh
{
    [self.view.mj_header endRefreshing];
    [self.view.mj_footer endRefreshing];
}

- (void) registerFooterViewClasses:(NSArray<Class<AGCollectionFooterViewReusable>> *)classes
{
    [classes enumerateObjectsUsingBlock:^(Class<AGCollectionFooterViewReusable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        Class footerViewClass = obj;
        if ( [footerViewClass conformsToProtocol:@protocol(AGCollectionFooterViewReusable)] ) {
            [footerViewClass ag_registerFooterViewBy:self.view];
        }
        
    }];
}

- (void) registerHeaderViewClasses:(NSArray<Class<AGCollectionHeaderViewReusable>> *)classes
{
    [classes enumerateObjectsUsingBlock:^(Class<AGCollectionHeaderViewReusable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        Class headerViewClass = obj;
        if ( [headerViewClass conformsToProtocol:@protocol(AGCollectionHeaderViewReusable)] ) {
            [headerViewClass ag_registerHeaderViewBy:self.view];
        }
        
    }];
}

#pragma mark - ---------- Private Methods ----------
- (CGSize) _sizeForItem
{
    if (  ! self.cacheLayout  ) {
        _itemSize = [self _sizeForItemWithLayoutDirection:_layoutDirection];
    }
    return _itemSize;
}

- (CGSize) _sizeForItemWithLayoutDirection:(AGCollectionLayoutDirection)layoutDirection
{
    CGFloat width = self.view.frame.size.width;
    CGSize interval = [self _intervalForItem];
    UIEdgeInsets insets = [self _insetForSection];
    CGFloat aspectRatio = .0;
    
    BOOL haveSize = NO;
    BOOL haveCol = NO;
    BOOL haveAspectRatio = NO;
    
    if ( _layoutDelegateResponeMethod.ag_widthForCollectionView ) {
        width = [_layoutDelegate widthForCollectionView:self];
    }
    if ( _layoutDelegateResponeMethod.ag_sizeForItem ) {
        _itemSize = [_layoutDelegate sizeForItemInCollectionView:self];
        haveSize = YES;
    }
    if ( _layoutDelegateResponeMethod.ag_numberOfCols ) {
        _cols = [_layoutDelegate numberOfColsInCollectionView:self];
        haveCol = _cols > 0 ? YES : NO;
    }
    if ( _layoutDelegateResponeMethod.ag_aspectRatioOfRow ) {
        aspectRatio = [_layoutDelegate aspectRatioOfRowInCollectionView:self];
        haveAspectRatio = YES;
    }
    
    switch (layoutDirection) {
        case AGCollectionLayoutDirectionCenter: {
            // 控制宽度
            if ( haveSize && ! haveCol ) {
                _cols = (width-(insets.left+insets.right)+interval.width)/(_itemSize.width+interval.width);
                _cols = _cols > 0 ? _cols : 1;
            }
            // 计算
            CGFloat itemW = floor((width - (insets.left+insets.right)-(interval.width*(_cols - 1))) / _cols);
            if ( haveSize && _itemSize.width < itemW ) {
                interval.width = floor((width - (insets.left+insets.right) - _cols*itemW) / (_cols - 1));
            }
            else {
                _itemSize.width = itemW;
            }
            
            if ( haveAspectRatio ) {
                _itemSize.height = _itemSize.width / aspectRatio;
            }
            else if ( ! haveSize ) {
                _itemSize.height = _itemSize.width;
            }
            
        } break;
            
        case AGCollectionLayoutDirectionLeft: {
            
            
        } break;
            
        case AGCollectionLayoutDirectionRight: {
            
            
        } break;
            
        case AGCollectionLayoutDirectionTop: {
            
            
        } break;
            
        case AGCollectionLayoutDirectionBotton: {
            
            
        } break;
            
        case AGCollectionLayoutDirectionNone: {
            
            
        } break;
    }
    
    return _itemSize;
}

- (CGSize) _intervalForItem
{
    if ( ! self.cacheLayout ) {
        if ( _layoutDelegateResponeMethod.ag_intervalForItem ) {
            _interval = [_layoutDelegate intervalForItemInCollectionView:self];
        }
    }
    
    switch (_layoutDirection) {
        case AGCollectionLayoutDirectionCenter: {
            
            
        } break;
            
        case AGCollectionLayoutDirectionLeft: {
            
            
        } break;
            
        case AGCollectionLayoutDirectionRight: {
            
            
        } break;
            
        case AGCollectionLayoutDirectionTop: {
            
            
        } break;
            
        case AGCollectionLayoutDirectionBotton: {
            
            
        } break;
            
        case AGCollectionLayoutDirectionNone: {
            
            
        } break;
    }
    
    return _interval;
}

- (UIEdgeInsets) _insetForSection
{
    if (  ! self.cacheLayout  ) {
        if ( _layoutDelegateResponeMethod.ag_insetForSection ) {
            _inset = [_layoutDelegate insetForSectionInCollectionView:self];
        }
    }
    return _inset;
}

#pragma mark - ---------- Event Methods ----------



#pragma mark - ----------- Getter Methods ----------
- (AGVMManager *)vmm
{
    if (_vmm == nil) {
        _vmm = ag_newAGVMManager(1);
        AGVMSection *vms = ag_newAGVMSection(120);
        [_vmm ag_addSection:vms];
    }
    return _vmm;
}

- (UICollectionView *)view
{
    if (_view == nil) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _view = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _view.showsVerticalScrollIndicator = NO;
        _view.showsHorizontalScrollIndicator = NO;
        _view.alwaysBounceVertical = YES;
        _view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _view.delegate = self;
        _view.dataSource = self;
    }
    return _view;
}

- (CGFloat)estimateHeight
{
    [self.view.superview setNeedsLayout];
    [self.view.superview layoutIfNeeded];
    
    CGSize itemS = [self _sizeForItem];
    CGSize interval = [self _intervalForItem];
    UIEdgeInsets insets = [self _insetForSection];
    
    __block CGFloat height = 0;
    // item 的高度
    for (NSInteger i = 0; i<self.vmm.count; i++) {
        NSUInteger row = ceil(self.vmm[i].count / (CGFloat)_cols);
        height += ( row * itemS.height ) + (row - 1) * interval.height + insets.top + insets.bottom;
    }
    
    // 加上 头尾视图
    [self.vmm ag_enumerateSectionsHeaderFooterUsingBlock:^(AGViewModel * _Nonnull vm, NSIndexPath * _Nonnull indexPath, BOOL * _Nonnull stop) {
        
        height += [vm ag_sizeOfBindingView].height;
        
    }];
    
    
    return ceil(height);
}

#pragma mark - ----------- Setter Methods ----------
- (void)setHeaderRefreshingBlock:(MJRefreshComponentRefreshingBlock)headerRefreshingBlock
{
    _headerRefreshingBlock = [headerRefreshingBlock copy];
    self.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:_headerRefreshingBlock];
}

- (void)setFooterRefreshingBlock:(MJRefreshComponentRefreshingBlock)footerRefreshingBlock
{
    _footerRefreshingBlock = [footerRefreshingBlock copy];
    self.view.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:_footerRefreshingBlock];
}

- (void)setView:(UICollectionView *)view
{
    _view = view;
    _view.delegate = self;
    _view.dataSource = self;
}

- (void)setLayoutDelegate:(id<AGCollectionViewManagerLayoutDelegate>)layoutDelegate
{
    _layoutDelegate = layoutDelegate;
    
    _layoutDelegateResponeMethod.ag_sizeForItem
    = [_layoutDelegate respondsToSelector:@selector(sizeForItemInCollectionView:)];
    
    _layoutDelegateResponeMethod.ag_insetForSection
    = [_layoutDelegate respondsToSelector:@selector(insetForSectionInCollectionView:)];
    
    _layoutDelegateResponeMethod.ag_intervalForItem
    = [_layoutDelegate respondsToSelector:@selector(intervalForItemInCollectionView:)];
    
    _layoutDelegateResponeMethod.ag_numberOfCols
    = [_layoutDelegate respondsToSelector:@selector(numberOfColsInCollectionView:)];
    
    _layoutDelegateResponeMethod.ag_aspectRatioOfRow
    = [_layoutDelegate respondsToSelector:@selector(aspectRatioOfRowInCollectionView:)];
    
    _layoutDelegateResponeMethod.ag_widthForCollectionView
    = [_layoutDelegate respondsToSelector:@selector(widthForCollectionView:)];
    
    _layoutDelegateResponeMethod.ag_layoutDirectionForCollectionView
    = [_layoutDelegate respondsToSelector:@selector(layoutDirectionForCollectionView:)];
    
}

- (void)setCustomizableDelegate:(id<AGCollectionViewManagerCustomizable>)customizableDelegate
{
    _customizableDelegate = customizableDelegate;
    
    _customizableDelegateResponeMethod.ag_classForItemAtIndexPath
    = [_customizableDelegate respondsToSelector:@selector(collectionViewManager:classForItemAtIndexPath:)];
    
    _customizableDelegateResponeMethod.ag_classForHeaderViewAtIndexPath
    = [_customizableDelegate respondsToSelector:@selector(collectionViewManager:classForHeaderViewAtIndexPath:)];
    
    _customizableDelegateResponeMethod.ag_classForFooterViewAtIndexPath
    = [_customizableDelegate respondsToSelector:@selector(collectionViewManager:classForFooterViewAtIndexPath:)];
}

- (void)setSetupDelegate:(id<AGCollectionViewManagerSettable>)setupDelegate
{
    _setupDelegate = setupDelegate;
    
    _setupDelegateResponeMethod.ag_willSetupCellModel
    = [_setupDelegate respondsToSelector:@selector(collectionViewManager:willSetupCellModel:atIndexPath:)];
    
    _setupDelegateResponeMethod.ag_willSetupHeaderModel
    = [_setupDelegate respondsToSelector:@selector(collectionViewManager:willSetupHeaderModel:atIndexPath:)];
    
    _setupDelegateResponeMethod.ag_willSetupFooterModel
    = [_setupDelegate respondsToSelector:@selector(collectionViewManager:willSetupFooterModel:atIndexPath:)];
    
}

@end

