//
//  AGDocumentViewController.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/12/1.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGDocumentViewController.h"
#import <Masonry.h>
#import "AGTableViewManager.h"
#import "GZPSItemDetailCell.h"
#import "GZPSItemHeaderView.h"
#import "AGDocumentVMGenerator.h"
#import "AGGlobalVMKeys.h"

@interface AGDocumentViewController ()
<AGVMDelegate>

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
#pragma mark - AGViewControllerProtocol
- (UIViewController *)initWithViewModel:(AGViewModel *)vm
{
    self = [super init];
    if ( self ) {
        
        [self setContext:vm];
        self.title = vm[kAGVMTargetVCTitle] ?: @"文档";
        
    }
    return self;
}

+ (instancetype)newWithContext:(AGViewModel *)vm
{
	return [[self alloc] initWithViewModel:vm];
}

#pragma mark - AGVMDelegate
- (void)ag_viewModel:(AGViewModel *)vm callDelegateToDoForAction:(SEL)action
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
			[vm ag_refreshUIByUpdateModelInBlock:^(NSMutableDictionary * _Nonnull bm) {
				bm[kAGVMItemArrowIsOpen] = @(! isOpen);
			}];
            
        }
    }
}

#pragma mark - ---------- Public Methods ----------


#pragma mark - ---------- Event Methods ----------


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
    
    
}

#pragma mark add actions
- (void) _addActions
{
    // TODO
//    __weak typeof(self) weakSelf = self;
//    self.tableViewManager.headerRefreshingBlock = ^{
//        [weakSelf.<#APIManager#> loadData];
//    };
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
