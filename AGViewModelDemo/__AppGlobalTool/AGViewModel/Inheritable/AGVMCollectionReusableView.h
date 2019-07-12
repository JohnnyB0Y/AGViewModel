//
//  AGVMCollectionReusableView.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/7/12.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AGVMCollectionReusableView : UICollectionReusableView

#pragma mark Override Methods
/** 添加子视图 */
- (void) ag_addSubviews NS_REQUIRES_SUPER;

/** 布局子视图 */
- (void) ag_layoutSubviews NS_REQUIRES_SUPER;

/** 设置UI */
- (void) ag_setupUI NS_REQUIRES_SUPER;

/** 添加事件&行为 */
- (void) ag_addActions NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
