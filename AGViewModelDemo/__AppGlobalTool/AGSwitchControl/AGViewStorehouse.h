//
//  AGViewStorehouse.h
//
//
//  Created by JohnnyB0Y on 16/8/30.
//  Copyright © 2016年 JohnnyB0Y. All rights reserved.
//  视图仓库

#import <UIKit/UIKit.h>
@class AGViewStorehouse;

@protocol AGViewStorehouseDataSource <NSObject>

@required
/** 添加到仓库的视图 */
- (UIView *) ag_viewFromStorehouse:(AGViewStorehouse *)storehouse;

@optional
/**
 *  存储视图到仓库 前调用
 *
 *  @param storehouse 视图仓库
 *  @param index      顺序位置
 */
- (void) ag_viewStorehouse:(AGViewStorehouse *)storehouse storageView:(UIView *)view atIndex:(NSUInteger)index;

/**
 *  从仓库取出视图 后调用
 *
 *  @param storehouse 视图仓库
 *  @param index      顺序位置
 */
- (void) ag_viewStorehouse:(AGViewStorehouse *)storehouse dequeueView:(UIView *)view atIndex:(NSUInteger)index;

@end

@interface AGViewStorehouse : NSObject

/** 代理 */
@property (nonatomic, weak) id<AGViewStorehouseDataSource> dataSource;

/** all View */
@property (nonatomic, strong, readonly) NSArray<UIView *> *allViews;

/** 取出视图 */
- (UIView *) ag_dequeueViewFromStorehouseAtIndex:(NSUInteger)index;

/** 隐藏所有视图 */
- (void) ag_hideAllViews;

@end
