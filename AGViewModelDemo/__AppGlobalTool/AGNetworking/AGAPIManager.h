//
//  AGAPIManager.h
//  
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
- (void) ag_request;
- (void) ag_requestWithCallback:(AGAPIManagerCallbackBlock)callback;
- (void) ag_requestWithParams:(NSDictionary *)params;
- (void) ag_requestWithParams:(NSDictionary *)params callback:(AGAPIManagerCallbackBlock)callback;

- (void) ag_cancelRequest;

/// 重试请求
- (void) ag_retryRequest:(NSInteger)numberOfTry;

/// 取出整理后的数据
- (nullable id) ag_fetchDataModel:(id<AGAPIReformer>)reformer options:(nullable id)options;
/// 取出整理后的数据列表
- (nullable NSArray<id> *) ag_fetchDataModelList:(id<AGAPIReformer>)reformer options:(nullable id)options;

#pragma api hub 使用
- (void) ag_requestWithAPISerialIterator:(AGAPIIterator *)itor params:(nullable NSDictionary *)params;
- (void) ag_requestWithAPIGroupIterator:(AGAPIIterator *)itor;

#pragma 配置
- (void) ag_configRequestCallback:(AGAPIManagerCallbackBlock)callback;
- (void) ag_configRequestParams:(AGAPIManagerParamsBlock)params;

- (NSDictionary *) ag_reformAPIParams:(NSDictionary *)params NS_REQUIRES_SUPER;

/// 添加数据校验器
- (void) ag_useVerifier:(id<AGAPIVerifier>)verifier;
/// 添加生命周期观察者
- (void) ag_useInterceptor:(id<AGAPIInterceptor>)interceptor;

#pragma override
- (NSString *)ag_apiServiceKey;
- (AGAPIMethodType)ag_apiMethodType;
- (NSString *)ag_apiMethod;
- (NSString *)ag_apiPath;

@end

@interface AGAPIPagedManager : AGAPIManager
<AGAPIPageable>

/// 请求下一页数据
- (void)ag_requestNextPage;
- (void)ag_requestNextPageWithParams:(NSDictionary *)params;

@end

NS_ASSUME_NONNULL_END
