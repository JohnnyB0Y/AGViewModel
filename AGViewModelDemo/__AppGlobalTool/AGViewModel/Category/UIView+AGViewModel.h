//
//  UIView+AGViewModel.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/12.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGViewModel.h"
#import "AGVMProtocol.h"

@interface UIView (AGViewModel)
<AGVMIncludable>

- (void) setViewModel:(nullable AGViewModel *)viewModel NS_REQUIRES_SUPER;
- (nullable AGViewModel *) viewModel NS_REQUIRES_SUPER;

/** 当前 bundle */
+ (NSBundle *) ag_currentBundle;

/** 是否能从nil文件创建视图 */
+ (BOOL) ag_canAwakeFromNib;

/** 从 nib 创建实例,没有nib 时返回 nil */
+ (instancetype) ag_createFromNib;

@end
