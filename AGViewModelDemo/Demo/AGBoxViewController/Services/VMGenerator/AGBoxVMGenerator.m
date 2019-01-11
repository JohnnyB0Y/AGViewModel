//
//  AGBoxVMGenerator.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/8/20.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  box viewModel 生成器

#import "AGBoxVMGenerator.h"
#import "AGVMKit.h"

@implementation AGBoxVMGenerator {
    AGBoxACell *_aCell; // 用来计算Cell的size
    AGBoxBCell *_bCell;
    AGBoxCCell *_cCell;
}

- (AGVMManager *)boxVMManager
{
    if (_boxVMManager == nil) {
        _boxVMManager = ag_newAGVMManager(3);
        
        // 公共数据
        [_boxVMManager ag_packageCommonData:^(AGViewModel * _Nonnull package) {
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
            [vms ag_packageCommonData:^(AGViewModel * _Nonnull package) {
                package[kAGVMBoxTitle] = @"SSS";
            }];
            
            // 为了提前计算 cell的 Size, 因为这里cell类型是随机生成的，比较蛋疼。
            Class<AGCollectionCellReusable> cellCls = [self _randClassAtArr:classArr];
            UICollectionViewCell *cell = [self _cellOfClass:cellCls];
            
            // 共享数据模型
            [vms ag_packageItemMergeData:^(AGViewModel *package) {
                // 要实例化的类
                package[kAGVMViewClass] = cellCls;
            }];
            
            // 第一个 item
            [[vms ag_packageItemData:^(AGViewModel *package) {
                package[kAGVMBoxColor] = [self _randColorAtArr:colorArr];
                package[kAGVMBoxTitle] = @"我是第一个item！";
            }] ag_cachedSizeByBindingView:cell];
            
            for (NSInteger i = 0; i<9; i++) {
                cellCls = [self _randClassAtArr:classArr];
                cell = [self _cellOfClass:cellCls];
                [[vms ag_packageItemData:^(AGViewModel *package) {
                    package[kAGVMBoxColor] = [self _randColorAtArr:colorArr];
                    package[kAGVMBoxTitle] = @"我们是谁？";
                    package[kAGVMViewClass] = cellCls;
                }] ag_cachedSizeByBindingView:cell];
            }
            
        } capacity:10];
        
        // 第二组
        [_boxVMManager ag_packageSection:^(AGVMSection *vms) {
            
            // 为了提前计算 cell的 Size, 因为这里cell类型是随机生成的，比较蛋疼。
            Class<AGCollectionCellReusable> cellCls = [self _randClassAtArr:classArr];
            UICollectionViewCell *cell = [self _cellOfClass:cellCls];
            
            // 第一个 item
            [[vms ag_packageItemData:^(AGViewModel *package) {
                package[kAGVMBoxColor] = [UIColor blackColor];
                package[kAGVMBoxTitle] = @"我是第一个item！";
                // 单独设置要实例化的类
                package[kAGVMViewClass] = cellCls;
            }] ag_cachedSizeByBindingView:cell];
            
            // 第二个 item
            cellCls = [self _randClassAtArr:classArr];
            cell = [self _cellOfClass:cellCls];
            [[vms ag_packageItemData:^(AGViewModel *package) {
                package[kAGVMBoxColor] = [UIColor greenColor];
                package[kAGVMBoxTitle] = @"我是第二个item！";
                // 单独设置要实例化的类
                package[kAGVMViewClass] = cellCls;
            }] ag_cachedSizeByBindingView:cell];
            
            for (NSInteger i = 0; i<5; i++) {
                cellCls = [self _randClassAtArr:classArr];
                cell = [self _cellOfClass:cellCls];
                [[vms ag_packageItemData:^(AGViewModel *package) {
                    package[kAGVMBoxColor] = [self _randColorAtArr:colorArr];
                    package[kAGVMBoxTitle] = @"我们是Bosh。";
                    package[kAGVMViewClass] = cellCls;
                }] ag_cachedSizeByBindingView:cell];
            }
            
            // 最后一个 item
            cellCls = [self _randClassAtArr:classArr];
            cell = [self _cellOfClass:cellCls];
            [[vms ag_packageItemData:^(AGViewModel *package) {
                package[kAGVMBoxColor] = [UIColor greenColor];
                package[kAGVMBoxTitle] = @"我是最后一个item！";
                // 单独设置要实例化的类
                package[kAGVMViewClass] = cellCls;
            }] ag_cachedSizeByBindingView:cell];
            
        } capacity:6];
        
        // 第三组
        [_boxVMManager ag_packageSection:^(AGVMSection *vms) {
            
            // 为了提前计算 cell的 Size, 因为这里cell类型是随机生成的，比较蛋疼。
            Class<AGCollectionCellReusable> cellCls = [self _randClassAtArr:classArr];
            UICollectionViewCell *cell = [self _cellOfClass:cellCls];
            
            // 共享数据模型
            [vms ag_packageItemMergeData:^(AGViewModel *package) {
                // 要实例化的类
                package[kAGVMViewClass] = cellCls;
                package[kAGVMBoxTitle] = @"波波维奇。";
                
            }];
            
            for (NSInteger i = 0; i<3; i++) {
                [[vms ag_packageItemData:^(AGViewModel *package) {
                    package[kAGVMBoxColor] = [self _randColorAtArr:colorArr];
                    package[kAGVMBoxTitle] = @"白云山！";
                }] ag_cachedSizeByBindingView:cell];
            }
            
            
            for (NSInteger i = 0; i<3; i++) {
                cellCls = [self _randClassAtArr:classArr];
                cell = [self _cellOfClass:cellCls];
                [[vms ag_packageItemData:^(AGViewModel *package) {
                    package[kAGVMBoxColor] = [UIColor brownColor];
                    package[kAGVMBoxTitle] = @"龙的传人！";
                    package[kAGVMViewClass] = cellCls;
                }] ag_cachedSizeByBindingView:cell];
            }
            
            for (NSInteger i = 0; i<3; i++) {
                cellCls = [self _randClassAtArr:classArr];
                cell = [self _cellOfClass:cellCls];
                [[vms ag_packageItemData:^(AGViewModel *package) {
                    package[kAGVMBoxColor] = [self _randColorAtArr:colorArr];
                    package[kAGVMBoxTitle] = @"龙的传人！";
                    package[kAGVMViewClass] = cellCls;
                }] ag_cachedSizeByBindingView:cell];
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

- (UICollectionViewCell *) _cellOfClass:(Class)cls
{
    if ( cls == [AGBoxACell class] ) {
        return _aCell ?: [AGBoxACell ag_createFromNibInBundle:nil];
    }
    else if ( cls == [AGBoxBCell class] ) {
        return _bCell ?: [AGBoxBCell ag_createFromNibInBundle:nil];
    }
    else if ( cls == [AGBoxCCell class] ) {
        return _cCell ?: [AGBoxCCell ag_createFromNibInBundle:nil];
    }
    return nil;
}

@end
