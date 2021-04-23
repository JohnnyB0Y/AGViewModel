//
//  AGAPIService.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2021/4/21.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGAPIProtocol.h"

@class AGAPISessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface AGAPIService : NSObject
<AGAPIAssembly, AGAPIPageable>

/// api session
@property (nonatomic, strong, readonly) id<AGAPISessionProtocol> session;
/// api header
@property (nonatomic, strong, readonly) NSMutableDictionary *headers;
/// api common params
@property (nonatomic, strong, readonly) NSMutableDictionary *commonParams;
/// api environment
@property (nonatomic, assign) AGAPIEnvironment environment;


+ (instancetype) newWithAPISession:(id<AGAPISessionProtocol>)session;
- (instancetype) initWithAPISession:(id<AGAPISessionProtocol>)session;

- (void) registerAPIServiceForKey:(NSString *)key;
- (void) registerAPIServiceForDefault;
+ (nullable AGAPIService *) dequeueAPIServiceForKey:(NSString *)key;

/// 分页
- (nullable NSDictionary *) pagedParamsForAPIManager:(AGAPIManager *)manager;
/// 是否最后一页？
- (BOOL) isLastPagedForAPIManager:(AGAPIManager *)manager;

/// 校验HTTP状态码
- (AGVerifyError *) verifyHTTPCode:(NSInteger)code forAPIManager:(AGAPIManager *)manager;

/// 全局错误，处理成功 返回 true 就不调用callback函数了，处理失败返回 false 继续往下走。
- (BOOL) handleGlobalError:(NSError *)error forAPIManager:(AGAPIManager *)manager;

- (NSString *)baseURL;

@end

NS_ASSUME_NONNULL_END
