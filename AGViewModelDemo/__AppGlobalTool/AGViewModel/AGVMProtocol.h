//
//  AGVMProtocol.h
//
//
//  Created by JohnnyB0Y on 2017/7/23.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#ifndef AGVMProtocol_h
#define AGVMProtocol_h

#import <UIKit/UIKit.h>
@class AGViewModel, AGVMSection;
@protocol AGVMIncludable;


NS_ASSUME_NONNULL_BEGIN

#pragma mark - ------------- typedef block --------------
#pragma mark viewModel block
typedef void(^AGVMConfigDataBlock)
(
    AGViewModel *vm,
    UIView<AGVMIncludable> *bv,
    NSMutableDictionary *bm
);


typedef void(^AGVMUpdateModelBlock)
(
    NSMutableDictionary *bm
);


typedef void (^AGVMNotificationBlock)
(
    AGViewModel *vm,
    NSString *key,
    NSDictionary<NSKeyValueChangeKey, id> *change
);


#pragma mark viewModelProcess block
typedef void(^AGVMPackageSectionBlock)
(
    AGVMSection *vms
);

typedef void(^AGVMPackageSectionsBlock)
(
    AGVMSection *vms,
    id obj,
    NSUInteger idx
);

#pragma mark viewModelPackage block
typedef void (^AGVMPackageDataBlock)
(
    NSMutableDictionary *package
);

typedef void (^AGVMPackageDatasBlock)
(
    NSMutableDictionary *package,
    id obj,
    NSUInteger idx
);

#pragma mark - ------------- ViewModel 相关协议 --------------
#pragma mark BaseReusable Protocol
@protocol AGBaseReusable <NSObject>
@required
+ (NSString *) ag_reuseIdentifier;

@optional
- (void) ag_configData:(nullable id)data;

@end

#pragma mark CollectionViewCell Protocol
@protocol AGCollectionCellReusable <AGBaseReusable>
@required
+ (void) ag_registerCellBy:(UICollectionView *)collectionView;
+ (__kindof UICollectionViewCell *) ag_dequeueCellBy:(UICollectionView *)collectionView
                                                 for:(nullable NSIndexPath *)indexPath;
@end

#pragma mark HeaderViewReusable Protocol
@protocol AGCollectionHeaderViewReusable <AGBaseReusable>
@required
+ (void) ag_registerHeaderViewBy:(UICollectionView *)collectionView;
+ (__kindof UICollectionReusableView *) ag_dequeueHeaderViewBy:(UICollectionView *)collectionView
                                                           for:(nullable NSIndexPath *)indexPath;
@end

#pragma mark FooterViewReusable Protocol
@protocol AGCollectionFooterViewReusable <AGBaseReusable>
@required
+ (void) ag_registerFooterViewBy:(UICollectionView *)collectionView;
+ (__kindof UICollectionReusableView *) ag_dequeueFooterViewBy:(UICollectionView *)collectionView
                                                           for:(nullable NSIndexPath *)indexPath;
@end

#pragma mark TableViewCell Protocol
@protocol AGTableCellReusable <AGBaseReusable>
@required
+ (void) ag_registerCellBy:(UITableView *)tableView;
+ (__kindof UITableViewCell *) ag_dequeueCellBy:(UITableView *)tableView
                                            for:(nullable NSIndexPath *)indexPath;
@end

#pragma mark HeaderFooterViewReusable Protocol
@protocol AGTableHeaderFooterViewReusable <AGBaseReusable>
@required
+ (void) ag_registerHeaderFooterViewBy:(UITableView *)tableView;
+ (__kindof UITableViewHeaderFooterView *) ag_dequeueHeaderFooterViewBy:(UITableView *)tableView;

@end

#pragma mark ViewController Protocol
@protocol AGViewControllerProtocol <NSObject>
@required
+ (__kindof UIViewController *) ag_viewControllerWithViewModel:(nullable AGViewModel *)vm;

@optional

@end


#pragma mark AGVMPackagable
@protocol AGVMPackagable <NSObject>
- (AGViewModel *) ag_packageData:(NSDictionary *)dict forObject:(nullable id)obj;
@end


#pragma mark AGViewModelIncludable
@protocol AGVMIncludable <NSObject>
@required
/** 持有的 viewModel */
@property (nonatomic, strong, nullable) AGViewModel *viewModel;

@optional
/**
 计算返回 bindingView 的 size
 
 @param vm viewModel
 @param bvS bindingViewSize
 @return 计算后的 Size
 */
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForBindingView:(CGSize)bvS;

@end

#pragma mark AGViewModelDelegate
@protocol AGVMDelegate <NSObject>

/**
 通过 viewModel 的 @selector(ag_callDelegateToDoForInfo:)          方法通知 delegate 做事。
 通过 viewModel 的 @selector(ag_callDelegateToDoForViewModel:)     方法通知 delegate 做事。
 通过 viewModel 的 @selector(ag_callDelegateToDoForAction:)        方法通知 delegate 做事。
 通过 viewModel 的 @selector(ag_callDelegateToDoForAction:info:)   方法通知 delegate 做事。
 */

@optional
- (void) ag_viewModel:(AGViewModel *)vm callDelegateToDoForInfo:(nullable NSDictionary *)info;
- (void) ag_viewModel:(AGViewModel *)vm callDelegateToDoForViewModel:(nullable AGViewModel *)info;
- (void) ag_viewModel:(AGViewModel *)vm callDelegateToDoForAction:(nullable SEL)action;
- (void) ag_viewModel:(AGViewModel *)vm callDelegateToDoForAction:(nullable SEL)action info:(nullable AGViewModel *)info;

@end


#pragma mark - AGVMObserverRegistration
@protocol AGVMObserverRegistration <NSObject>
#pragma mark readd observer
/**
 重新添加观察者 并 移除旧的观察者，观察 bindingModel 键-值变化
 
 @param observer 观察者
 @param key 观察的键
 @param block 回调 Block
 */
- (void) ag_readdObserver:(NSObject *)observer
                   forKey:(NSString *)key
                    block:(AGVMNotificationBlock)block;

/**
 重新添加观察者 并 移除旧的观察者，观察 bindingModel 键-值变化
 
 @param observer 观察者
 @param keys 观察的一组键
 @param block 回调 Block
 */
- (void) ag_readdObserver:(NSObject *)observer
                   forKeys:(NSArray<NSString *> *)keys
                    block:(AGVMNotificationBlock)block;

/**
 重新添加观察者 并 移除旧的观察者，观察 bindingModel 键-值变化
 
 @param observer 观察者
 @param key 观察的键
 @param options 同KVO
 @param block 回调 Block
 */
- (void) ag_readdObserver:(NSObject *)observer
                   forKey:(NSString *)key
                  options:(NSKeyValueObservingOptions)options
                    block:(AGVMNotificationBlock)block;

/**
 重新添加观察者 并 移除旧的观察者，观察 bindingModel 键-值变化
 
 @param observer 观察者
 @param keys 观察的一组键
 @param options 同KVO
 @param block 回调 Block
 */
- (void) ag_readdObserver:(NSObject *)observer
                  forKeys:(NSArray<NSString *> *)keys
                  options:(NSKeyValueObservingOptions)options
                    block:(AGVMNotificationBlock)block;

#pragma mark add observer
/**
 观察 bindingModel 键-值变化

 @param observer 观察者
 @param key 观察的键
 @param block 回调 Block
 */
- (void) ag_addObserver:(NSObject *)observer
                 forKey:(NSString *)key
                  block:(AGVMNotificationBlock)block;

/**
 观察 bindingModel 键-值变化
 
 @param observer 观察者
 @param keys 观察的一组键
 @param block 回调 Block
 */
- (void) ag_addObserver:(NSObject *)observer
                forKeys:(NSArray<NSString *> *)keys
                  block:(AGVMNotificationBlock)block;

/**
 观察 bindingModel 键-值变化
 
 @param observer 观察者
 @param key 观察的键
 @param options 同KVO
 @param block 回调 Block
 */
- (void) ag_addObserver:(NSObject *)observer
                 forKey:(NSString *)key
                options:(NSKeyValueObservingOptions)options
                  block:(AGVMNotificationBlock)block;

/**
 观察 bindingModel 键-值变化
 
 @param observer 观察者
 @param keys 观察的一组键
 @param options 同KVO
 @param block 回调 Block
 */
- (void) ag_addObserver:(NSObject *)observer
                forKeys:(NSArray<NSString *> *)keys
                options:(NSKeyValueObservingOptions)options
                  block:(AGVMNotificationBlock)block;

#pragma mark remove observer
/**
 停止该观察者监听 bindingModel 对应 key 的键值变化

 @param observer 观察者
 @param key 停止观察的键
 */
- (void) ag_removeObserver:(NSObject *)observer
                    forKey:(NSString *)key;

/**
 停止该观察者监听 bindingModel 对应 一组key 的键值变化
 
 @param observer 观察者
 @param keys 停止观察的一组键
 */
- (void) ag_removeObserver:(NSObject *)observer
                   forKeys:(NSArray<NSString *> *)keys;


/**
 停止该观察者监听 bindingModel 的键值变化

 @param observer 观察者
 */
- (void) ag_removeObserver:(NSObject *)observer;


/**
 停止所有观察者监听 bindingModel 的键值变化
 */
- (void) ag_removeAllObservers;

@end

#pragma mark - ------------- typedef enum --------------
typedef NS_ENUM(NSUInteger, AGVMStatus) {
    /** 无状态 */
    AGVMStatusNone = 0,
    /** 刷新状态 */
    AGVMStatusReload,
    /** 选中状态 */
    AGVMStatusSelected,
    /** 禁用状态 */
    AGVMStatusDisable,
    /** 删除状态 */
    AGVMStatusDelete,
    /** 新增状态 */
    AGVMStatusAdd,
};


#endif /* AGVMProtocol_h */

NS_ASSUME_NONNULL_END
