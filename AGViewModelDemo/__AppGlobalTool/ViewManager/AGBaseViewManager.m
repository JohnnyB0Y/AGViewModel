//
//  AGBaseViewManager.m
//
//
//  Created by JohnnyB0Y on 2017/9/14.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGBaseViewManager.h"

@implementation AGBaseViewManager

- (void)handleVMManager:(AGVMManager *)vmm inBlock:(NS_NOESCAPE ATVMManagerHandleBlock)block
{
    NSLog(@"%@: 我什么都没有做!", self);
}

/**
 没有更多数据
 */
- (void) noMoreData
{
    NSLog(@"%@: 我什么都没有做!", self);
}

/**
 开始刷新
 */
- (void) startRefresh
{
    NSLog(@"%@: 我什么都没有做!", self);
}

- (void) stopRefresh
{
    NSLog(@"%@: 我什么都没有做!", self);
}

- (CGFloat) estimateHeightWithItem:(UIView<AGVMIncludable> *)item
{
    NSLog(@"%@: 我什么都没有做!", self);
    return 0.;
}

@end

