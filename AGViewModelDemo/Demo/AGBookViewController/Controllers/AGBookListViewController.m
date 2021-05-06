//
//  AGBookListViewController.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "AGBookListViewController.h"
#import "AGBookDetailViewController.h"
#import "AGDiskBookListViewController.h"

#import "AGTableViewManager.h"
#import <SVProgressHUD.h>
#import <CTNetworking.h>
#import <Masonry.h>
#import "AGVMKit.h"
#import <AGCategories/UIColor+AGExtensions.h>
#import "AGSwitchControl.h"

#import "AGBookListCell.h"
#import "AGBookAPICaller.h"
#import "AGBookAPIKeys.h"


@interface AGBookListViewController ()
<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate,
AGVMDelegate, AGSwitchControlDataSource, AGSwitchControlDelegate>

/** ` */
@property (nonatomic, strong) AGTableViewManager *tableViewManager;
@property (nonatomic, strong) AGTableViewManager *tableViewManager1;
@property (nonatomic, strong) AGTableViewManager *tableViewManager2;

/** book api caller */
@property (nonatomic, strong) AGBookAPICaller *bookAPICaller;

/** switch control */
@property (nonatomic, strong) AGSwitchControl *switchControl;

/** switch items */
@property (nonatomic, strong) AGVMSection *itemsData;

@end

@implementation AGBookListViewController {
    UIDeviceOrientation _currentOrientation;
}

#pragma mark - ----------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addSubviews];
    
    [self _addSubviewCons];
    
    [self _setupUI];
    
    [self _addActions];
    
    [self _networkRequest];
}

- (void)dealloc
{
    [SVProgressHUD dismiss];
    
    // 取消挂起的网络请求
    [self.bookAPICaller cancelAllRequests];
}

+ (AGResourceFileType)typeOfCreateInstance
{
    return AGResourceFileTypeCode;
}

#pragma mark - ---------- Custom Delegate ----------
#pragma mark - CTAPIManagerParamSourceDelegate
- (NSDictionary *) paramsForApi:(CTAPIBaseManager *)manager
{
    NSMutableDictionary *paramM = ag_newNSMutableDictionary(5);
    
    if ( manager == self.bookAPICaller.listAPIManager ) {
        // ... q={}&count={}&start={}
        
        AGViewModel *vm = self.itemsData[self.switchControl.currentIndex];
        NSString *title = vm[kAGVMTitleText];
        
        // https://suggest.taobao.com/sug?code=utf-8&q=%E5%8D%AB%E8%A1%A3&callback=cb
        paramM[@"q"] = title;
        paramM[@"code"] = @"utf-8";
        paramM[kAGVMIndex] = @(self.switchControl.currentIndex); // 用来区分返回的数据
    }
    
    return [paramM copy];
}

#pragma mark - CTAPIManagerApiCallBackDelegate
- (void) managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    [SVProgressHUD dismiss];
    
    if ( manager == self.bookAPICaller.listAPIManager ) {
        // ...
        NSInteger index = [manager.response.originRequestParams[kAGVMIndex] integerValue];
        AGViewModel *vm = self.itemsData[index];
        AGTableViewManager *tvm = [vm ag_weaklyObjectForKey:kAGVMObject];
        
        AGVMManager *vmm = [manager fetchDataWithReformer:self.bookAPICaller.listReformer];
        
        NSLog(@"%ld - %@ - count:%ld", index, vm[kAGVMTitleText], vmm.fs.count);
        
        AGVMManager *cache = vm[kAGVMManager];
        if ( self.bookAPICaller.listAPIManager.isFirstPage ) { // 第一页数据
            cache = [vmm copy];
            vm[kAGVMManager] = cache; // 缓存到vm
        }
        else { // 后续页面数据
            [cache.fs ag_addItemsFromSection:vmm.fs]; // 拼接到后面
        }
        
        [tvm handleVMManager:vmm inBlock:^(AGVMManager *originVmm) {
            [originVmm.fs ag_removeAllItems];
            [originVmm.fs ag_addItemsFromSection:cache.fs];
        }];
    }
}

- (void) managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    [SVProgressHUD dismiss];
    
    NSLog(@"%@ - %@", manager.response.content, manager.response.errorMessage);
    
    // 参数错误、返回数据错误
    if ( manager.verifyError ) {
        [SVProgressHUD showErrorWithStatus:manager.verifyError.msg];
    }
    
    NSInteger index = [manager.response.originRequestParams[kAGVMIndex] integerValue];
    AGViewModel *vm = self.itemsData[index];
    AGTableViewManager *tvm = [vm ag_weaklyObjectForKey:kAGVMObject];
    // 停止刷新
    [tvm stopRefresh];
}

#pragma mark - AGVMDelegate 你点击了图书封面
- (void)ag_viewModel:(AGViewModel *)vm handleAction:(SEL)action
{
    if ([vm.bindingView isKindOfClass:[AGBookListCell class]] ) { // 1. 判断是哪个cell
        if ( sel_isEqual(@selector(coverImageViewTap:), action) ) { // 2. 判断是哪个方法签名
            // ...图书封面点击
            [SVProgressHUD showInfoWithStatus:@"你点击了图书封面"]; // 3. 可以确定具体操作
            
            // 更新数据
            vm[kAGVMSelected] = @( ! [vm ag_safeBoolValueForKey:kAGVMSelected] );
            
            // 刷新UI
            [vm ag_refreshUI];
        }
    }
}

#pragma mark AGSwitchControlDataSource <NSObject>
/* 一共多少个标签 */
- (NSInteger) ag_numberOfItemInSwitchControl:(AGSwitchControl *)switchControl
{
    return self.itemsData.count;
}

- (AGViewModel *) ag_switchControl:(AGSwitchControl *)switchControl
      viewModelForTitleItemAtIndex:(NSInteger)index
{
    return self.itemsData[index];
}

- (UIView *) ag_switchControl:(AGSwitchControl *)switchControl
     viewForDetailItemAtIndex:(NSInteger)index
{
    AGViewModel *vm = self.itemsData[index];
    AGTableViewManager *tvm = [vm ag_weaklyObjectForKey:kAGVMObject];
    return tvm.view;
}

- (void)ag_switchControl:(AGSwitchControl *)switchControl clickTitleItemAtIndex:(NSInteger)index
{
    AGViewModel *vm = self.itemsData[index];
    // 当前视图数据
    [self _loadTableViewManagerNetworkDataIfNeedsWithViewModel:vm animation:YES];
}

- (void)ag_switchControl:(AGSwitchControl *)switchControl scrollViewWillBeginDraggingAtIndex:(NSInteger)index
{
    NSInteger leftIdx = index - 1;
    if ( leftIdx >= 0 ) {
        AGViewModel *vm = self.itemsData[leftIdx];
        [self _resetTableViewManagerCachedDataIfNeedsWithViewModel:vm];
    }
    
    NSInteger rightIdx = index + 1;
    if ( rightIdx < self.itemsData.count ) {
        AGViewModel *vm = self.itemsData[rightIdx];
        [self _resetTableViewManagerCachedDataIfNeedsWithViewModel:vm];
    }
}

#pragma mark - ---------- Public Methods ----------


#pragma mark - ---------- Event Methods ----------
- (void) rightBarButtonItemClick:(UIBarButtonItem *)item
{
    AGViewModel *vm = self.itemsData[self.switchControl.currentIndex];
    AGTableViewManager *tvm = [vm ag_weaklyObjectForKey:kAGVMObject];
    
    // 保存图书列表
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:tvm.vmm];
    [data writeToURL:[self _archiveURL] atomically:YES];
    
    // 跳转到磁盘图书列表视图控制器
    AGDiskBookListViewController *vc = [[AGDiskBookListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) handleDeviceOrientationChange:(NSNotification *)notification
{
//    NSLog(@"handleDeviceOrientationChange");
//
//
//    BOOL change = NO;
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    if (orientation == UIDeviceOrientationLandscapeLeft ||
//        orientation == UIDeviceOrientationLandscapeRight ) {
//        // 侧面
//        if (_currentOrientation != UIDeviceOrientationLandscapeLeft &&
//            _currentOrientation != UIDeviceOrientationLandscapeRight ) {
//            change = YES;
//            _currentOrientation = orientation;
//        }
//    } else if (orientation == UIDeviceOrientationFaceUp ||
//               orientation == UIDeviceOrientationPortrait ) {
//        // 正面面
//        if (_currentOrientation != UIDeviceOrientationFaceUp &&
//            _currentOrientation != UIDeviceOrientationPortrait ) {
//            change = YES;
//            _currentOrientation = orientation;
//        }
//    }
//
//    if ( NO == change ) {
//        return;
//    }
//
//    [self.switchControl ag_reloadData];
//
//    AGViewModel *vm = self.itemsData[self.switchControl.currentIndex];
//    AGTableViewManager *tvm = vm[kAGVMObject];
//    NSArray *visibleRows = tvm.view.indexPathsForVisibleRows;
//    if ( visibleRows.count > 0 ) {
//        NSIndexPath *scrollIndexPath = visibleRows.count > 1 ? visibleRows[1] : visibleRows[0];
//
//        [tvm.vmm ag_makeSectionsItemsSetNeedsCachedBindingViewSize];
//        [tvm.view reloadData];
//        [tvm.view scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
//    }
}

#pragma mark - ---------- Private Methods ----------
- (void) _pushBookDetailViewControllerWithData:(AGViewModel *)data
{
    // 跳转到下级控制器
    AGViewModel *context = [data mutableCopy];
    AGBookDetailViewController *vc = [AGBookDetailViewController newFromNibWithContext:context];
    [self.navigationController pushViewController:vc animated:YES];
    
    // 监听下级控制器的删除操作
    __weak typeof(self) weakSelf = self;
    [context ag_addObserver:self forKey:kAGVMDeleted usingBlock:^(AGViewModel * _Nonnull observedVM, NSString * _Nonnull key, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        
        __strong typeof(weakSelf) self = weakSelf;
        
        if ( [change[NSKeyValueChangeNewKey] boolValue] ) {
            AGViewModel *itemModel = self.itemsData[self.switchControl.currentIndex];
            AGTableViewManager *tvm = [itemModel ag_weaklyObjectForKey:kAGVMObject];
            [tvm deleteViewModels:@[data] withRowAnimation:UITableViewRowAnimationNone];
            
            // 更新缓存数据
            itemModel[kAGVMManager] = [tvm.vmm copy];
            
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
}

- (void) _loadTableViewManagerNetworkDataIfNeedsWithViewModel:(AGViewModel *)vm animation:(BOOL)animation
{
    BOOL hasCachedData = [self _resetTableViewManagerCachedDataIfNeedsWithViewModel:vm];
    if ( NO == hasCachedData ) {
        // 刷新数据
        if ( animation ) {
            AGTableViewManager *tvm = [vm ag_weaklyObjectForKey:kAGVMObject];
            [tvm startRefresh];
        }
        else {
            [self.bookAPICaller.listAPIManager loadData];
        }
    }
}

- (BOOL) _resetTableViewManagerCachedDataIfNeedsWithViewModel:(AGViewModel *)vm
{
    AGVMManager *vmm = vm[kAGVMManager];
    AGTableViewManager *tvm = [vm ag_weaklyObjectForKey:kAGVMObject];
    if ( vmm.fs.count > 0 ) {
        // 赋值数据
        [tvm handleVMManager:vmm inBlock:^(AGVMManager *originVmm) {
            [originVmm.fs ag_removeAllItems];
            [originVmm.fs ag_addItemsFromSection:vmm.fs];
        }];
        return YES;
    }
    else {
        // 清空数据
        [tvm.vmm.fs ag_removeAllItems];
        [tvm.view reloadData];
    }
    return NO;
}

#pragma mark add SubViews
- (void) _addSubviews
{
    [self.view addSubview:self.switchControl];
}

#pragma mark add SubViewCons
- (void) _addSubviewCons
{
    [self.switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
        
        if (@available(iOS 11.0, *)) {
            make.top.mas_equalTo(self.view.mas_safeAreaLayoutGuideTop);
            make.left.right.mas_equalTo(self.view);
            make.bottom.mas_equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            // Fallback on earlier versions
            make.edges.mas_equalTo(self.view);
        }
        
    }];
}

#pragma mark setup UI
- (void) _setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"图书列表";
    [SVProgressHUD setMaximumDismissTimeInterval:1.5];
//    _currentOrientation = [UIDevice currentDevice].orientation;
//
//    self.tableViewManager.view.backgroundColor = [UIColor blueColor];
//    self.tableViewManager1.view.backgroundColor = [UIColor greenColor];
}

#pragma mark add actions
- (void) _addActions
{
    // TODO
    __weak typeof(self) weakSelf = self;
    
    // tableView 的数据刷新 Block
    self.tableViewManager.headerRefreshingBlock = ^{
        __strong typeof(weakSelf) self = weakSelf;
        if ( self ) {
            [self.bookAPICaller.listAPIManager loadData];
        }
    };

    self.tableViewManager.footerRefreshingBlock = ^{
        __strong typeof(weakSelf) self = weakSelf;
        if ( self ) {
            [self.bookAPICaller.listAPIManager loadNextPage];
        }
    };

    self.tableViewManager1.headerRefreshingBlock = [self.tableViewManager.headerRefreshingBlock copy];
    self.tableViewManager1.footerRefreshingBlock = [self.tableViewManager.footerRefreshingBlock copy];

    self.tableViewManager2.headerRefreshingBlock = [self.tableViewManager.headerRefreshingBlock copy];
    self.tableViewManager2.footerRefreshingBlock = [self.tableViewManager.footerRefreshingBlock copy];
    
    // cell 点击
    self.tableViewManager.itemClickBlock = ^(UITableView *tableView, NSIndexPath *indexPath, AGViewModel *vm) {
        __strong typeof(weakSelf) self = weakSelf;
        if ( self ) {
            [self _pushBookDetailViewControllerWithData:vm];
        }
    };
    
    self.tableViewManager1.itemClickBlock = [self.tableViewManager.itemClickBlock copy];
    self.tableViewManager2.itemClickBlock = [self.tableViewManager.itemClickBlock copy];
    
    // 导航右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"归档并跳转" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    
//    // 监听屏幕旋转
//    if ( [UIDevice currentDevice].generatesDeviceOrientationNotifications == NO ) {
//        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
//    }
//    [[NSNotificationCenter defaultCenter]addObserver:self
//                                            selector:@selector(handleDeviceOrientationChange:)
//                                                name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark network request
- (void) _networkRequest
{
    /**
     
     # isbn_url = 'https://api.douban.com/v2/book/isbn/{}'
     # keyword_url = 'https://api.douban.com/v2/book/search?q={}&count={}&start={}'
     
     */
}

- (NSURL *) _archiveURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    NSString *archivePath = [docsDir stringByAppendingPathComponent:kAGDiskBookListFileName];
    return [NSURL fileURLWithPath:archivePath];
}

#pragma mark - ----------- Getter Methods ----------
- (AGTableViewManager *)tableViewManager
{
    if (_tableViewManager == nil) {
        NSArray *cellClasses = @[[AGBookListCell class],];
        _tableViewManager = [[AGTableViewManager alloc] initWithCellClasses:cellClasses originVMManager:nil];
        _tableViewManager.vmDelegate = self;
    }
    return _tableViewManager;
}

- (AGTableViewManager *)tableViewManager1
{
    if (_tableViewManager1 == nil) {
        NSArray *cellClasses = @[[AGBookListCell class],];
        _tableViewManager1 = [[AGTableViewManager alloc] initWithCellClasses:cellClasses originVMManager:nil];
        _tableViewManager1.vmDelegate = self;
    }
    return _tableViewManager1;
}

- (AGTableViewManager *)tableViewManager2
{
    if (_tableViewManager2 == nil) {
        NSArray *cellClasses = @[[AGBookListCell class],];
        _tableViewManager2 = [[AGTableViewManager alloc] initWithCellClasses:cellClasses originVMManager:nil];
        _tableViewManager2.vmDelegate = self;
    }
    return _tableViewManager2;
}

- (AGBookAPICaller *)bookAPICaller
{
    if (_bookAPICaller == nil) {
        _bookAPICaller = [AGBookAPICaller newWithAPIDelegate:self];
    }
    return _bookAPICaller;
}

- (AGVMSection *)itemsData
{
    if (_itemsData == nil) {
        _itemsData = ag_newAGVMSection(12);
        
        NSArray *listViewManagers = @[self.tableViewManager, self.tableViewManager1, self.tableViewManager2];
//        NSArray *titles = @[@"莎士比亚", @"傅雷", @"春上春树", @"鲁迅", @"德鲁克", @"矛盾", @"巴金", @"陈春花", @"富兰克林", @"洛克菲勒"];
        NSArray *titles = @[@"卫衣", @"皮带", @"帽子"];
        
        [_itemsData ag_packageItemMergeData:^(AGViewModel * _Nonnull package) {
            package[kAGVMViewClass] = AGSwitchControlItem.class;
            package[kAGVMTitleColor] = [UIColor blackColor];
            package[kAGVMTitleFont] = [UIFont systemFontOfSize:14.];
        }];
        
        for (NSInteger i = 0; i<titles.count; i++) {
            [_itemsData ag_packageItemData:^(AGViewModel * _Nonnull package) {
                
                package[kAGVMTitleText] = titles[i];
                
                id viewManager = listViewManagers[i % listViewManagers.count];
                [package ag_setWeaklyObject:viewManager forKey:kAGVMObject];
            }];
        }
        
        // 缓存 Size
        AGSwitchControlItem *item = [AGSwitchControlItem new];
        [_itemsData ag_makeItemsPerformSelector:@selector(ag_cachedSizeByBindingView:) withObject:item];
        
    }
    return _itemsData;
}

- (AGSwitchControl *)switchControl
{
    if (_switchControl == nil) {
        _switchControl = [[AGSwitchControl alloc] initWithSettableBlock:^(AGSwitchControl<AGSwitchControlSettable> *switchControl) {
            
            switchControl.dataSource = self;
            switchControl.delegate = self;
            switchControl.titleSwitchViewH = 54.;
            switchControl.underlineBottomMargin = 4.;
            switchControl.currentIndex = 1;
            switchControl.titleAnimation = YES;
            
        }];
        
        [_switchControl ag_setupHeaderViewUsingBlock:^CGSize(UIView *targetView) {
            
            UILabel *label = [UILabel new];
            label.textAlignment = NSTextAlignmentCenter;
            label.backgroundColor = [UIColor orangeColor];
            [targetView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(targetView);
            }];
            
            label.text = @"刷不出数据，IP可能被限";
            
            return CGSizeMake(200., 44.);
        }];
        
        [_switchControl ag_setupFooterViewUsingBlock:^CGSize(UIView *targetView) {
            
            targetView.backgroundColor = [UIColor darkGrayColor];
            return CGSizeMake(200., 1. / [UIScreen mainScreen].scale);
        }];
        
        [_switchControl ag_setupLeftViewUsingBlock:^CGSize(UIView *targetView) {
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor greenColor];
            [targetView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(targetView);
            }];
            
            return CGSizeMake(16., 54.);
        }];
        
        [_switchControl ag_setupRightViewUsingBlock:^CGSize(UIView *targetView) {
            UIView *view = [UIView new];
            view.backgroundColor = [UIColor purpleColor];
            [targetView addSubview:view];
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(targetView);
            }];
            
            return CGSizeMake(36., 54.);
        }];
        
        [_switchControl ag_setupUnderlineViewUsingBlock:^CGSize(UIView *targetView) {
            targetView.backgroundColor = [UIColor redColor];
            targetView.layer.cornerRadius = 2.;
            targetView.layer.masksToBounds = YES;
            return CGSizeMake(18., 5.);
        }];
        
    }
    return _switchControl;
}

@end
