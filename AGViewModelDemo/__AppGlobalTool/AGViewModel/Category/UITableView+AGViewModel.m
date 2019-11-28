//
//  UITableView+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/3/3.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "UITableView+AGViewModel.h"
#import "AGVMProtocol.h"

@implementation UITableView (AGViewModel)

#pragma mark - table view cell
- (void) ag_registerCellForClass:(Class<AGViewReusable>)cls
{
    [self registerClass:cls forCellReuseIdentifier:[cls ag_reuseIdentifier]];
}

- (void) ag_registerNibCellForClass:(Class<AGViewReusable>)cls
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cls) bundle:[cls ag_resourceBundle]];
    [self registerNib:nib forCellReuseIdentifier:[cls ag_reuseIdentifier]];
}

- (__kindof UITableViewCell *) ag_dequeueCellWithClass:(Class<AGViewReusable>)cls for:(NSIndexPath *)indexPath
{
    // 如果在此处奔溃，请优先检查视图是否已注册到 tableView。
    if ( indexPath ) {
        return [self dequeueReusableCellWithIdentifier:[cls ag_reuseIdentifier] forIndexPath:indexPath];
    }
    return [self dequeueReusableCellWithIdentifier:[cls ag_reuseIdentifier]];
}

- (void) ag_registerCellForClassName:(NSString *)clsName
{
    Class cls = NSClassFromString(clsName);
    [self registerClass:cls forCellReuseIdentifier:clsName];
}

- (void) ag_registerNibCellForName:(NSString *)clsName
{
    Class cls = NSClassFromString(clsName);
    UINib *nib = [UINib nibWithNibName:clsName bundle:[cls ag_resourceBundle]];
    [self registerNib:nib forCellReuseIdentifier:clsName];
}

- (__kindof UITableViewCell *) ag_dequeueCellWithClassName:(NSString *)clsName for:(nullable NSIndexPath *)indexPath
{
    // 如果在此处奔溃，请优先检查视图是否已注册到 tableView。
    if ( indexPath ) {
        return [self dequeueReusableCellWithIdentifier:clsName forIndexPath:indexPath];
    }
    return [self dequeueReusableCellWithIdentifier:clsName];
}

#pragma mark - table view header footer view
- (void) ag_registerHeaderFooterViewForClass:(Class<AGViewReusable>)cls
{
    [self registerClass:cls forHeaderFooterViewReuseIdentifier:[cls ag_reuseIdentifier]];
}

- (void) ag_registerNibHeaderFooterViewForClass:(Class<AGViewReusable>)cls
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass(cls) bundle:[cls ag_resourceBundle]];
    [self registerNib:nib forHeaderFooterViewReuseIdentifier:[cls ag_reuseIdentifier]];
}

- (__kindof UITableViewHeaderFooterView *) ag_dequeueHeaderFooterViewWithClass:(Class<AGViewReusable>)cls
{
    // 如果在此处奔溃，请优先检查视图是否已注册到 tableView。
    return [self dequeueReusableHeaderFooterViewWithIdentifier:[cls ag_reuseIdentifier]];
}

- (void) ag_registerHeaderFooterViewForClassName:(NSString *)clsName
{
    Class cls = NSClassFromString(clsName);
    [self registerClass:cls forHeaderFooterViewReuseIdentifier:clsName];
}

- (void) ag_registerNibHeaderFooterViewForClassName:(NSString *)clsName
{
    Class cls = NSClassFromString(clsName);
    UINib *nib = [UINib nibWithNibName:clsName bundle:[cls ag_resourceBundle]];
    [self registerNib:nib forHeaderFooterViewReuseIdentifier:clsName];
}

- (__kindof UITableViewHeaderFooterView *) ag_dequeueHeaderFooterViewWithClassName:(NSString *)clsName
{
    // 如果在此处奔溃，请优先检查视图是否已注册到 tableView。
    return [self dequeueReusableHeaderFooterViewWithIdentifier:clsName];
}

@end
