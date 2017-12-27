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
#pragma mark quick block
typedef void (^AGVMTargetVCBlock)
(
     UIViewController * _Nullable vc,
     AGViewModel * _Nullable vm
);


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


typedef void (^AGVMSafeSetCompletionBlock)
(
	 AGViewModel *vm,
	 _Nullable id value, // 数据
	 BOOL safe // 数据是否类型安全
);


typedef _Nullable id (^AGVMSafeGetCompletionBlock)
(
	 AGViewModel *vm,
	 _Nullable id value, // 数据
	 BOOL safe // 数据是否类型安全
);


typedef NSNumber * _Nullable (^AGVMSafeGetNumberCompletionBlock)
(
	 AGViewModel *vm,
	 _Nullable id value, // 数据
	 BOOL safe // 数据是否类型安全
);


#pragma mark viewModelManager block
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
- (instancetype) initWithViewModel:(nullable AGViewModel *)vm;

@optional
+ (instancetype) alloc;
- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

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


#pragma mark - AGVMSafeAccessible
@protocol AGVMSafeAccessible <NSObject>
#pragma mark safe number
/**
 安全设置 NSNumber对象
 
 @param key 字典键
 @return 对value处理后返回的对象
 */
- (nullable id) ag_safeSetNumber:(nullable id)value forKey:(NSString *)key;
/**
 安全获取 NSNumber对象
 
 @param key 字典键
 @return NSNumber对象
 */
- (nullable NSNumber *) ag_safeNumberForKey:(NSString *)key;
/**
 安全设置 NSNumber对象

 @param value 设置的值
 @param key 设置的字典键
 @param block 完成后对结果进行处理的block
 @return 对value处理后返回的对象
 */
- (nullable id) ag_safeSetNumber:(nullable id)value forKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeSetCompletionBlock)block;
/**
 安全获取 NSNumber对象

 @param key 字典键
 @param block 完成后对结果进行处理的block
 @return NSNumber对象
 */
- (nullable NSNumber *) ag_safeNumberForKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeGetCompletionBlock)block;


#pragma mark safe string
/**
 安全设置 NSString对象
 
 @param key 字典键
 @return 对value处理后返回的对象
 */
- (nullable id) ag_safeSetString:(nullable id)value forKey:(NSString *)key;
/**
 安全获取 NSString对象
 
 @param key 字典键
 @return NSString对象
 */
- (nullable NSString *) ag_safeStringForKey:(NSString *)key;

/**
 安全设置 NSString对象

 @param value 设置的值
 @param key 设置的字典键
 @param block 完成后对结果进行处理的block
 @return 对value处理后返回的对象
 */
- (nullable id) ag_safeSetString:(nullable id)value forKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeSetCompletionBlock)block;

/**
 安全获取 NSString对象

 @param key 字典键
 @param block 完成后对结果进行处理的block
 @return NSString对象
 */
- (nullable NSString *) ag_safeStringForKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeGetCompletionBlock)block;


#pragma mark safe array
/**
 安全设置 NSArray对象
 
 @param key 字典键
 @return 对value处理后返回的对象
 */
- (nullable id) ag_safeSetArray:(nullable id)value forKey:(NSString *)key;
/**
 安全获取 NSArray对象
 
 @param key 字典键
 @return NSArray对象
 */
- (nullable NSArray *) ag_safeArrayForKey:(NSString *)key;

/**
 安全设置 NSArray对象
 
 @param value 设置的值
 @param key 设置的字典键
 @param block 完成后对结果进行处理的block
 @return 对value处理后返回的对象
 */
- (nullable id) ag_safeSetArray:(nullable id)value forKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeSetCompletionBlock)block;

/**
 安全获取 NSArray对象
 
 @param key 字典键
 @param block 完成后对结果进行处理的block
 @return NSArray对象
 */
- (nullable NSArray *) ag_safeArrayForKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeGetCompletionBlock)block;


#pragma mark safe dictionary
/**
 安全设置 NSDictionary对象
 
 @param key 字典键
 @return 对value处理后返回的对象
 */
- (nullable id) ag_safeSetDictionary:(nullable id)value forKey:(NSString *)key;
/**
 安全获取 NSDictionary对象
 
 @param key 字典键
 @return NSDictionary对象
 */
- (nullable NSDictionary *) ag_safeDictionaryForKey:(NSString *)key;

/**
 安全设置 NSDictionary对象
 
 @param value 设置的值
 @param key 设置的字典键
 @param block 完成后对结果进行处理的block
 @return 对value处理后返回的对象
 */
- (nullable id) ag_safeSetDictionary:(nullable id)value forKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeSetCompletionBlock)block;

/**
 安全获取 NSDictionary对象
 
 @param key 字典键
 @param block 完成后对结果进行处理的block
 @return NSDictionary对象
 */
- (nullable NSDictionary *) ag_safeDictionaryForKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeGetCompletionBlock)block;


#pragma mark safe url
/**
 安全获取 NSURL对象

 @param key 字典键
 @return NSURL对象
 */
- (nullable NSURL *) ag_safeURLForKey:(NSString *)key;
/**
 安全获取 NSURL对象

 @param key 字典键
 @param block 完成后对结果进行处理的block
 @return NSURL对象
 */
- (nullable NSURL *) ag_safeURLForKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeGetCompletionBlock)block;


#pragma mark safe value type
/**
 安全获取 double类型数据
 
 @param key 字典键
 @return double类型数据
 */
- (double) ag_safeDoubleValueForKey:(NSString *)key;
/**
 安全获取 double类型数据
 
 @param key 字典键
 @param block 完成后对结果进行处理的block
 @return double类型数据
 */
- (double) ag_safeDoubleValueForKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block;


/**
 安全获取 float类型数据
 
 @param key 字典键
 @return float类型数据
 */
- (float) ag_safeFloatValueForKey:(NSString *)key;
/**
 安全获取 float类型数据
 
 @param key 字典键
 @param block 完成后对结果进行处理的block
 @return float类型数据
 */
- (float) ag_safeFloatValueForKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block;


/**
 安全获取 int类型数据
 
 @param key 字典键
 @return int类型数据
 */
- (int) ag_safeIntValueForKey:(NSString *)key;
/**
 安全获取 int类型数据
 
 @param key 字典键
 @param block 完成后对结果进行处理的block
 @return int类型数据
 */
- (int) ag_safeIntValueForKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block;


/**
 安全获取 NSInteger类型数据
 
 @param key 字典键
 @return NSInteger类型数据
 */
- (NSInteger) ag_safeIntegerValueForKey:(NSString *)key;
/**
 安全获取 NSInteger类型数据
 
 @param key 字典键
 @param block 完成后对结果进行处理的block
 @return NSInteger类型数据
 */
- (NSInteger) ag_safeIntegerValueForKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block;


/**
 安全获取 long long类型数据
 
 @param key 字典键
 @return long long类型数据
 */
- (long long) ag_safeLongLongValueForKey:(NSString *)key;
/**
 安全获取 long long类型数据
 
 @param key 字典键
 @param block 完成后对结果进行处理的block
 @return long long类型数据
 */
- (long long) ag_safeLongLongValueForKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block;


/**
 安全获取 BOOL类型数据
 
 @param key 字典键
 @return BOOL类型数据
 */
- (BOOL) ag_safeBoolValueForKey:(NSString *)key;
/**
 安全获取 BOOL类型数据
 
 @param key 字典键
 @param block 完成后对结果进行处理的block
 @return BOOL类型数据
 */
- (BOOL) ag_safeBoolValueForKey:(NSString *)key completion:(nullable NS_NOESCAPE AGVMSafeGetNumberCompletionBlock)block;


@end


#endif /* AGVMProtocol_h */

NS_ASSUME_NONNULL_END
