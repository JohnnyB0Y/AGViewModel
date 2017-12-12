//
//  ViewController.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/4/23.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "ViewController.h"
#import "AGTableViewManager.h"
#import "AGVMKit.h"
#import "AGHomeVMGenerator.h"
#import <Masonry/Masonry.h>

@interface ViewController ()

/** vm */
@property (nonatomic, strong) AGViewModel *vm;

/** textField */
@property (nonatomic, strong) UITextField *textField;

/** table view manager */
@property (nonatomic, strong) AGTableViewManager *tableViewManager;

/** home vmg */
@property (nonatomic, strong) AGHomeVMGenerator *homeVMG;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    [self _addSubviews];
    [self _addSubviewCons];
    [self _setupUI];
    [self _addActions];
    [self _networkRequest];
    
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

#pragma mark - ---------- Private Methods ----------
- (void) _addSubviews
{
    [self.view addSubview:self.textField];
    [self.view addSubview:self.tableViewManager.view];
}

- (void) _addSubviewCons
{
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(300., 30.));
        make.top.mas_equalTo(self.view).mas_offset(96.);
        make.centerX.mas_equalTo(self.view);
    }];
    
    [self.tableViewManager.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.textField.mas_bottom).mas_offset(12.);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
}

- (void) _setupUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void) _addActions
{
    // add Target
    [self.textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    // VM Notify
    __weak typeof(self) weakSelf = self;
    [self.vm ag_addObserver:self forKeys:@[kAGVMTargetVCTitle] block:^(AGViewModel * _Nonnull vm, NSString * _Nonnull key, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        NSString *title = change[NSKeyValueChangeNewKey];
        NSLog(@"模型修改标题 : %@ - %@", title, key);
        
        [strongSelf setTitle:title];
        
    }];
    
    self.tableViewManager.itemClickBlock = ^(UITableView *tableView, NSIndexPath *indexPath, AGViewModel *vm) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        AGVMTargetVCBlock block = vm[kAGVMTargetVCBlock];
        block ? block(strongSelf, vm) : nil;
        
    };
    
}

- (void) _networkRequest
{
    // 模型修改
    self.vm[kAGVMTargetVCTitle] = @"龙的传人";
    
    AGVMManager *vmm = self.homeVMG.homeListVMM;
    [self.tableViewManager handleVMManager:nil inBlock:^(AGVMManager *originVmm) {
        [originVmm.fs ag_removeAllItems];
        [originVmm.fs ag_addItemsFromSection:vmm.fs];
    }];
    
}

#pragma mark - ---------- Event Methods ----------
- (void) textFieldEditingChanged:(UITextField *)tf
{
    NSLog(@"用户输入标题 : %@", tf.text);
    self.vm[kAGVMTargetVCTitle] = tf.text;
}

#pragma mark - ----------- Getter Methods ----------
- (AGViewModel *)vm
{
    if (_vm == nil) {
        NSDictionary *dict = @{kAGVMViewW : @44};
        _vm = ag_viewModel(dict);
    }
    return _vm;
}

- (UITextField *)textField
{
    if (_textField == nil) {
        _textField = [[UITextField alloc] initWithFrame:CGRectZero];
		_textField.font = [UIFont systemFontOfSize:12.];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = @"修改标题";
    }
    return _textField;
}

- (AGTableViewManager *)tableViewManager
{
    if (_tableViewManager == nil) {
        NSArray *cellClasses = @[AGTextCell.class];
        _tableViewManager = [[AGTableViewManager alloc] initWithCellClasses:cellClasses originVMManager:nil];
        _tableViewManager.view.contentInset = UIEdgeInsetsMake(24., 0., 24., 0.);
        //_tableViewManager.view.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableViewManager;
}

- (AGHomeVMGenerator *)homeVMG
{
    if (_homeVMG == nil) {
        _homeVMG = [AGHomeVMGenerator new];
    }
    return _homeVMG;
}

@end
