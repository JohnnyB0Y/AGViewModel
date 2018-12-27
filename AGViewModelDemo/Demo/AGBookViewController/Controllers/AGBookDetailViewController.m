//
//  AGBookDetailViewController.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "AGBookDetailViewController.h"
#import <SVProgressHUD.h>
#import <CTNetworking.h>
#import <UIImageView+AFNetworking.h>

#import "AGBookDetailAPIManager.h"
#import "AGBookHandleReformer.h"
#import "AGBookAPIKeys.h"

@interface AGBookDetailViewController ()
<CTAPIManagerParamSource, CTAPIManagerCallBackDelegate>

/** 图书详情 */
@property (nonatomic, strong) AGBookDetailAPIManager *bookDetailAPIManager;
/**  */
@property (nonatomic, strong) AGBookHandleReformer *bookHandleReformer;

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end

@implementation AGBookDetailViewController {
    AGViewModel *_viewModel;
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
    
    
    // 移除通知监听
    
}

#pragma mark - ---------- Custom Delegate ----------
#pragma mark - CTAPIManagerParamSourceDelegate
- (NSDictionary *) paramsForApi:(CTAPIBaseManager *)manager
{
    NSMutableDictionary *paramM = ag_newNSMutableDictionary(5);
    
//    if ( manager == <#loadingAPIManager#> ) {
//        // ...
//        paramM[@"<#param#>"] = <#param#>;
//    }
//    else if ( manager == <#loadingAPIManager#> ) {
//        // ...
//
//    }
    
    return [paramM copy];
}

#pragma mark - CTAPIManagerApiCallBackDelegate
- (void) managerCallAPIDidSuccess:(CTAPIBaseManager *)manager
{
    [SVProgressHUD dismiss];
    
    if ( manager == _bookDetailAPIManager ) {
        // ...
        AGViewModel *vm = [manager fetchDataWithReformer:self.bookHandleReformer];
        
        NSString *title = [vm ag_safeStringForKey:ak_AGBook_title];
        NSURL *imageURL = [vm ag_safeURLForKey:ak_AGBook_image];
        NSString *summary = [vm ag_safeStringForKey:ak_AGBook_summary];
        
        [self.titleLabel setText:title];
        [self.coverImageView setImageWithURL:imageURL];
        [self.summaryLabel setText:summary];
        
    }
    
}

- (void) managerCallAPIDidFailed:(CTAPIBaseManager *)manager
{
    [SVProgressHUD dismiss];
    
//    if ( manager.verifyError ) {
//        [SVProgressHUD showErrorWithStatus:manager.verifyError.msg];
//    }
    
}

#pragma mark - AGViewControllerProtocol
+ (instancetype)newWithViewModel:(AGViewModel *)vm
{
    AGBookDetailViewController *vc = [[self alloc] initWithNibName:@"AGBookDetailViewController" bundle:nil];
    vc->_viewModel = vm;
    return vc;
}

#pragma mark - ---------- Public Methods ----------


#pragma mark - ---------- Event Methods ----------


#pragma mark - ---------- Private Methods ----------
#pragma mark add SubViews
- (void) _addSubviews
{
    
}

#pragma mark add SubViewCons
- (void) _addSubviewCons
{
    
}

#pragma mark setup UI
- (void) _setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [_viewModel ag_safeStringForKey:ak_AGBook_title];
}

#pragma mark add actions
- (void) _addActions
{
    // TODO
    
}

#pragma mark network request
- (void) _networkRequest
{
    self.bookDetailAPIManager.isbn = _viewModel[ak_AGBook_isbn];
    [SVProgressHUD show];
    [self.bookDetailAPIManager loadData];
}

#pragma mark - ----------- Getter Methods ----------
- (AGBookDetailAPIManager *)bookDetailAPIManager
{
    if (_bookDetailAPIManager == nil) {
        _bookDetailAPIManager = [AGBookDetailAPIManager new];
        _bookDetailAPIManager.delegate = self;
        _bookDetailAPIManager.paramSource = self;
    }
    return _bookDetailAPIManager;
}

- (AGBookHandleReformer *)bookHandleReformer
{
    if (_bookHandleReformer == nil) {
        _bookHandleReformer = [AGBookHandleReformer new];
    }
    return _bookHandleReformer;
}

@end
