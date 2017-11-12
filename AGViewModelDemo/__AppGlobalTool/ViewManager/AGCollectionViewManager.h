//
//  AGCollectionViewManager.h
//  
//
//  Created by JohnnyB0Y on 2017/9/14.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGBaseViewManager.h"
@protocol
AGCollectionViewManagerLayoutDelegate,
AGCollectionViewManagerCustomizable,
AGCollectionViewManagerSettable;

typedef NS_ENUM(NSUInteger, AGCollectionLayoutDirection) {
    AGCollectionLayoutDirectionNone,
    AGCollectionLayoutDirectionLeft,
    AGCollectionLayoutDirectionRight,
    AGCollectionLayoutDirectionCenter, // 已实现
    AGCollectionLayoutDirectionTop,
    AGCollectionLayoutDirectionBotton,
};


@interface AGCollectionViewManager : AGBaseViewManager
<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate>


/** Nib 创建时可传入 */
@property (nonatomic, strong, readonly) UICollectionView *view;

/** layout delegate */
@property (nonatomic, weak) id<AGCollectionViewManagerLayoutDelegate> layoutDelegate;
/** 自定义 delegate */
@property (nonatomic, weak) id<AGCollectionViewManagerCustomizable> customizableDelegate;
/** 设置代理 */
@property (nonatomic, weak) id<AGCollectionViewManagerSettable> setupDelegate;

/** 点击 item 调用 block */
@property (nonatomic, copy) AGCollectionViewManagerItemClickBlock itemClickBlock;


- (void) registerFooterViewClasses:(NSArray<Class<AGCollectionFooterViewReusable>> *)classes;
- (void) registerHeaderViewClasses:(NSArray<Class<AGCollectionHeaderViewReusable>> *)classes;


#pragma mark init
/**
 指定初始化方法
 
 @param classes 要注册的cell class
 @param vmm 自定义的 vmm (nil 为 不分组)
 @return 实例
 */
- (instancetype) initWithCollectionView:(UICollectionView *)collectionView
                            cellClasses:(NSArray<Class<AGCollectionCellReusable>> *)classes
                        originVMManager:(AGVMManager *)vmm NS_DESIGNATED_INITIALIZER;

- (instancetype) initWithCellClasses:(NSArray<Class<AGCollectionCellReusable>> *)classes
                     originVMManager:(AGVMManager *)vmm;

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;


@end


@protocol AGCollectionViewManagerLayoutDelegate <NSObject>
@required
/** 布局方向 */
- (AGCollectionLayoutDirection) layoutDirectionForCollectionView:(AGCollectionViewManager *)manager;


@optional
// **************** 数字为优先级
/** collectionView width -0 */
- (CGFloat) widthForCollectionView:(AGCollectionViewManager *)manager;


/** 列数 -1 */
- (NSUInteger) numberOfColsInCollectionView:(AGCollectionViewManager *)manager;


/** item 的宽高比 -2 */
- (CGFloat) aspectRatioOfRowInCollectionView:(AGCollectionViewManager *)manager;
/** item Size -3 */
- (CGSize) sizeForItemInCollectionView:(AGCollectionViewManager *)manager;


/** 边距 默认 Zero -1 */
- (UIEdgeInsets) insetForSectionInCollectionView:(AGCollectionViewManager *)manager;
/** item 间距 默认 Zero -4 */
- (CGSize) intervalForItemInCollectionView:(AGCollectionViewManager *)manager;

@end

#pragma mark View model 使用前进行设置
@protocol AGCollectionViewManagerSettable <NSObject>
@optional
- (void) collectionViewManager:(AGCollectionViewManager *)manager
            willSetupCellModel:(AGViewModel *)vm
                   atIndexPath:(NSIndexPath *)indexPath;

- (void) collectionViewManager:(AGCollectionViewManager *)manager
          willSetupHeaderModel:(AGViewModel *)vm
                   atIndexPath:(NSIndexPath *)indexPath;

- (void) collectionViewManager:(AGCollectionViewManager *)manager
          willSetupFooterModel:(AGViewModel *)vm
                   atIndexPath:(NSIndexPath *)indexPath;

@end

@protocol AGCollectionViewManagerCustomizable <NSObject>
/** description
 
 1.以模型中的 cell 类型为主。
 2.当模型中的 cell 为空才会调用代理返回的 cell 类型。
 
 */
@optional
/**
 取出对应 item 的 Class

 @param manager collectionViewManager
 @param indexPath 位置
 @return 对应cell 的Class
 */
- (Class<AGVMIncludable, AGCollectionCellReusable>) collectionViewManager:(AGCollectionViewManager *)manager
                                                  classForItemAtIndexPath:(NSIndexPath *)indexPath;

- (Class<AGVMIncludable, AGCollectionHeaderViewReusable>) collectionViewManager:(AGCollectionViewManager *)manager
                                                  classForHeaderViewAtIndexPath:(NSIndexPath *)indexPath;

- (Class<AGVMIncludable, AGCollectionFooterViewReusable>) collectionViewManager:(AGCollectionViewManager *)manager
                                                  classForFooterViewAtIndexPath:(NSIndexPath *)indexPath;

@end

