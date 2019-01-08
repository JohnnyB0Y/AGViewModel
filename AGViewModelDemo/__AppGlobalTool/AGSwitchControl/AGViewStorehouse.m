//
//  AGViewStorehouse.m
//
//
//  Created by JohnnyB0Y on 16/8/30.
//  Copyright © 2016年 JohnnyB0Y. All rights reserved.
//  视图仓库

#import "AGViewStorehouse.h"

@interface AGViewStorehouse ()
{
    struct AGResponeMethods {
        unsigned int ag_viewFromStorehouse : 1;
        unsigned int ag_storageViewAtIndex : 1;
        unsigned int ag_dequeueViewAtIndex : 1;
    } _responeMethod;
    
}

/** 字典 */
@property (nonatomic, strong) NSMutableArray<UIView *> *storehouse;

@end

@implementation AGViewStorehouse

#pragma mark - ------------ Public Methods ---------------
- (UIView *) ag_dequeueViewFromStorehouseAtIndex:(NSUInteger)index
{
	index = index > 0 ? index : 0;
    NSUInteger count = self.storehouse.count;
    UIView *view;
    
    if (count > index) {
        // 有内容-取出
        view = self.storehouse[index];
        view.hidden = NO;
        
    } else {
        // 没内容-创建
        if (_responeMethod.ag_viewFromStorehouse) {
            // 补齐前面空缺的视图
            for (NSInteger i = self.storehouse.count; i<=index; i++) {
                view = [self.dataSource ag_viewFromStorehouse:self];
                view.tag = index;
                
                // 保存视图 前调用
                if (_responeMethod.ag_storageViewAtIndex) {
                    [self.dataSource ag_viewStorehouse:self storageView:view atIndex:index];
                }
                
                // 保存视图
                [self _addViewToStorehouse:view];
            }
            
        }
        // 断言
        NSAssert(view != nil, @"实现 AGViewStorehouseDelegate，返回要取出的视图！");
    }
    
    // 取出视图 后调用
    if (_responeMethod.ag_dequeueViewAtIndex) {
        [self.dataSource ag_viewStorehouse:self dequeueView:view atIndex:index];
    }
    
    return view;
}

/** 隐藏所有视图 */
- (void) ag_hideAllViews
{
    for (UIView *view in self.storehouse) {
        view.hidden = YES;
    }
}

#pragma mark - ------------ Private Methods ---------------
- (void) _addViewToStorehouse:(UIView *)view
{
    if ( view ) [self.storehouse addObject:view];
}

#pragma mark - ------------ Getter Methods ---------------
- (NSMutableArray<UIView *> *)storehouse
{
    if (_storehouse == nil) {
        _storehouse = [NSMutableArray arrayWithCapacity:6];
    }
    return _storehouse;
}

- (NSArray<UIView *> *)allViews
{
    return [self.storehouse copy];
}

#pragma mark - ------------ Setter Methods ---------------
- (void)setDataSource:(id<AGViewStorehouseDataSource>)dataSource
{
    _dataSource = dataSource;
    
    _responeMethod.ag_viewFromStorehouse
    = [dataSource respondsToSelector:@selector(ag_viewFromStorehouse:)];
    
    _responeMethod.ag_storageViewAtIndex
    = [dataSource respondsToSelector:@selector(ag_viewStorehouse:storageView:atIndex:)];
    
    _responeMethod.ag_dequeueViewAtIndex
    = [dataSource respondsToSelector:@selector(ag_viewStorehouse:dequeueView:atIndex:)];
    
}

@end
