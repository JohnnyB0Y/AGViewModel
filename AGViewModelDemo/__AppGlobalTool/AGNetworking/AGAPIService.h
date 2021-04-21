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

/// api session
@property (nonatomic, strong, readonly) id<AGAPISessionProtocol> session;

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
- (BOOL) handleGlobalError:(AGVerifyError *)error forAPIManager:(AGAPIManager *)manager;

@end

NS_ASSUME_NONNULL_END
