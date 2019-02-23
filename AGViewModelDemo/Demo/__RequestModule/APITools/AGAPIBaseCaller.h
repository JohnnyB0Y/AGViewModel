//
//  AGAPIBaseCaller
//
//  Created by JohnnyB0Y on 16/5/10.
//  Copyright © 2016年 JohnnyB0Y. All rights reserved.
//  通过派生子类来 管理整个模块的 APIManager。

#import "CTAPIBaseManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGAPIBaseCaller : NSObject

/** 网络是否可用 */
@property (nonatomic, assign, readonly, getter=isReachable) BOOL reachable;

/** API 回调代理 */
@property (nonatomic, weak, readonly) id<CTAPIManagerCallBackDelegate> apiCallBackDelegate;
/** API 参数代理 */
@property (nonatomic, weak, readonly) id<CTAPIManagerParamSource> apiParamDelegate;

/** 取消所有请求 ( 需要重写实现 ) */
- (void) cancelAllRequests;

// 快速初始化-直接指定代理
+ (instancetype) newWithAPIDelegate:(id<CTAPIManagerCallBackDelegate, CTAPIManagerParamSource>)delegate;
- (instancetype) initWithAPIDelegate:(id<CTAPIManagerCallBackDelegate, CTAPIManagerParamSource>)delegate;

@end

NS_ASSUME_NONNULL_END
