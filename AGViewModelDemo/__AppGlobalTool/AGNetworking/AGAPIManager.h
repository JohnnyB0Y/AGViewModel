//
//  AGAPIManager.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2021/4/21.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGAPIProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGAPIManager : NSObject
<AGAPIInterceptor, AGAPIVerifier, AGAPIAssembly>

@property (nonatomic, copy, readonly) AGAPIManagerCallbackBlock callbackBlock;
@property (nonatomic, copy, readonly) AGAPIManagerParamsBlock paramsBlock;
@property (nonatomic, copy, readonly) NSDictionary *finalParams;

/// 回调状态
@property (nonatomic, assign) AGAPICallbackStatus status;

/// 正在加载？
@property (nonatomic, assign, readonly) BOOL isLoading;
@property (nonatomic, copy, nullable) NSNumber *requestId;
@property (nonatomic, strong, nullable, readonly) id rawData;
@property (nonatomic, strong, nullable, readonly) NSHTTPURLResponse *response;

#pragma 请求起飞
- (void) request;
- (void) requestWithCallback:(AGAPIManagerCallbackBlock)callback;
- (void) requestWithParams:(NSDictionary *)params callback:(AGAPIManagerCallbackBlock)callback;

/// 重试请求
- (void) retryRequest:(NSInteger)numberOfTry;

#pragma api hub 使用
- (void) requestWithAPISerialIterator:(AGAPIIterator *)itor params:(nullable NSDictionary *)params;
- (void) requestWithAPIGroupIterator:(AGAPIIterator *)itor;

#pragma 配置
- (void) configRequestCallback:(AGAPIManagerCallbackBlock)callback;
- (void) configRequestParams:(AGAPIManagerParamsBlock)params;

- (NSDictionary *) reformAPIParams:(NSDictionary *)params NS_REQUIRES_SUPER;

/// 添加数据校验器
- (void) useVerifier:(id<AGAPIVerifier>)verifier;
/// 添加生命周期观察者
- (void) useInterceptor:(id<AGAPIInterceptor>)interceptor;

#pragma override
- (NSString *)apiServiceKey;
- (AGAPIMethodType)apiMethodType;
- (NSString *)apiMethod;
- (NSString *)apiPath;

@end

NS_ASSUME_NONNULL_END