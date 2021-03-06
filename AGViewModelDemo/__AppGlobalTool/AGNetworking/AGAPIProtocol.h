//
//  AGAPIProtocol.h
//
//
//  Created by JohnnyB0Y on 2021/4/21.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#ifndef AGAPIProtocol_h
#define AGAPIProtocol_h

@class AGAPIManager, AGAPIIterator, AGVerifyError;

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, AGAPIEnvironment) {
    AGAPIEnvironmentDevelop, ///< 开发环境
    AGAPIEnvironmentReleaseCandidate,  ///< 预发布环境
    AGAPIEnvironmentRelease, ///< 生产环境
};

typedef NS_ENUM(NSUInteger, AGAPIConnectivityStatus) {
    AGAPIConnectivityStatusWifi, ///< WiFi: Device connected via Wi-Fi
    AGAPIConnectivityStatusMobile,  ///< Mobile: Device connected to cellular network
    AGAPIConnectivityStatusNone, ///< None: Device not connected to any network
};

typedef NS_ENUM(NSUInteger, AGAPIMethodType) {
    AGAPIMethodTypeGet,
    AGAPIMethodTypePost,
    AGAPIMethodTypePut,
    AGAPIMethodTypeDelete,
    AGAPIMethodTypeHead,
    AGAPIMethodTypePatch,
};

typedef NS_ENUM(NSUInteger, AGAPICallbackStatus) {
    AGAPICallbackStatusNone, // 什么也没有发生，默认状态
    AGAPICallbackStatusSuccess, // 成功
    AGAPICallbackStatusFailure, // 失败，比较笼统
    AGAPICallbackStatusTimeout, // 请求超时
    AGAPICallbackStatusCancel, // 用户取消
    AGAPICallbackStatusBadRequest, // 无效请求：400
    AGAPICallbackStatusUnauthorized, // 请求不包含身份验证令牌或身份验证令牌已过期：401
    AGAPICallbackStatusForbidden, // 客户端没有访问所请求资源的权限：403
    AGAPICallbackStatusNotFound, // 未找到请求的资源：404，例如用户不存在，资源不存在
    AGAPICallbackStatusDenied, // 拒绝访问：409，例如，重复发送验证码被拒绝
    AGAPICallbackStatusApiServiceUnregistered, // APIService 未注册到API类
    AGAPICallbackStatusRepetitionRequest, // API正在loading，重复请求
    AGAPICallbackStatusBeforeCalling, // 状态，开始请求前
    AGAPICallbackStatusInterceptedBeforeCalling, // 调用前网络请求被拦截
    AGAPICallbackStatusAfterCalling, // 状态，请求完成后
    AGAPICallbackStatusInterceptedAfterCalling, // 调用后网络请求被拦截
    AGAPICallbackStatusHttpCodeError, // http code 校验错误
    AGAPICallbackStatusDataError, // 数据错误 or 数据格式错误
    AGAPICallbackStatusParamError, // 参数错误
    AGAPICallbackStatusReformerDataError, // 过滤数据出错
    AGAPICallbackStatusNetworkError, // 网络连接问题
    AGAPICallbackStatusServerError, // 服务端未知错误：500
    AGAPICallbackStatusLastPageError, // 已经是最后一页的数据，无法加载更多数据
    AGAPICallbackStatusExceptionError, // 程序错误，抛异常
};

typedef void(^AGAPIRequestNextBlock)(NSDictionary * _Nullable params);

typedef void (^AGAPICallbackBlock)
(
    id _Nullable data,
    NSHTTPURLResponse * _Nullable response,
    NSError * _Nullable error
);

typedef void (^AGAPIHandleBlock)
(
    id _Nullable data,
    NSError * _Nullable error
);

typedef void (^AGAPIManagerCallbackBlock)
(
    AGAPIManager *manager,
    _Nullable AGAPIRequestNextBlock requestNext
);

typedef void (^AGAPIManagerGroupCallbackBlock)
(
    NSArray<AGAPIManager *> *apis,
    BOOL allSuccess
);

typedef NSDictionary * _Nonnull (^AGAPIManagerParamsBlock)
(
    AGAPIManager *manager
);

@protocol AGAPIAssembly <NSObject>

- (nullable id) ag_finalDataForAPIManager:(AGAPIManager *)manager;
- (nullable id) ag_errorDataForAPIManager:(AGAPIManager *)manager;

- (NSURLRequest *) ag_urlRequestForAPIManager:(AGAPIManager *)manager;

- (NSString *) ag_finalURL:(NSString *)baseURL apiPath:(NSString *)apiPath params:(NSDictionary *)params;

- (NSInteger) ag_connectTimeout;
- (NSInteger) ag_receiveTimeout;

@end

@protocol AGAPIPageable <NSObject>

/// 分页
- (nullable NSDictionary *) ag_pagedParamsForAPIManager:(AGAPIManager *)manager;

/// 是否最后一页？
- (BOOL) ag_isLastPagedForAPIManager:(AGAPIManager *)manager;

@end

@protocol AGAPIVerifier <NSObject>

/// 验证回调数据是否合规
- (nullable AGVerifyError *) ag_verifyCallbackData:(id)data forAPIManager:(AGAPIManager *)manager;

/// 验证请求参数是否合规
- (nullable AGVerifyError *) ag_verifyCallParams:(NSDictionary *)params forAPIManager:(AGAPIManager *)manager;

@end

@protocol AGAPIInterceptor <NSObject>
@optional
/// API起飞前, 返回值为false即打断请求
- (BOOL) ag_beforeCallingAPI:(AGAPIManager *)manager;

/// API落地后, 返回值为false即打断回调
- (BOOL) ag_afterCallingAPI:(AGAPIManager *)manager;

/// API解析数据前
- (void) ag_beforeParseData:(AGAPIManager *)manager;

/// API解析数据后
- (void) ag_afterParseData:(AGAPIManager *)manager;

/// API失败回调执行前，返回值为false即打断回调
- (BOOL) ag_beforePerformApiCallbackFailure:(AGAPIManager *)manager;

/// API失败回调执行后
- (void) ag_afterPerformApiCallbackFailure:(AGAPIManager *)manager;

/// API成功回调执行前，返回值为false即打断回调
- (BOOL) ag_beforePerformApiCallbackSuccess:(AGAPIManager *)manager;

/// API成功回调执行后
- (void) ag_afterPerformApiCallbackSuccess:(AGAPIManager *)manager;

@end

@protocol AGAPIReformer <NSObject>
- (id) ag_reformData:(nullable id)data options:(nullable id)options forAPIManager:(AGAPIManager *)manager;
@end

@protocol AGAPISessionProtocol <NSObject>

/// 发起API请求
- (void) ag_callAPIForAPIManager:(AGAPIManager *)manager
                         options:(nullable id)options
                        callback:(nullable AGAPICallbackBlock)callback;

/// 取消请求
- (void) ag_cancelAPIForAPIManager:(AGAPIManager *)manager
                           options:(nullable id)options;

/// 删除缓存
- (void) ag_deleteCacheForAPIManager:(AGAPIManager *)manager
                             options:(nullable id)options
                            callback:(nullable AGAPIHandleBlock)callback;

/// 删除所有缓存
- (void) ag_deleteAllCache:(nullable AGAPIManager *)manager
                   options:(nullable id)options
                  callback:(nullable AGAPIHandleBlock)callback;

@end

NS_ASSUME_NONNULL_END

#endif /* AGDefine_h */
