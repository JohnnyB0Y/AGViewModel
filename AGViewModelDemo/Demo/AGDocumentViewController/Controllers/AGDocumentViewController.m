//
//  AGDocumentViewController.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/12/1.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGDocumentViewController.h"
#import "AGDiskDocumentViewController.h"
#import <Masonry.h>
#import "AGTableViewManager.h"
#import "GZPSItemDetailCell.h"
#import "GZPSItemHeaderView.h"
#import "AGDocumentVMGenerator.h"
#import "AGGlobalVMKeys.h"

@interface AGDocumentViewController ()
<AGVMDelegate, AGVMNotificationDelegate>

/** ` */
@property (nonatomic, strong) AGTableViewManager *tableViewManager;
@property (nonatomic, strong) AGDocumentVMGenerator *documentVMG;
@end

@implementation AGDocumentViewController

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
    // 取消挂起的网络请求
    
    
    // 移除通知监听
    
}

#pragma mark - ---------- Custom Delegate ----------
#pragma mark - AGVMDelegate
- (void)ag_viewModel:(AGViewModel *)vm handleAction:(SEL)action
{
    UITableView *tableView = self.tableViewManager.view;
    if ([vm.bindingView isKindOfClass:[GZPSItemHeaderView class]] ) {
        GZPSItemHeaderView *cell = (GZPSItemHeaderView *)vm.bindingView;
        if ( sel_isEqual(cell.cellTap, action) ) {
            // ...
            BOOL isOpen = [vm[kAGVMItemArrowIsOpen] boolValue];
            AGVMSection *vms = vm[kAGVMSection];
            
            AGVMSection *currentVMS = self.tableViewManager.vmm[vm.indexPath.section];
            
            NSMutableArray *indexPaths = [NSMutableArray arrayWithCapacity:vms.count];
            for (NSInteger i = 0; i<vms.count; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:vm.indexPath.section];
                [indexPaths addObject:indexPath];
            }
            
            if ( isOpen ) {
                
                [currentVMS ag_removeAllItems];
                [tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            }
            else {
                
                [currentVMS ag_insertItemsFromSection:vms atIndex:0];
                [tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
            }
            
            // 转换箭头
            [vm ag_refreshUIByUpdateModelUsingBlock:^(AGViewModel *viewModel) {
                viewModel[kAGVMItemArrowIsOpen] = @(! isOpen);
            }];
            
        }
    }
}

- (void)ag_viewModel:(AGViewModel *)vm receiveNotification:(NSNotification *)notification
{
    NSLog(@"%@", notification);
}

#pragma mark - ---------- Public Methods ----------


#pragma mark - ---------- Event Methods ----------
- (void) handleDeviceOrientationChange:(NSNotification *)notification
{
    [self.tableViewManager.vmm ag_makeSectionsItemsSetNeedsCachedBindingViewSize];
    [self.tableViewManager.view reloadData];
}

- (void) rightBarButtonItemClick:(UIBarButtonItem *)item
{
    // 保存图书列表
    AGVMManager *vmm = self.documentVMG.documentVMM;
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:vmm];
    [data writeToURL:[self _archiveURL] atomically:YES];
    
    // 跳转到磁盘图书列表视图控制器
    AGDiskDocumentViewController *vc = [[AGDiskDocumentViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
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
        make.left.bottom.right.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).mas_offset(88.);
    }];
}

#pragma mark setup UI
- (void) _setupUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.title = @"唐诗";
}

#pragma mark add actions
- (void) _addActions
{
    // 监听屏幕旋转
    if ( [UIDevice currentDevice].generatesDeviceOrientationNotifications == NO ) {
        [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    }
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(handleDeviceOrientationChange:)
                                                name:UIDeviceOrientationDidChangeNotification object:nil];
    
    // 导航右上角按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"归档并跳转" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
}

#pragma mark network request
- (void) _networkRequest
{
    AGVMManager *vmm = self.documentVMG.documentVMM;
    [self.tableViewManager handleVMManager:vmm inBlock:^(AGVMManager *originVmm) {
        [originVmm ag_removeAllSections];
        [originVmm ag_addSectionsFromManager:vmm];
    }];
}

- (NSURL *) _archiveURL {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docsDir = [paths objectAtIndex:0];
    NSString *archivePath = [docsDir stringByAppendingPathComponent:kAGDiskDocumentListFileName];
    return [NSURL fileURLWithPath:archivePath];
}

#pragma mark - ----------- Getter Methods ----------
- (AGTableViewManager *)tableViewManager
{
    if (_tableViewManager == nil) {
        NSArray *cellClasses = @[[GZPSItemDetailCell class],];
        _tableViewManager = [[AGTableViewManager alloc] initWithCellClasses:cellClasses originVMManager:nil];
        [_tableViewManager registerHeaderFooterViewClasses:@[[GZPSItemHeaderView class]]];
        _tableViewManager.vmDelegate = self;
    }
    return _tableViewManager;
}

- (AGDocumentVMGenerator *)documentVMG
{
    if (_documentVMG == nil) {
        _documentVMG = [AGDocumentVMGenerator new];
    }
    return _documentVMG;
}

@end
