//
//  AGBaseViewManager.h
//  
//
//  Created by JohnnyB0Y on 2017/9/14.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGVMKit.h"
#import <MJRefresh.h>

typedef void(^AGTableViewManagerItemClickBlock)
(
    UITableView *tableView,
    NSIndexPath *indexPath,
    AGViewModel *vm
);

typedef void(^AGCollectionViewManagerItemClickBlock)
(
    UICollectionView *collectionView,
    NSIndexPath *indexPath,
    AGViewModel *vm
);

typedef void(^ATVMManagerHandleBlock)
(
    AGVMManager *originVmm
);


@interface AGBaseViewManager : NSObject

/** vm 绑定的 delegate */
@property (nonatomic, weak) id<AGVMDelegate> vmDelegate;
/** view model manager */
@property (nonatomic, strong, readonly) AGVMManager *vmm;
/** 预估的 view 高度 */
@property (nonatomic, assign, readonly) CGFloat estimateHeight;


#pragma mark block
/** 下拉刷新 */
@property (nonatomic, copy) MJRefreshComponentRefreshingBlock headerRefreshingBlock;
/** 上拉加载 */
@property (nonatomic, copy) MJRefreshComponentRefreshingBlock footerRefreshingBlock;


#pragma mark operation
/**
 处理数据
 
 @param vmm 新的数据
 @param block 处理 block
 */
- (void) handleVMManager:(AGVMManager *)vmm inBlock:(NS_NOESCAPE ATVMManagerHandleBlock)block;

/**
 没有更多数据
 */
- (void) noMoreData;

/**
 开始刷新
 */
- (void) startRefresh;
/**
 结束刷新
 */
- (void) stopRefresh;

@end
