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

#import "AGBookListCell.h"
#import "AGBookListAPIManager.h"
#import "AGBookListAPIReformer.h"
#import "AGBookAPIKeys.h"


@interface AGBookListViewController ()
<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate,
AGVMDelegate>

/** ` */
@property (nonatomic, strong) AGTableViewManager *tableViewManager;

/** 图书列表 */
@property (nonatomic, strong) AGBookListAPIManager *bookListAPIManager;

/** 图书列表数据过滤器 */
@property (nonatomic, strong) AGBookListAPIReformer *bookListAPIReformer;

@end

@implementation AGBookListViewController

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
    [_bookListAPIManager cancelAllRequests];
    
    // 移除通知监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (AGViewControllerFromType)typeOfCreateInstance
{
    return AGViewControllerFromCode;
}

#pragma mark - ---------- Custom Delegate ----------
#pragma mark - CTAPIManagerParamSourceDelegate
- (NSDictionary *) paramsForApi:(CTAPIBaseManager *)manager
{
    NSMutableDictionary *paramM = ag_newNSMutableDictionary(5);
    
    if ( manager == _bookListAPIManager ) {
        // ... q={}&count={}&start={}
        paramM[@"q"] = @"莎士比亚";
        paramM[@"count"] = @"16";
    }
    
    return [paramM copy];
}

#pragma mark - CTAPIManagerApiCallBackDelegate
- (void) managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    [SVProgressHUD dismiss];
    
    if ( manager == _bookListAPIManager ) {
        // ...
        AGVMManager *vmm = [manager fetchDataWithReformer:self.bookListAPIReformer];
        [self.tableViewManager handleVMManager:vmm inBlock:^(AGVMManager *originVmm) {
            if ( self.bookListAPIManager.isFirstPage ) {
                [originVmm.fs ag_removeAllItems];
            }
            [originVmm.fs ag_addItemsFromSection:vmm.fs];
        }];
    }
}

- (void) managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    [SVProgressHUD dismiss];
    
    // 参数错误、返回数据错误
    if ( manager.verifyError ) {
        [SVProgressHUD showErrorWithStatus:manager.verifyError.msg];
    }
    
    // 停止刷新
    [self.tableViewManager stopRefresh];
}

#pragma mark - AGVMDelegate
- (void)ag_viewModel:(AGViewModel *)vm callDelegateToDoForAction:(SEL)action
{
//    if ([vm.bindingView isKindOfClass:[<#Class#> class]] ) {
//        <#Class#> *cell = (<#Class#> *)vm.bindingView;
//        if ( sel_isEqual(cell.<#SEL#>, action) ) {
//            // ...
//            
//        }
//    }
}

#pragma mark - ---------- Public Methods ----------


#pragma mark - ---------- Event Methods ----------
- (void) rightBarButtonItemClick:(UIBarButtonItem *)item
{
    // 保存图书列表
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.tableViewManager.vmm];
    [data writeToURL:[self _archiveURL] atomically:YES];
    
    // 跳转到磁盘图书列表视图控制器
    AGDiskBookListViewController *vc = [[AGDiskBookListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void) handleDeviceOrientationChange:(NSNotification *)notification
{
    NSArray *visibleRows = self.tableViewManager.view.indexPathsForVisibleRows;
    NSIndexPath *scrollIndexPath = visibleRows.count > 1 ? visibleRows[1] : visibleRows[0];
    
    [self.tableViewManager.vmm ag_makeSectionsItemsSetNeedsCachedBindingViewSize];
    [self.tableViewManager.view reloadData];
    [self.tableViewManager.view scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

#pragma mark - ---------- Private Methods ----------
#pragma mark add SubViews
- (void) _addSubviews
{
    [self.view addSubview:self.tableViewManager.view];
}

#pragma mark add SubViewCons
- (void) _addSubviewCons
{
    [self.tableViewManager.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
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
    
}

#pragma mark add actions
- (void) _addActions
{
    // TODO
    __weak typeof(self) weakSelf = self;
    
    self.tableViewManager.headerRefreshingBlock = ^{
        __strong typeof(weakSelf) self = weakSelf;
        if ( self ) {
            [self.bookListAPIManager loadData];
        }
    };
    
    self.tableViewManager.footerRefreshingBlock = ^{
        __strong typeof(weakSelf) self = weakSelf;
        if ( self ) {
            [self.bookListAPIManager loadNextPage];
        }
    };
    
    // cell 点击
    self.tableViewManager.itemClickBlock = ^(UITableView *tableView, NSIndexPath *indexPath, AGViewModel *vm) {
        
        __strong typeof(weakSelf) self = weakSelf;
        if ( self ) {
            AGViewModel *context = ag_newAGViewModel(nil);
            [context ag_mergeModelFromViewModel:vm byKeys:@[ak_AGBook_title, ak_AGBook_isbn]];
            
            // 监听删除
            [context ag_addObserver:self forKey:kAGVMDeleted usingBlock:^(AGViewModel * _Nonnull observedVM, NSString * _Nonnull key, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
                
                BOOL del = [change[NSKeyValueChangeNewKey] boolValue];
                
                if ( del ) {
                    
                    [self.tableViewManager deleteViewModels:@[vm] withRowAnimation:UITableViewRowAnimationNone];
                    [self.navigationController popViewControllerAnimated:YES];
                }
                
            }];
            
            AGBookDetailViewController *vc = [AGBookDetailViewController newWithContext:context];
            [self.navigationController pushViewController:vc animated:YES];
        }
        
    };
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"归档并跳转" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    
    // 监听屏幕旋转
    if ( [UIDevice currentDevice].generatesDeviceOrientationNotifications == NO ) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleDeviceOrientationChange:)
                                                name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark network request
- (void) _networkRequest
{
    [self.tableViewManager startRefresh];
    
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
        AGVMManager *vmm = _tableViewManager.vmm;
        // 设置归档 key
        [vmm ag_addAllArchivedObjectUseDefaultKeys];
        [vmm.fs ag_addAllArchivedObjectUseDefaultKeys];
//        [vms ag_addArchivedItemArrMKey:@"00000000000000"];
//        [vms ag_addArchivedHeaderVMKey:@"222header22222"];
//        [vms ag_addArchivedFooterVMKey:@"222footer22222"];
//        [vms ag_addArchivedCommonVMKey:@"222common22222"];
//
//        [vms ag_removeArchivedItemArrMKey];
        
        _tableViewManager.vmDelegate = self;
    }
    return _tableViewManager;
}

- (AGBookListAPIManager *)bookListAPIManager
{
    if (_bookListAPIManager == nil) {
        _bookListAPIManager = [AGBookListAPIManager new];
        _bookListAPIManager.delegate = self;
        _bookListAPIManager.paramSource = self;
    }
    return _bookListAPIManager;
}

- (AGBookListAPIReformer *)bookListAPIReformer
{
    if (_bookListAPIReformer == nil) {
        _bookListAPIReformer = [AGBookListAPIReformer new];
    }
    return _bookListAPIReformer;
}

@end
