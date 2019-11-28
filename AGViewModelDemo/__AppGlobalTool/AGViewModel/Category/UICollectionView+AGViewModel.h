//
//  UICollectionView+AGViewModel.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/3/3.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AGViewReusable;

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionView (AGViewModel)

#pragma mark collection view cell
- (void) ag_registerCellForClass:(Class<AGViewReusable>)cls;
- (void) ag_registerNibCellForClass:(Class<AGViewReusable>)cls;
- (__kindof UICollectionViewCell *) ag_dequeueCellWithClass:(Class<AGViewReusable>)cls for:(NSIndexPath *)indexPath;

- (void) ag_registerCellForClassName:(NSString *)clsName;
- (void) ag_registerNibCellForClassName:(NSString *)clsName;
- (__kindof UICollectionViewCell *) ag_dequeueCellWithClassName:(NSString *)clsName for:(NSIndexPath *)indexPath;

#pragma mark collection view footer view
- (void) ag_registerFooterViewForClass:(Class<AGViewReusable>)cls;
- (void) ag_registerNibFooterViewForClass:(Class<AGViewReusable>)cls;
- (__kindof UICollectionReusableView *) ag_dequeueFooterViewWithClass:(Class<AGViewReusable>)cls for:(NSIndexPath *)indexPath;

- (void) ag_registerFooterViewForClassName:(NSString *)clsName;
- (void) ag_registerNibFooterViewForClassName:(NSString *)clsName;
- (__kindof UICollectionReusableView *) ag_dequeueFooterViewWithClassName:(NSString *)clsName for:(NSIndexPath *)indexPath;

#pragma mark collection view header view
- (void) ag_registerHeaderViewForClass:(Class<AGViewReusable>)cls;
- (void) ag_registerNibHeaderViewForClass:(Class<AGViewReusable>)cls;
- (__kindof UICollectionReusableView *) ag_dequeueHeaderViewWithClass:(Class<AGViewReusable>)cls for:(NSIndexPath *)indexPath;

- (void) ag_registerHeaderViewForClassName:(NSString *)clsName;
- (void) ag_registerNibHeaderViewForClassName:(NSString *)clsName;
- (__kindof UICollectionReusableView *) ag_dequeueHeaderViewWithClassName:(NSString *)clsName for:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
