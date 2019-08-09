//
//  AGDiskBookListViewController.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/12/27.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGDiskBookListViewController.h"
#import "AGVMKit.h"
#import "AGTableViewManager.h"
#import <SVProgressHUD.h>
#import <Masonry.h>
#import "AGBookListCell.h"

@interface AGDiskBookListViewController ()

/** ` */
@property (nonatomic, strong) AGTableViewManager *tableViewManager;

@end

@implementation AGDiskBookListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addSubviews];
    [self _addSubviewCons];
    [self _setupUI];
    
    // 取数据
    NSData *data = [NSData dataWithContentsOfURL:[self _archiveURL]];
    AGVMManager *vmm = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    // 刷新数据
    [self.tableViewManager handleVMManager:vmm inBlock:^(AGVMManager *originVmm) {
        [originVmm.fs ag_addItemsFromSection:vmm.fs];
    }];
    
    // json
    [vmm ag_addAllSerializableObjectUseDefaultKeys];
    NSString *json = [vmm ag_toJSONString];
    NSError *error;
    NSDictionary *dict = ag_newNSDictionaryWithJSONString(json, &error);
    NSLog(@"dict: %@", dict);
    NSLog(@"error: %@", error);
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
    self.title = @"从磁盘上读取的图书列表";
    
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
    }
    return _tableViewManager;
}

@end
