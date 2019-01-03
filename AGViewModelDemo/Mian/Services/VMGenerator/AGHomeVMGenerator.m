//
//  AGHomeVMGenerator.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/11/12.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGHomeVMGenerator.h"

#import "AGBoxCollectionViewController.h"
#import "AGDocumentViewController.h"
#import "AGBookListViewController.h"
#import "AGMainCell.h"
#import "AGMainHeaderFooterView.h"

@implementation AGHomeVMGenerator

#pragma mark - ----------- Getter Methods ----------
- (AGVMManager *)homeListVMM
{
    if (_homeListVMM == nil) {
        _homeListVMM = ag_newAGVMManager(1);
        
        [_homeListVMM ag_packageSection:^(AGVMSection * _Nonnull vms) {
            // ...
            AGMainHeaderFooterView *headerFooterView = [AGMainHeaderFooterView new];
            [[vms ag_packageHeaderData:^(NSMutableDictionary * _Nonnull package) {
                package[kAGVMViewClass] = AGMainHeaderFooterView.class;
                package[kAGVMTitleText] = @"我是 header view 标题";
            }] ag_cachedSizeByBindingView:headerFooterView]; // 提前计算好高度
            
            // ...
            [vms ag_packageItemMergeData:^(NSMutableDictionary * _Nonnull package) {
                package[kAGVMViewClass] = AGMainCell.class;
            }];
            
            [vms ag_packageItemData:^(NSMutableDictionary * _Nonnull package) {
                
                package[kAGVMTitleText] = @"case 1";
                package[kAGVMTargetVCBlock] = ag_viewModelCopyTargetVCBlock(^(UIViewController * _Nullable targetVC, AGViewModel * _Nullable vm) {
                    // 进入 box 控制器
                    AGBoxCollectionViewController *boxVC
                    = [AGBoxCollectionViewController newWithContext:vm];
                    [targetVC.navigationController pushViewController:boxVC animated:YES];
                });
            }];
            
            [vms ag_packageItemData:^(NSMutableDictionary * _Nonnull package) {
                
                package[kAGVMTitleText] = @"古诗";
                package[kAGVMTargetVCBlock] = ag_viewModelCopyTargetVCBlock(^(UIViewController * _Nullable targetVC, AGViewModel * _Nullable vm) {
                    // 进入 document 控制器
                    AGDocumentViewController *documentVC
                    = [AGDocumentViewController newWithContext:vm];
                    [targetVC.navigationController pushViewController:documentVC animated:YES];
                });
            }];
            
            [vms ag_packageItemData:^(NSMutableDictionary * _Nonnull package) {
                
                package[kAGVMTitleText] = @"豆瓣图书";
                package[kAGVMTargetVCBlock] = ag_viewModelCopyTargetVCBlock(^(UIViewController * _Nullable targetVC, AGViewModel * _Nullable vm) {
                    // 豆瓣图书
                    AGBookListViewController *bookVC = [AGBookListViewController newWithContext:nil];
                    [targetVC.navigationController pushViewController:bookVC animated:YES];
                });
            }];
            
            // ...
            [vms ag_packageFooterData:^(NSMutableDictionary * _Nonnull package) {
                package[kAGVMViewClass] = AGMainHeaderFooterView.class;
                package[kAGVMTitleText] = @"我是 footer view 标题";
                package[kAGVMViewH] = @34.;
            }];
            
        } capacity:5];
        
    }
    
    return _homeListVMM;
}

@end
