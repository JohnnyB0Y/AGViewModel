//
//  AGViewModel.h
//  Architecture
//
//  Created by JohnnyB0Y on 2017/4/23.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  视图-模型 绑定

#import <UIKit/UIKit.h>
#import "AGVMKeys.h"
#import "AGVMProtocol.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark - interface
@interface AGViewModel : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, weak,   readonly, nullable) UIView<AGVMIncludable> *bindingView;
@property (nonatomic, strong, readonly) NSMutableDictionary *bindingModel;

@property (nonatomic, weak, nullable) id<AGVMDelegate> delegate;
@property (nonatomic, copy, nullable) NSIndexPath *indexPath;

#pragma mark 设置绑定视图
/** 自定义更新绑定视图 */
- (void) ag_setBindingView:(UIView<AGVMIncludable> *)bindingView
           configDataBlock:(nullable AGVMConfigDataBlock)configDataBlock;

/** 默认更新绑定视图（ 其实就是调用 bindingView 的 @selector(setViewModel:) 方法 ）*/
- (void) ag_setBindingView:(nullable UIView<AGVMIncludable> *)bindingView;

#pragma mark 设置绑定代理
/** 设置代理 */
- (void) ag_setDelegate:(nullable id<AGVMDelegate>)delegate
           forIndexPath:(nullable NSIndexPath *)indexPath;


#pragma mark 绑定视图后，可以让视图做一些事情
/** 获取 bindingView 的 size */
- (CGSize) ag_sizeOfBindingView;

/** 当 bindingView 为空时，直接传进去计算 size */
- (CGSize) ag_sizeOfBindingView:(UIView<AGVMIncludable> *)bv;

/** 预先计算 size */
- (void) ag_precomputedSizeOfBindingView:(UIView<AGVMIncludable> *)bv;


#pragma mark 通知 delegate 根据信息或类型做某事（ 让 view 传递信息给 controller ）
- (void) ag_callDelegateToDoForInfo:(nullable NSDictionary *)info;
- (void) ag_callDelegateToDoForViewModel:(nullable AGViewModel *)info;
- (void) ag_callDelegateToDoForAction:(nullable SEL)action;
- (void) ag_callDelegateToDoForAction:(nullable SEL)action info:(nullable AGViewModel *)info;


#pragma mark 快速初始化实例
/**
 通过 capacity 创建内部数据字典
 然后合并传入的数据字典快速初始化 viewModel 实例
 
 @param bindingModel 数据字典
 @param capacity 数据字典每次增量拷贝的内存大小
 @return viewModel 对象
 */
+ (instancetype) newWithModel:(nullable NSDictionary *)bindingModel
                     capacity:(NSUInteger)capacity;

/**
 通过拷贝数据字典快速初始化 viewModel 实例
 如果 bindingModel 为 nil, 创建 capacity 为 6 的内部数据字典

 @param bindingModel 数据字典
 @return viewModel 对象
 */
+ (instancetype) newWithModel:(nullable NSDictionary *)bindingModel;
- (instancetype) initWithModel:(NSMutableDictionary *)bindingModel NS_DESIGNATED_INITIALIZER;


#pragma mark 辅助方法
/** 取 bindingModel 数据 */
- (id) objectForKeyedSubscript:(NSString *)key;

/** 更新数据 并 刷新视图 */
- (void) ag_refreshUIByUpdateModelInBlock:(nullable NS_NOESCAPE AGVMUpdateModelBlock)block;
- (void) setObject:(nullable id)obj forKeyedSubscript:(NSString *)key;

/**
 合并包含 keys 的模型数据

 @param dict 待合并的字典
 @param keys 要合并数据的keys
 */
- (void) ag_mergeModelFromDictionary:(NSDictionary *)dict byKeys:(NSArray<NSString *> *)keys;
- (void) ag_mergeModelFromViewModel:(AGViewModel *)vm byKeys:(NSArray<NSString *> *)keys;

- (void) ag_mergeModelFromViewModel:(AGViewModel *)vm;
- (void) ag_mergeModelFromDictionary:(NSDictionary *)dict;


- (instancetype) init NS_UNAVAILABLE;
+ (instancetype) new NS_UNAVAILABLE;

@end

#pragma mark - 安全存取
@interface AGViewModel (AGVMSafeAccessible) <AGVMSafeAccessible>
@end

#pragma mark - 键值观察
@interface AGViewModel (AGVMObserverRegistration) <AGVMObserverRegistration>
@end

#pragma mark - 数据转换
@interface AGViewModel (AGVMJSONTransformable) <AGVMJSONTransformable>
@end

NS_ASSUME_NONNULL_END


