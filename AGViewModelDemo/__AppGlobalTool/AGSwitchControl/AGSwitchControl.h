//
//  AGSwitchControl.h
//
//
//  Created by JohnnyB0Y on 2017/4/9.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  分段切换控制视图

#import <UIKit/UIKit.h>
#import "AGVMKit.h"
#import "AGSwitchControlItem.h"

@protocol AGSwitchControlDelegate, AGSwitchControlDataSource, AGSwitchControlSettable;
@class AGSwitchControl;
/** 
 
 // 待优化 ---
 // 移除依赖 Masonry 👌
 // 一种切换选择，一种点击选择
 // 把动画效果拆分出来
 // 屏幕旋转
 
 */

typedef CGSize (^AGSwitchControlSetupUIBlock)(UIView *targetView);
typedef void (^AGSwitchControlSetupCollectionViewBlock)(UICollectionView *collectionView);
typedef void (^AGSwitchControlSetupSwitchControlBlock)(AGSwitchControl<AGSwitchControlSettable> *switchControl);

@interface AGSwitchControl : UIView

@property (nonatomic, weak, readonly) id<AGSwitchControlDelegate> delegate;
@property (nonatomic, weak, readonly) id<AGSwitchControlDataSource> dataSource;

@property (nonatomic, assign, readonly) CGFloat selectedOffsetX;
@property (nonatomic, assign, readonly) CGFloat titleCollectionViewH;
@property (nonatomic, assign, readonly) CGFloat underlineBottomMargin;

@property (nonatomic, assign, readonly) BOOL titleAnimation;
@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, assign, readonly, getter=isItemToLeft) BOOL itemToLeft;

@property (nonatomic, strong, readonly) UICollectionView *titleCollectionView;
@property (nonatomic, strong, readonly) UICollectionView *detailCollectionView;

#pragma mark 添加视图
- (void) ag_setupHeaderViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupUIBlock)block; // 头视图
- (void) ag_setupFooterViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupUIBlock)block;
- (void) ag_setupLeftViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupUIBlock)block;
- (void) ag_setupRightViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupUIBlock)block;
- (void) ag_setupUnderlineViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupUIBlock)block; // 下划线
- (void) ag_setupTitleCollectionViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupCollectionViewBlock)block; // 标题
- (void) ag_setupDetailCollectionViewUsingBlock:(NS_NOESCAPE AGSwitchControlSetupCollectionViewBlock)block; // 详情

// 使用这个初始化
- (instancetype) initWithSettableBlock:(NS_NOESCAPE AGSwitchControlSetupSwitchControlBlock)block;

///** 刷新数据 */
//- (void) ag_reloadData;

/** 点击 idx 按钮 */
- (void) ag_clickAtIndex:(NSInteger)idx;

@end

#pragma mark - AGSwitchControlDataSource 使用协议
@protocol AGSwitchControlDataSource <NSObject>

@required
/* 一共多少个标签 */
- (NSInteger) ag_numberOfItemInSwitchControl:(AGSwitchControl *)switchControl;

- (AGViewModel *) ag_switchControl:(AGSwitchControl *)switchControl
      viewModelForTitleItemAtIndex:(NSInteger)index;

@optional
#pragma mark 默认模式
/** 每个标签控制的视图 */
- (UIView *) ag_switchControl:(AGSwitchControl *)switchControl
     viewForDetailItemAtIndex:(NSInteger)index;

#pragma mark 自定义动画模式
- (void) ag_switchControl:(AGSwitchControl *)switchControl
   animationWithTitleItem:(UICollectionViewCell *)fromItem
                   toItem:(UICollectionViewCell *)toItem;

@end

#pragma mark - AGSwitchControlDelegate 使用协议
@protocol AGSwitchControlDelegate <NSObject>
@optional
/** 点击 itme */
- (void) ag_switchControl:(AGSwitchControl *)switchControl clickTitleItemAtIndex:(NSInteger)index;

/** 手指触碰 itme */
- (void) ag_switchControl:(AGSwitchControl *)switchControl scrollViewWillBeginDraggingAtIndex:(NSInteger)index;

//- (void) ag_switchControl:(AGSwitchControl *)switchControl scrollViewDidEndDecelerating:(UIScrollView *)scrollView;
//- (void) ag_switchControl:(AGSwitchControl *)switchControl scrollViewDidScroll:(UIScrollView *)scrollView;

@end

#pragma mark - AGSwitchControlSettable 设置参数
@protocol AGSwitchControlSettable <NSObject>

/** 代理 */
@property (nonatomic, weak) id<AGSwitchControlDelegate> delegate;
/** 数据源代理 */
@property (nonatomic, weak) id<AGSwitchControlDataSource> dataSource;

@property (nonatomic, assign) CGFloat titleCollectionViewH;

@property (nonatomic, assign) NSInteger currentIndex;
/** title动画 */
@property (nonatomic, assign) BOOL titleAnimation;

/** under line bottom margin */
@property (nonatomic, assign) CGFloat underlineBottomMargin;

/** 选中偏移 */
@property (nonatomic, assign) CGFloat selectedOffsetX;

@end

@interface AGSwitchCollectionView : UICollectionView

@end
