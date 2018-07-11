//
//  AGBoxVMGenerator.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/8/20.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  box viewModel 生成器

#import "AGBoxVMGenerator.h"


@implementation AGBoxVMGenerator

- (AGVMManager *)boxVMManager
{
    if (_boxVMManager == nil) {
        _boxVMManager = ag_VMManager(3);
        
        // 公共数据
        [_boxVMManager ag_packageCommonData:^(NSMutableDictionary * _Nonnull package) {
            package[kAGVMBoxTitle] = @"boxTitle";
        }];
        
        NSArray *classArr = @[[AGBoxACell class],
                              [AGBoxBCell class],
                              [AGBoxCCell class],
                              [AGBoxCCell class],
                              [AGBoxBCell class],
                              [AGBoxACell class]];
        
        NSArray *colorArr = @[[UIColor yellowColor],
                              [UIColor orangeColor],
                              [UIColor blackColor],
                              [UIColor blueColor],
                              [UIColor purpleColor],
                              [UIColor greenColor],
                              [UIColor darkGrayColor]];
        
        
        // 第一组
        [_boxVMManager ag_packageSection:^(AGVMSection *vms) {
            
            // 公共数据
            [vms ag_packageCommonData:^(NSMutableDictionary * _Nonnull package) {
                package[kAGVMBoxTitle] = @"SSS";
            }];
            
            // 共享数据模型
            [vms ag_packageItemMergeData:^(NSMutableDictionary *package) {
                // 要实例化的类
                package[kAGVMViewClass] = [self _randClassAtArr:classArr];
            }];
            
            // 第一个 item
            [vms ag_packageItemData:^(NSMutableDictionary *package) {
                package[kAGVMBoxColor] = [self _randColorAtArr:colorArr];
                package[kAGVMBoxTitle] = @"我是第一个item！";
            }];
            
            for (NSInteger i = 0; i<9; i++) {
                [vms ag_packageItemData:^(NSMutableDictionary *package) {
                    package[kAGVMBoxColor] = [self _randColorAtArr:colorArr];
                    package[kAGVMBoxTitle] = @"我们是谁？";
                    package[kAGVMViewClass] = [self _randClassAtArr:classArr];
                }];
            }
            
        } capacity:10];
        
        // 第二组
        [_boxVMManager ag_packageSection:^(AGVMSection *vms) {
            
            // 第一个 item
            [vms ag_packageItemData:^(NSMutableDictionary *package) {
                package[kAGVMBoxColor] = [UIColor blackColor];
                package[kAGVMBoxTitle] = @"我是第一个item！";
                // 单独设置要实例化的类
                package[kAGVMViewClass] = [self _randClassAtArr:classArr];
            }];
            
            // 第二个 item
            [vms ag_packageItemData:^(NSMutableDictionary *package) {
                package[kAGVMBoxColor] = [UIColor greenColor];
                package[kAGVMBoxTitle] = @"我是第二个item！";
                // 单独设置要实例化的类
                package[kAGVMViewClass] = [self _randClassAtArr:classArr];
            }];
            
            for (NSInteger i = 0; i<5; i++) {
                [vms ag_packageItemData:^(NSMutableDictionary *package) {
                    package[kAGVMBoxColor] = [self _randColorAtArr:colorArr];
                    package[kAGVMBoxTitle] = @"我们是Bosh。";
                    package[kAGVMViewClass] = [self _randClassAtArr:classArr];
                }];
            }
            
            // 最后一个 item
            [vms ag_packageItemData:^(NSMutableDictionary *package) {
                package[kAGVMBoxColor] = [UIColor greenColor];
                package[kAGVMBoxTitle] = @"我是最后一个item！";
                // 单独设置要实例化的类
                package[kAGVMViewClass] = [self _randClassAtArr:classArr];
            }];
            
        } capacity:6];
        
        // 第三组
        [_boxVMManager ag_packageSection:^(AGVMSection *vms) {
            
            // 共享数据模型
            [vms ag_packageItemMergeData:^(NSMutableDictionary *package) {
                // 要实例化的类
                package[kAGVMViewClass] = [self _randClassAtArr:classArr];
                package[kAGVMBoxTitle] = @"波波维奇。";
                
            }];
            
            for (NSInteger i = 0; i<3; i++) {
                [vms ag_packageItemData:^(NSMutableDictionary *package) {
                    package[kAGVMBoxColor] = [self _randColorAtArr:colorArr];
                    package[kAGVMBoxTitle] = @"白云山！";
                }];
            }
            
            
            for (NSInteger i = 0; i<3; i++) {
                [vms ag_packageItemData:^(NSMutableDictionary *package) {
                    package[kAGVMBoxColor] = [UIColor brownColor];
                    package[kAGVMBoxTitle] = @"龙的传人！";
                    package[kAGVMViewClass] = [self _randClassAtArr:classArr];
                }];
            }
            
            for (NSInteger i = 0; i<3; i++) {
                [vms ag_packageItemData:^(NSMutableDictionary *package) {
                    package[kAGVMBoxColor] = [self _randColorAtArr:colorArr];
                    package[kAGVMBoxTitle] = @"龙的传人！";
                    package[kAGVMViewClass] = [self _randClassAtArr:classArr];
                }];
            }
            
        } capacity:10];
        
    }
    return _boxVMManager;
}

- (Class) _randClassAtArr:(NSArray *)arr
{
    int count = (int)arr.count;
    return arr[arc4random_uniform(count)];
}

- (UIColor *) _randColorAtArr:(NSArray *)arr
{
    int count = (int)arr.count;
    return arr[arc4random_uniform(count)];
}

@end
