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

@implementation AGHomeVMGenerator

#pragma mark - ----------- Getter Methods ----------
- (AGVMManager *)homeListVMM
{
    if (_homeListVMM == nil) {
        _homeListVMM = ag_VMManager(1);
        
        [_homeListVMM ag_packageSection:^(AGVMSection * _Nonnull vms) {
            
            [vms ag_packageItemMergeData:^(NSMutableDictionary * _Nonnull package) {
                package[kAGVMViewClass] = AGTextCell.class;
                package[kAGVMViewH] = @44.;
            }];
            
            [vms ag_packageItemData:^(NSMutableDictionary * _Nonnull package) {
                
                package[kAGVMItemTitle] = @"case 1";
                package[kAGVMTargetVCBlock] = [self _targetVCBlockWithBlock:^(UIViewController * _Nullable vc, AGViewModel * _Nullable vm) {
                    // 进入 box 控制器
                    AGBoxCollectionViewController *targetVC
                    = [AGBoxCollectionViewController newWithViewModel:vm];
                    
                    [vc.navigationController pushViewController:targetVC animated:YES];
                }];
            }];
            
            [vms ag_packageItemData:^(NSMutableDictionary * _Nonnull package) {
                
                package[kAGVMItemTitle] = @"case 2";
                package[kAGVMTargetVCBlock] = [self _targetVCBlockWithBlock:^(UIViewController * _Nullable vc, AGViewModel * _Nullable vm) {
                    // 进入 document 控制器
                    AGDocumentViewController *targetVC
                    = [AGDocumentViewController newWithViewModel:vm];
                    
                    [vc.navigationController pushViewController:targetVC animated:YES];
                }];
            }];
            
        } capacity:5];
        
    }
    return _homeListVMM;
}

- (AGVMTargetVCBlock) _targetVCBlockWithBlock:(AGVMTargetVCBlock)block
{
    return block;
}

@end
