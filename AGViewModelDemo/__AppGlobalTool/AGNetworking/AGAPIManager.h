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

@property (nonatomic, copy, readonly) AGAPIManagerCallbackBlock callbackBlock;
@property (nonatomic, copy, readonly) AGAPIManagerParamsBlock paramsBlock;

/// 回调状态
@property (nonatomic, assign) AGAPICallbackStatus status;

#pragma 请求起飞
- (void) request;
- (void) requestWithCallback:(AGAPIManagerCallbackBlock)callback;
- (void) requestWithParams:(NSDictionary *)params callback:(AGAPIManagerCallbackBlock)callback;

#pragma hub 使用
- (void) requestWithAPISerialIterator:(AGAPIIterator *)itor;
- (void) requestWithAPIGroupIterator:(AGAPIIterator *)itor;

#pragma 配置
- (void) configRequestCallback:(AGAPIManagerCallbackBlock)callback;
- (void) configRequestParams:(AGAPIManagerParamsBlock)params;


#pragma override
- (NSString *)apiServiceKey;
- (AGAPIMethodType)apiMethod;
- (NSString *)apiPath;

@end

NS_ASSUME_NONNULL_END
