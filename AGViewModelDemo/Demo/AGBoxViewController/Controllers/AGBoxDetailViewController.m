//
//  AGBoxDetailViewController.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/8/29.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGBoxDetailViewController.h"
#import "AGBoxVMKeys.h"

@interface AGBoxDetailViewController ()

@end

@implementation AGBoxDetailViewController {
    AGViewModel *_viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"变" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIViewController *)initWithViewModel:(AGViewModel *)vm
{
    self = [super init];
    if ( self ) {
        self->_viewModel = vm;
        self.title = @"盒子";
        self.view.backgroundColor = vm[kAGVMBoxColor];
    }
    return self;
}

+ (instancetype)newWithViewModel:(AGViewModel *)vm
{
	return [[self alloc] initWithViewModel:vm];
}

#pragma mark - ---------- Event Methods ----------
- (void) rightBarButtonItemClick:(UIBarButtonItem *)item
{
    // 通知修改，上一级界面
    [[NSNotificationCenter defaultCenter] postNotificationName:kChangeViewModelNoti object:nil userInfo:_viewModel.bindingModel];
}

@end

NSString * const kChangeViewModelNoti = @"kChangeViewModelNoti";
