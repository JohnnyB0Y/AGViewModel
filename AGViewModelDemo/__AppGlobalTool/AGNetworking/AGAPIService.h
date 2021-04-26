//
//  AGAPIService.h
//  
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

- (void) ag_registerAPIServiceForKey:(NSString *)key;
- (void) ag_registerAPIServiceForDefault;
+ (nullable AGAPIService *) ag_dequeueAPIServiceForKey:(NSString *)key;

/// 分页
- (nullable NSDictionary *) ag_pagedParamsForAPIManager:(AGAPIManager *)manager;
/// 是否最后一页？
- (BOOL) ag_isLastPagedForAPIManager:(AGAPIManager *)manager;

/// 校验HTTP状态码
- (AGVerifyError *) ag_verifyHTTPCode:(NSInteger)code forAPIManager:(AGAPIManager *)manager;

/// 全局错误，处理成功 返回 true 就不调用callback函数了，处理失败返回 false 继续往下走。
- (BOOL) ag_handleGlobalError:(NSError *)error forAPIManager:(AGAPIManager *)manager;

- (NSString *)ag_baseURL;

@end

NS_ASSUME_NONNULL_END
