//
//  AGHomeVMGenerator.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/11/12.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGHomeVMGenerator.h"

#import "AGBoxCollectionViewController.h"

@implementation AGHomeVMGenerator

#pragma mark - ----------- Getter Methods ----------
- (AGVMManager *)homeListVMM
{
    if (_homeListVMM == nil) {
        _homeListVMM = ag_VMManager(1);
        
        [_homeListVMM ag_packageSection:^(AGVMSection * _Nonnull vms) {
            
            [vms ag_packageItemCommonData:^(NSMutableDictionary * _Nonnull package) {
                package[kAGVMViewClass] = AGTextCell.class;
                package[kAGVMViewH] = @44.;
            }];
            
            [vms ag_packageItemData:^(NSMutableDictionary * _Nonnull package) {
                
                package[kAGVMItemTitle] = @"case 1";
                
                AGVMTargetVCBlock block = ^(UIViewController *vc, AGViewModel *vm) {
                    // 进入 box 控制器
                    AGBoxCollectionViewController *targetVC
                    = [[AGBoxCollectionViewController alloc] initWithViewModel:vm];
                    
                    [vc.navigationController pushViewController:targetVC animated:YES];
                };
                package[kAGVMTargetVCBlock] = block;
            }];
            
        } capacity:5];
        
    }
    return _homeListVMM;
}

@end
