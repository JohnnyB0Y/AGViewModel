//
//  AGTableViewManager.m
//
//
//  Created by JohnnyB0Y on 2017/9/11.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGTableViewManager.h"

@interface AGTableViewManager ()



@end

@implementation AGTableViewManager
@synthesize vmm = _vmm, view = _view,
headerRefreshingBlock = _headerRefreshingBlock,
footerRefreshingBlock = _footerRefreshingBlock,
itemClickBlock = _itemClickBlock;

#pragma mark - ----------- Life Cycle ----------
- (instancetype)initWithCellClasses:(NSArray<Class<AGTableCellReusable>> *)classes
                    originVMManager:(AGVMManager *)vmm
{
    return [self initWithTableView:nil cellClasses:classes originVMManager:vmm];
}

- (instancetype)initWithTableView:(UITableView *)tableView
                      cellClasses:(NSArray<Class<AGTableCellReusable>> *)classes
                  originVMManager:(AGVMManager *)vmm
{
    self = [super init];
    if ( self ) {
        // 赋值
        _vmm = vmm;
        tableView ? [self setView:tableView] : nil;
        
        // 注册 cell
        [classes enumerateObjectsUsingBlock:^(Class<AGTableCellReusable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            Class cellClass = obj;
            if ( [cellClass conformsToProtocol:@protocol(AGTableCellReusable)] ) {
                [cellClass ag_registerCellBy:self.view];
            }
            
        }];
        
        // set ui
        if (@available(iOS 11.0, *)) {
            _view.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            // 关闭 self-sizing
            _view.estimatedRowHeight = 0;
            _view.estimatedSectionHeaderHeight = 0;
            _view.estimatedSectionFooterHeight = 0;
        }
        else {
            // Fallback on earlier versions
            
        }
        
    }
    return self;
}

#pragma mark - ---------- TableView Delegate\DataSource -----------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.vmm.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vmm[section].count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AGViewModel *vm = self.vmm[indexPath.section][indexPath.row];
    // setup vm
    if ( [_setupDelegate respondsToSelector:@selector(tableViewManager:willSetupCellModel:atIndexPath:)] ) {
        [_setupDelegate tableViewManager:self willSetupCellModel:vm atIndexPath:indexPath];
    }
    
    // get class
    Class<AGTableCellReusable> cellClass;
    if ( [_customizableDelegate respondsToSelector:@selector(tableViewManager:classForItemAtIndexPath:)] ) {
        cellClass = [_customizableDelegate tableViewManager:self classForItemAtIndexPath:indexPath];
    }
    
    Class cls = vm[kAGVMViewClass];
    if ( cls == nil ) {
        NSString *className = vm[kAGVMViewClassName];
        cls = NSClassFromString(className);
        vm[kAGVMViewClass] = cls;
    }
    cellClass = cls ?: cellClass;
    
    // dequeue cell
    UITableViewCell<AGVMResponsive> *cell = [tableView ag_dequeueCellWithClass:cellClass for:indexPath];
    NSAssert(cell, @"AGTableViewManager error: tableViewCell can not be nil!");
    
    // setup cell
    vm.setBindingView(cell).setDelegate(self.vmDelegate).setIndexPath(indexPath);
    [cell setViewModel:vm];
    return  cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AGViewModel *vm = self.vmm[indexPath.section][indexPath.row];
    CGFloat aspectRatio = [vm[kAGVMViewAspectRatio] floatValue];
    CGFloat height = aspectRatio > 0 ?
    (tableView.bounds.size.width / aspectRatio) :
    ([vm ag_sizeOfBindingView].height ?: self.cellH);
    
    return height ?: .1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    AGViewModel *vm = self.vmm[section].headerVM;
    CGFloat height = [vm ag_sizeOfBindingView].height ?: self.sectionHeaderH;
    return height ?: .1;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    AGViewModel *vm = self.vmm[section].headerVM;
    // setup vm
    if ( [_setupDelegate respondsToSelector:@selector(tableViewManager:willSetupHeaderModel:atSection:)] ) {
        [_setupDelegate tableViewManager:self willSetupHeaderModel:vm atSection:section];
    }
    
    // get class
    Class<AGTableHeaderFooterViewReusable> headerClass;
    if ( [_customizableDelegate respondsToSelector:@selector(tableViewManager:classForHeaderViewAtIndexPath:)] ) {
        headerClass = [_customizableDelegate tableViewManager:self classForHeaderViewAtIndexPath:indexPath];
    }
    Class cls = vm[kAGVMViewClass];
    if ( cls == nil ) {
        NSString *className = vm[kAGVMViewClassName];
        cls = NSClassFromString(className);
        vm[kAGVMViewClass] = cls;
    }
    headerClass = cls ?: headerClass;
    
    // dequeue header view
    UITableViewHeaderFooterView<AGVMResponsive> *headerView;
    if ( headerClass ) {
        headerView = [tableView ag_dequeueHeaderFooterViewWithClass:headerClass];
        /** 断点在这!!!
         1.headerView 是否已注册。
         2.headerView 是否正确实现 AGTableHeaderFooterViewReusable 协议。
         */
        NSAssert(headerView, @"AGTableViewManager error: headerView can not be nil!");
        
        // setup header view
        vm.setBindingView(headerView).setDelegate(self.vmDelegate).setIndexPath(indexPath);
        [headerView setViewModel:vm];
    }
    
    // if need, return default header view.
    return headerView ?: [self dequeueNormalHeaderFooterView];
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    AGViewModel *vm = self.vmm[section].footerVM;
    CGFloat height = [vm ag_sizeOfBindingView].height ?: self.sectionFooterH;
    return height ?: .1;
}

- (UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:section];
    AGViewModel *vm = self.vmm[section].footerVM;
    // setup vm
    if ( [_setupDelegate respondsToSelector:@selector(tableViewManager:willSetupFooterModel:atSection:)] ) {
        [_setupDelegate tableViewManager:self willSetupFooterModel:vm atSection:section];
    }
    
    // get class
    Class<AGTableHeaderFooterViewReusable> footerClass;
    if ( [_customizableDelegate respondsToSelector:@selector(tableViewManager:classForFooterViewAtIndexPath:)] ) {
        footerClass = [_customizableDelegate tableViewManager:self classForFooterViewAtIndexPath:indexPath];
    }
    
    Class cls = vm[kAGVMViewClass];
    if ( cls == nil ) {
        NSString *className = vm[kAGVMViewClassName];
        cls = NSClassFromString(className);
        vm[kAGVMViewClass] = cls;
    }
    footerClass = cls ?: footerClass;
    
    // dequeue footer view
    UITableViewHeaderFooterView<AGVMResponsive> *footerView;
    if ( footerClass ) {
        footerView = [tableView ag_dequeueHeaderFooterViewWithClass:footerClass];
        /** 断点在这!!!
         1.footerView 是否已注册。
         2.footerView 是否正确实现 AGTableHeaderFooterViewReusable 协议。
         */
        NSAssert(footerView, @"AGTableViewManager error: footerView can not be nil!");
        
        // setup footer view
        vm.setBindingView(footerView).setDelegate(self.vmDelegate).setIndexPath(indexPath);
        [footerView setViewModel:vm];
    }
    
    // if need, return default footer view.
    return footerView ?: [self dequeueNormalHeaderFooterView];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    AGViewModel *vm = self.vmm[indexPath.section][indexPath.row];
    // 更新indexPath
    vm.indexPath = indexPath;
    _itemClickBlock ? _itemClickBlock(tableView, indexPath, vm) : nil;
}

#pragma mark ScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ( [_scrollDelegate respondsToSelector:@selector(tableViewManagerScrollToTop:)] ) {
        CGFloat offsetY = scrollView.contentOffset.y;
        if ( ! _canScroll ) {
            scrollView.contentOffset = CGPointZero;
        }
        
        if ( offsetY < 0 ) {
            _canScroll = NO;
            scrollView.contentOffset = CGPointZero;
            // 滚动交替
            [_scrollDelegate tableViewManagerScrollToTop:self];
        }
    }
    
}

#pragma mark EditingStyle
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [_editDelegate respondsToSelector:@selector(tableViewManager:editingStyleForRowAtIndexPath:)] ) {
        return [_editDelegate tableViewManager:self editingStyleForRowAtIndexPath:indexPath];
    }
    return UITableViewCellEditingStyleNone;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ( [_editDelegate respondsToSelector:@selector(tableViewManager:commitEditingStyle:forRowAtIndexPath:)] ) {
        [_editDelegate tableViewManager:self commitEditingStyle:editingStyle forRowAtIndexPath:indexPath];
    }
}

#pragma mark - ---------- Public Methods ----------
- (void)handleVMManager:(AGVMManager *)vmm inBlock:(NS_NOESCAPE ATVMManagerHandleBlock)block
{
    block ? block(self.vmm) : nil;
    
    [self stopRefresh];
    
    // 是否没有更多数据
    if ( vmm && ( ( vmm.count <= 0 ) || ( vmm.fs.count <= 0 && ( vmm.fs.headerVM == nil && vmm.fs.footerVM == nil ) ) ) ) {
        [self noMoreData];
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

- (void)registerHeaderFooterViewClasses:(NSArray<Class<AGTableHeaderFooterViewReusable>> *)classes
{
    [classes enumerateObjectsUsingBlock:^(Class<AGTableHeaderFooterViewReusable>  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        Class headerFooterViewClass = obj;
        if ( [headerFooterViewClass conformsToProtocol:@protocol(AGTableHeaderFooterViewReusable)] ) {
            [headerFooterViewClass ag_registerHeaderFooterViewBy:self.view];
        }
        
    }];
}

- (CGFloat) estimateHeightWithItem:(UIView<AGVMResponsive> *)item
{
    __block CGFloat height = 0;
    [self.vmm ag_enumerateSectionsUsingBlock:^(AGVMSection * _Nonnull vms, NSUInteger idx, BOOL * _Nonnull stop) {
        
        height += [vms.headerVM ag_sizeOfBindingView].height ?: self.sectionHeaderH;
        height += [vms.footerVM ag_sizeOfBindingView].height ?: self.sectionFooterH;
        
        [vms ag_enumerateItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSUInteger idx, BOOL * _Nonnull stop) {
            height += [vm ag_sizeForBindingView:item].height ?: self.cellH;
        }];
        
    }];
    
    return height;
}

#pragma mark 数据与界面的插入、删除、刷新
/**
 插入 vm
 
 @param viewModels 需要插入的 vm 数组
 @param animation 插入动画
 @param indexPath 插入的起始位置
 @return 是否插入成功
 */
- (BOOL)insertViewModels:(NSArray<AGViewModel *> *)viewModels
             atIndexPath:(NSIndexPath *)indexPath
        withRowAnimation:(UITableViewRowAnimation)animation
{
    return [self insertViewModels:viewModels atIndexPath:indexPath withRowAnimation:animation scrollToRowAtIndexPath:nil atScrollPosition:UITableViewScrollPositionNone];
}

/**
 插入 vm
 
 @param viewModels 需要插入的 vm 数组
 @param animation 插入动画
 @param indexPath 插入的起始位置
 @param scrollIndexPath 移动到的位置
 @param scrollPosition 移动到位置动画类型
 @return 是否插入成功
 */
- (BOOL)insertViewModels:(NSArray<AGViewModel *> *)viewModels
             atIndexPath:(NSIndexPath *)indexPath
        withRowAnimation:(UITableViewRowAnimation)animation
  scrollToRowAtIndexPath:(NSIndexPath *)scrollIndexPath
        atScrollPosition:(UITableViewScrollPosition)scrollPosition
{
    AGVMSection *vms = self.vmm[indexPath.section];
    NSMutableArray *indexPathsM = [NSMutableArray arrayWithCapacity:viewModels.count];
    for (NSInteger i = 0; i<viewModels.count; i++) {
        AGViewModel *vm = viewModels[i];
        NSIndexPath *newIndexPath =
        [NSIndexPath indexPathForRow:(indexPath.row + i) inSection:indexPath.section];
        vm.indexPath = newIndexPath;
        [indexPathsM addObject:newIndexPath];
    }
    
    if ( indexPathsM.count > 0 ) {
        // 插入数据
        [vms ag_insertItemsFromArray:viewModels atIndex:indexPath.row];
        
        // 更新后面items的 indexPath
        NSRange range = NSMakeRange([viewModels lastObject].indexPath.row, 24);
        [vms ag_enumerateItemsIfInRange:range usingBlock:^(AGViewModel * _Nonnull vm, NSUInteger idx, BOOL * _Nonnull stop) {
            vm.indexPath = [NSIndexPath indexPathForRow:range.location + idx inSection:indexPath.section];
        }];
        
        // 插入动画
        [self.view insertRowsAtIndexPaths:indexPathsM
                         withRowAnimation:animation];
        // 滚动到指定区域
        scrollIndexPath = scrollIndexPath ?: [indexPathsM lastObject];
        [self.view scrollToRowAtIndexPath:scrollIndexPath
                         atScrollPosition:scrollPosition
                                 animated:YES];
        return YES;
    }
    
    return NO;
}

/**
 删除 vm
 
 @param viewModels 需要插入的 vm 数组
 @param animation 插入动画
 @return 是否删除成功
 */
- (BOOL)deleteViewModels:(NSArray<AGViewModel *> *)viewModels
        withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray *delIndexPath = [NSMutableArray arrayWithCapacity:viewModels.count];
    NSMutableSet *delSectionSet = [NSMutableSet set];
    [viewModels enumerateObjectsUsingBlock:^(AGViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = obj.indexPath ?: [self.view indexPathForCell:(UITableViewCell *)obj.bindingView];
        
        NSAssert(indexPath, @"Can not get indexPath！");
        if ( indexPath ) {
            [delIndexPath addObject:indexPath];
            [delSectionSet addObject:@(indexPath.section)];
        }
    }];
    
    // 删数据
    [delIndexPath enumerateObjectsUsingBlock:^(NSIndexPath *indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AGVMSection *vms = self.vmm[indexPath.section];
        [vms ag_removeItemAtIndex:indexPath.row];
        
    }];
    
    // 更新后面items的 indexPath
    [delSectionSet enumerateObjectsUsingBlock:^(NSNumber *delSection, BOOL * _Nonnull stop) {
        
        NSInteger section = delSection.integerValue;
        AGVMSection *vms = self.vmm[section];
        [vms ag_enumerateItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSUInteger idx, BOOL * _Nonnull stop) {
            if ( vm.indexPath.row != idx ) {
                vm.indexPath = [NSIndexPath indexPathForRow:idx inSection:section];
            }
        }];
    }];
    
    if ( delIndexPath.count > 0 ) {
        // 更新界面
        [self.view deleteRowsAtIndexPaths:delIndexPath withRowAnimation:animation];
        return YES;
    }
    return NO;
}

/**
 刷新 vm
 
 @param viewModels 需要插入的 vm 数组
 @param animation 插入动画
 @return 是否刷新成功
 */
- (BOOL)reloadViewModels:(NSArray<AGViewModel *> *)viewModels
        withRowAnimation:(UITableViewRowAnimation)animation
{
    NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:viewModels.count];
    [viewModels enumerateObjectsUsingBlock:^(AGViewModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = obj.indexPath ?: [self.view indexPathForCell:(UITableViewCell *)obj.bindingView];
        NSAssert(indexPath, @"Can not get indexPath！");
        if ( indexPath ) {
            [indexPaths addObject:indexPath];
        }
    }];
    
    if ( indexPaths.count > 0 ) {
        // 更新界面
        [self.view reloadRowsAtIndexPaths:indexPaths withRowAnimation:animation];
        return YES;
    }
    return NO;
}

#pragma mark - ---------- Private Methods ----------
- (void) registerNormalHeaderFooterView
{
    Class reuseClass = [UITableViewHeaderFooterView class];
    NSString *reuseIdentifier = NSStringFromClass(reuseClass);
    [self.view registerClass:reuseClass forHeaderFooterViewReuseIdentifier:reuseIdentifier];
}

- (UITableViewHeaderFooterView *) dequeueNormalHeaderFooterView
{
    Class reuseClass = [UITableViewHeaderFooterView class];
    NSString *reuseIdentifier = NSStringFromClass(reuseClass);
    return [self.view dequeueReusableHeaderFooterViewWithIdentifier:reuseIdentifier];
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

- (UITableView *)view
{
    if (_view == nil) {
        _view = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _view.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _view.delegate = self;
        _view.dataSource = self;
        
        // 注册 headerFooterView
        [self registerNormalHeaderFooterView];
        
    }
    return _view;
}

- (UIView *)tableHeaderView
{
    return self.view.tableHeaderView;
}

- (UIView *)tableFooterView
{
    return self.view.tableFooterView;
}

- (CGFloat)estimateHeight
{
    __block CGFloat height = 0;
    [self.vmm ag_enumerateSectionsUsingBlock:^(AGVMSection * _Nonnull vms, NSUInteger idx, BOOL * _Nonnull stop) {
        
        height += [vms.headerVM ag_sizeOfBindingView].height ?: self.sectionHeaderH;
        height += [vms.footerVM ag_sizeOfBindingView].height ?: self.sectionFooterH;
        
        [vms ag_enumerateItemsUsingBlock:^(AGViewModel * _Nonnull vm, NSUInteger idx, BOOL * _Nonnull stop) {
            height += [vm ag_sizeOfBindingView].height ?: self.cellH;
        }];
        
    }];
    
    return height;
}

#pragma mark - ----------- Setter Methods ----------
- (void)setHeaderRefreshingBlock:(MJRefreshComponentAction)headerRefreshingBlock
{
    _headerRefreshingBlock = [headerRefreshingBlock copy];
    //设置下拉刷新
    self.view.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:_headerRefreshingBlock];
}

- (void)setFooterRefreshingBlock:(MJRefreshComponentAction)footerRefreshingBlock
{
    _footerRefreshingBlock = [footerRefreshingBlock copy];
    self.view.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:_footerRefreshingBlock];
}

- (void)setView:(UITableView *)view
{
    _view = view;
    _view.delegate = self;
    _view.dataSource = self;
    // 注册 headerFooterView
    [self registerNormalHeaderFooterView];
    
}

- (void)setTableHeaderView:(UIView *)tableHeaderView
{
    self.view.tableHeaderView = tableHeaderView;
}

- (void)setTableFooterView:(UIView *)tableFooterView
{
    self.view.tableFooterView = tableFooterView;
}

@end
