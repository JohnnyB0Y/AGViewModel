//
//  AGTableViewManager.h
//
//
//  Created by JohnnyB0Y on 2017/9/11.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGBaseViewManager.h"
@protocol
AGTableViewManagerEditable,
AGTableViewManagerSettable,
AGTableViewManagerCustomizable,
AGTableViewManagerScrollDelegate;

@interface AGTableViewManager : AGBaseViewManager
<UITableViewDataSource, UITableViewDelegate>


/** Nib 创建时可传入 */
@property (nonatomic, strong, readonly) UITableView *view;
/** view model manager */
@property (nonatomic, strong, readonly) AGVMManager *vmm;
/** 点击 item 调用 block */
@property (nonatomic, copy) AGTableViewManagerItemClickBlock itemClickBlock;


/** tableHeaderView */
@property (nonatomic, strong) UIView *tableHeaderView;
/** tableFooterView */
@property (nonatomic, strong) UIView *tableFooterView;


/** cell height */
@property (nonatomic, assign) CGFloat cellH;
/** section header height */
@property (nonatomic, assign) CGFloat sectionHeaderH;
/** section footer height */
@property (nonatomic, assign) CGFloat sectionFooterH;

/** 能否滚动 */
@property (nonatomic, assign) BOOL canScroll;

/** 滚动代理 */
@property (nonatomic, weak) id<AGTableViewManagerScrollDelegate> scrollDelegate;

/** 编辑代理 */
@property (nonatomic, weak) id<AGTableViewManagerEditable> editDelegate;

/** 设置代理 */
@property (nonatomic, weak) id<AGTableViewManagerSettable> setupDelegate;

/** 自定义 delegate */
@property (nonatomic, weak) id<AGTableViewManagerCustomizable> customizableDelegate;

/** !!! */
- (void) registerHeaderFooterViewClasses:(NSArray<Class<AGTableHeaderFooterViewReusable>> *)classes;


#pragma mark init
/**
 指定初始化方法
 @param tableView 外部传入的 tableView
 @param classes 要注册的cell class
 @param vmm 自定义的 vmm (nil 为 不分组)
 @return 实例
 */
- (instancetype) initWithTableView:(UITableView *)tableView
                       cellClasses:(NSArray<Class<AGTableCellReusable>> *)classes
                   originVMManager:(AGVMManager *)vmm NS_DESIGNATED_INITIALIZER;

- (instancetype) initWithCellClasses:(NSArray<Class<AGTableCellReusable>> *)classes
                     originVMManager:(AGVMManager *)vmm;

- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;


#pragma mark 数据与界面的插入、删除、刷新
/**
 插入 vm
 
 @param viewModels 需要插入的 vm 数组
 @param animation 插入动画
 @param indexPath 插入的起始位置
 @return 是否插入成功
 */
- (BOOL)insertViewModels:(NSArray<AGViewModel *> *)viewModels
             atIndexPath:(NSIndexPath *)indexPath
        withRowAnimation:(UITableViewRowAnimation)animation;

/**
 插入 vm
 
 @param viewModels 需要插入的 vm 数组
 @param animation 插入动画
 @param indexPath 插入的起始位置
 @param scrollIndexPath 移动到的位置
 @param scrollPosition 移动到位置动画类型
 @return 是否插入成功
 */
- (BOOL)insertViewModels:(NSArray<AGViewModel *> *)viewModels
             atIndexPath:(NSIndexPath *)indexPath
        withRowAnimation:(UITableViewRowAnimation)animation
  scrollToRowAtIndexPath:(NSIndexPath *)scrollIndexPath
        atScrollPosition:(UITableViewScrollPosition)scrollPosition;

/**
 删除 vm
 
 @param viewModels 需要插入的 vm 数组
 @param animation 插入动画
 @return 是否删除成功
 */
- (BOOL)deleteViewModels:(NSArray<AGViewModel *> *)viewModels
        withRowAnimation:(UITableViewRowAnimation)animation;

/**
 刷新 vm
 
 @param viewModels 需要插入的 vm 数组
 @param animation 插入动画
 @return 是否刷新成功
 */
- (BOOL)reloadViewModels:(NSArray<AGViewModel *> *)viewModels
        withRowAnimation:(UITableViewRowAnimation)animation;


@end


#pragma mark 左划删除
@protocol AGTableViewManagerEditable <NSObject>

- (UITableViewCellEditingStyle)tableViewManager:(AGTableViewManager *)manager
                  editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath;

- (void) tableViewManager:(AGTableViewManager *)manager
       commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
        forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

#pragma mark View model 使用前进行设置
@protocol AGTableViewManagerSettable <NSObject>
@optional
- (void) tableViewManager:(AGTableViewManager *)manager
       willSetupCellModel:(AGViewModel *)vm
              atIndexPath:(NSIndexPath *)indexPath;

- (void) tableViewManager:(AGTableViewManager *)manager
     willSetupHeaderModel:(AGViewModel *)vm
                atSection:(NSInteger)section;

- (void) tableViewManager:(AGTableViewManager *)manager
     willSetupFooterModel:(AGViewModel *)vm
                atSection:(NSInteger)section;

@end

@protocol AGTableViewManagerCustomizable <NSObject>
/** description
 
 1.以模型中的 cell 类型为主。
 2.当模型中的 cell 为空才会调用代理返回的 cell 类型。
 
 */
@optional
/**
 取出对应 item 的 Class
 
 @param manager tableViewViewManager
 @param indexPath 位置
 @return 对应cell 的Class
 */
- (Class<AGVMIncludable, AGTableCellReusable>) tableViewManager:(AGTableViewManager *)manager
                                        classForItemAtIndexPath:(NSIndexPath *)indexPath;

- (Class<AGVMIncludable, AGTableHeaderFooterViewReusable>) tableViewManager:(AGTableViewManager *)manager
                                              classForHeaderViewAtIndexPath:(NSIndexPath *)indexPath;

- (Class<AGVMIncludable, AGTableHeaderFooterViewReusable>) tableViewManager:(AGTableViewManager *)manager
                                              classForFooterViewAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol AGTableViewManagerScrollDelegate <NSObject>

- (void) tableViewManagerScrollToTop:(AGTableViewManager *)manager;

//- (void) tableViewManagerScrollToTop:(AGTableViewManager *)manager;

@end


