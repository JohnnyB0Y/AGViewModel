//
//  UITableView+AGViewModel.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/3/3.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AGViewReusable;

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (AGViewModel)

#pragma mark - table view cell
- (void) ag_registerCellForClass:(Class<AGViewReusable>)cls;
- (void) ag_registerNibCellForClass:(Class<AGViewReusable>)cls;
- (__kindof UITableViewCell *) ag_dequeueCellWithClass:(Class<AGViewReusable>)cls for:(nullable NSIndexPath *)indexPath;

- (void) ag_registerCellForClassName:(NSString *)clsName;
- (void) ag_registerNibCellForName:(NSString *)clsName;
- (__kindof UITableViewCell *) ag_dequeueCellWithClassName:(NSString *)clsName for:(nullable NSIndexPath *)indexPath;

#pragma mark - table view header footer view
- (void) ag_registerHeaderFooterViewForClass:(Class<AGViewReusable>)cls;
- (void) ag_registerNibHeaderFooterViewForClass:(Class<AGViewReusable>)cls;
- (__kindof UITableViewHeaderFooterView *) ag_dequeueHeaderFooterViewWithClass:(Class<AGViewReusable>)cls;

- (void) ag_registerHeaderFooterViewForClassName:(NSString *)clsName;
- (void) ag_registerNibHeaderFooterViewForClassName:(NSString *)clsName;
- (__kindof UITableViewHeaderFooterView *) ag_dequeueHeaderFooterViewWithClassName:(NSString *)clsName;

@end

NS_ASSUME_NONNULL_END
