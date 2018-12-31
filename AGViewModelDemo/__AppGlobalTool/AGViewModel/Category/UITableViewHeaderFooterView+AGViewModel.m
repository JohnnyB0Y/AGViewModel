//
//  UITableViewHeaderFooterView+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/10.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "UITableViewHeaderFooterView+AGViewModel.h"

@implementation UITableViewHeaderFooterView (AGViewModel)

#pragma mark - AGTableHeaderFooterViewReusable
+ (NSString *) ag_reuseIdentifier
{
    return NSStringFromClass([self class]);
}

+ (void) ag_registerHeaderFooterViewBy:(UITableView *)tableView
{
    // 有特殊需求，请在子类重写。
    if ( [self ag_canAwakeFromNib] ) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[self ag_currentBundle]];
        [tableView registerNib:nib forHeaderFooterViewReuseIdentifier:[self ag_reuseIdentifier]];
    }
    else {
        [tableView registerClass:[self class] forHeaderFooterViewReuseIdentifier:[self ag_reuseIdentifier]];
    }
}

+ (__kindof UITableViewHeaderFooterView *) ag_dequeueHeaderFooterViewBy:(UITableView *)tableView
{
    // 如果在此处奔溃，请优先检查视图是否已注册到 tableView。
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:[self ag_reuseIdentifier]];
}

#pragma mark - ----------- AGVMIncludable -----------
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForBindingView:(CGSize)bvS
{
    // 有特殊需求，请在子类重写。
    if ( ! vm[kAGVMViewH] ) {
        bvS.height = 34.;
    }
    return bvS;
}

@end
