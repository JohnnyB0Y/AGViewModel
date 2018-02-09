//
//  UITableViewHeaderFooterView+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/10.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "UITableViewHeaderFooterView+AGViewModel.h"
#import <objc/runtime.h>

static void *AGTableViewHeaderFooterViewModel;

@implementation UITableViewHeaderFooterView (AGViewModel)

+ (instancetype)ag_createFromNib
{
    // 有特殊需求，请在子类重写。
    NSString *className = NSStringFromClass([self class]);
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if ( nibPath ) {
        UINib *nib = [UINib nibWithNibName:className bundle:nil];
        return [[nib instantiateWithOwner:self options:nil] firstObject];
    }
    return nil;
}

#pragma mark - AGTableHeaderFooterViewReusable
+ (NSString *) ag_reuseIdentifier
{
    return NSStringFromClass([self class]);
}

+ (void) ag_registerHeaderFooterViewBy:(UITableView *)tableView
{
    // 有特殊需求，请在子类重写。
    NSString *className = NSStringFromClass([self class]);
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if ( nibPath ) {
        UINib *nib = [UINib nibWithNibName:className bundle:nil];
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

#pragma mark - ----------- Getter Setter Methods ----------
- (void)setViewModel:(AGViewModel *)viewModel
{
    objc_setAssociatedObject(self, &AGTableViewHeaderFooterViewModel, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AGViewModel *)viewModel
{
    return objc_getAssociatedObject(self, &AGTableViewHeaderFooterViewModel);
}

@end
