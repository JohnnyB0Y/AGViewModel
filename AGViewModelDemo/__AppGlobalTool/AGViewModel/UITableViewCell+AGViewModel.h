//
//  UITableViewCell+AGViewModel.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/9.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGViewModel.h"
#import "AGVMProtocol.h"

@interface UITableViewCell (AGViewModel) <AGVMIncludable, AGTableCellReusable>

- (void) setViewModel:(AGViewModel *)viewModel NS_REQUIRES_SUPER;

/** 从 nib 创建实例,没有 nib时返回 nil */
+ (instancetype) ag_createFromNib;

@end
