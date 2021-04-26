//
//  AGAPIManager.m
//  
//
//  Created by JohnnyB0Y on 2021/4/21.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import "AGAPIManager.h"
#import "AGAPIService.h"
#import "AGAPIHub.h"
#import <AGVerifyManager/AGVerifyManager.h>

@interface AGAPIManager ()

@property (nonatomic, copy) AGAPIRequestNextBlock requestNext;
/// 重试次数
@property (nonatomic, assign) NSInteger numberOfTry;
/// 重试中？
@property (nonatomic, assign) NSInteger isRetrying;
/// 错误
@property (nonatomic, strong, nullable) AGVerifyError *error;
/// 校验器集合
@property (nonatomic, strong) NSMutableSet<id<AGAPIVerifier>> *verifiers;

/// 生命周期观察者集合
@property (nonatomic, strong) NSMutableSet<id<AGAPIInterceptor>> *interceptors;

/// 取出的最终数据
@property (nonatomic, strong) id finalData;

- (void) ag_requestWithParams:(NSDictionary *)params
                     callback:(AGAPIManagerCallbackBlock)callback
                     iterator:(AGAPIIterator *)itor
                       serial:(BOOL)serial;

@end

@implementation AGAPIManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.verifiers addObject:self];
        [self.interceptors addObject:self];
    }
    return self;
}

#pragma mark - ---------- Public Methods ----------
#pragma 请求起飞
- (void) ag_request {
    [self ag_requestWithCallback:self.callbackBlock];
}
- (void) ag_requestWithCallback:(AGAPIManagerCallbackBlock)callback {
    NSDictionary *params = self.paramsBlock ? self.paramsBlock(self) : @{};
    [self ag_requestWithParams:params callback:callback];
}
- (void) ag_requestWithParams:(NSDictionary *)params {
    [self ag_requestWithParams:params callback:self.callbackBlock];
}
- (void) ag_requestWithParams:(NSDictionary *)params callback:(AGAPIManagerCallbackBlock)callback {
    [self ag_requestWithParams:params callback:callback iterator:nil serial:NO];
}
- (void) ag_requestWithParams:(NSDictionary *)params
                     callback:(AGAPIManagerCallbackBlock)callback
                     iterator:(AGAPIIterator *)itor
                       serial:(BOOL)serial {
    _callbackBlock = callback;
    
    if (self.isLoading) {
        [self _apiCallbackFailure:AGAPICallbackStatusRepetitionRequest];
        return;
    }
    
    // 启动服务
    if ([self service] == nil) {
        [self _apiCallbackFailure:AGAPICallbackStatusApiServiceUnregistered];
        return;
    }
    
    // 检测网络可用性
    
    
    // 参数校验
    _finalParams = [self ag_reformAPIParams:params];
    if ([self _verifyCallParams:_finalParams] == NO) {
        [self _apiCallbackFailure:AGAPICallbackStatusParamError];
        return;
    }
    
    // 请求起飞
    self.status = AGAPICallbackStatusBeforeCalling;
    if ([self _beforeCallingAPI:self] == NO) {
        if (self.status == AGAPICallbackStatusBeforeCalling) {
            [self _apiCallbackFailure:AGAPICallbackStatusInterceptedBeforeCalling];
        }
        return;
    }
    
    // 下一个
    if (itor && serial) {
        self.requestNext = ^(NSDictionary *params) {
            AGAPIManager *api = [itor ag_nextAPIManager];
            if (api) {
                [api ag_requestWithAPISerialIterator:itor params:params];
            }
            else if (itor.callbackBlock) { // 完成
                itor.callbackBlock(itor.apis, YES);
            }
        };
    }
    
    // 发起请求
    __weak typeof(self) weakSelf = self;
    _isLoading = YES;
    self.error = nil;
    [[self service].session ag_callAPIForAPIManager:self options:nil callback:^(id  _Nullable data, NSHTTPURLResponse *response, NSError * _Nullable error) {
        __strong typeof(weakSelf) self = weakSelf;
        if (nil == self) return;
        
        self->_isLoading = NO; // 请求落地
        self->_response = response;
        self->_rawData = data;
        self.status = AGAPICallbackStatusAfterCalling;
        
        if ([self _afterCallingAPI:self] == NO) {
            if (self.status == AGAPICallbackStatusAfterCalling) {
                [self _apiCallbackFailure:AGAPICallbackStatusInterceptedAfterCalling];
            }
            return;
        }
        
        if (error) { // 出错
            if (self.isRetrying) {
                if (--self.numberOfTry > 0) {
                    [self ag_retryRequest:self.numberOfTry];
                }
                else {
                    // ... 错误处理！！！！
                    self.isRetrying = NO;
                    [self _apiCallbackFailure:AGAPICallbackStatusFailure];
                }
            }
            else {
                // ... 错误处理！！！！
                [self _apiCallbackFailure:AGAPICallbackStatusFailure];
            }
        }
        else { // 成功
            self.numberOfTry = 0;
            self.isRetrying = NO;
            
            [self _beforeParseData:self]; // 开始解析数据
            
            if ([self _verifyHTTPCode:self.response.statusCode] == NO) {
                self.status = AGAPICallbackStatusHttpCodeError;
                if ([self _handleGlobalError:error] == NO) {
                    [self _apiCallbackFailure:self.status];
                }
            }
            else {
                self.finalData = [self ag_finalDataForAPIManager:self];
                if ([self _verifyCallbackData:self.finalData] == NO) { // 校验数据
                    if (self.status == AGAPICallbackStatusAfterCalling) {
                        self.status = AGAPICallbackStatusDataError;
                    }
                    if ([self _handleGlobalError:error] == NO) {
                        [self _apiCallbackFailure:self.status];
                    }
                }
                else {
                    [self _apiCallbackSuccess:AGAPICallbackStatusSuccess];
                }
            }
            
            [self _afterParseData:self]; // 结束解析数据
        }
        
        if (itor && serial == NO && self.isRetrying == NO) { // 完成一条，累加一次，检查一次
            [itor ag_finishedOneAPIAndCheckCallback];
        }
    }];
}

- (void)ag_requestWithAPISerialIterator:(AGAPIIterator *)itor params:(nullable NSDictionary *)params {
    NSMutableDictionary *paramsM = [NSMutableDictionary dictionaryWithDictionary:params];
    if (self.paramsBlock) {
        [paramsM addEntriesFromDictionary:self.paramsBlock(self)];
    }
    [self ag_requestWithParams:paramsM callback:self.callbackBlock iterator:itor serial:YES];
}

- (void)ag_requestWithAPIGroupIterator:(AGAPIIterator *)itor {
    NSDictionary *params = self.paramsBlock ? self.paramsBlock(self) : @{};
    [self ag_requestWithParams:params callback:self.callbackBlock iterator:itor serial:NO];
}

- (void)ag_retryRequest:(NSInteger)numberOfTry {
    if (self.isRetrying || self.isLoading) {
        [self _apiCallbackFailure:AGAPICallbackStatusRepetitionRequest];
        return;
    }
    self.numberOfTry = numberOfTry;
    self.isRetrying = YES;
    [self ag_request];
}

/// 取出整理后的数据
- (id) ag_fetchDataModel:(id<AGAPIReformer>)reformer options:(id)options {
    return [reformer ag_reformData:self.finalData options:options forAPIManager:self];
}
/// 取出整理后的数据列表
- (NSArray<id> *) ag_fetchDataModelList:(id<AGAPIReformer>)reformer options:(id)options {
    NSArray *models = [reformer ag_reformData:self.finalData options:options forAPIManager:self];
    if ([models isKindOfClass:[NSArray class]]) {
        return models;
    }
    return nil;
}

#pragma 配置
- (void) ag_configRequestCallback:(AGAPIManagerCallbackBlock)callback {
    _callbackBlock = callback;
}
- (void) ag_configRequestParams:(AGAPIManagerParamsBlock)params {
    _paramsBlock = params;
}

/// 添加数据校验器
- (void) ag_useVerifier:(id<AGAPIVerifier>)verifier {
    [self.verifiers addObject:verifier];
}
/// 添加生命周期观察者
- (void) ag_useInterceptor:(id<AGAPIInterceptor>)interceptor {
    [self.interceptors addObject:interceptor];
}

- (NSString *)ag_apiServiceKey {
    return @"kAGAPIServiceDefault";
}

- (AGAPIMethodType)ag_apiMethodType {
    return AGAPIMethodTypeGet;
}

- (NSString *)ag_apiMethod {
    switch ([self ag_apiMethodType]) {
        case AGAPIMethodTypeGet: {
            return @"GET";
        } break;
        case AGAPIMethodTypePost: {
            return @"POST";
        } break;
        case AGAPIMethodTypePut: {
            return @"PUT";
        } break;
        case AGAPIMethodTypeDelete: {
            return @"DELETE";
        } break;
        case AGAPIMethodTypeHead: {
            return @"HEAD";
        } break;
        case AGAPIMethodTypePatch: {
            return @"PATCH";
        } break;
    }
}

- (NSString *)ag_apiPath {
    [self doesNotRecognizeSelector:_cmd];
    return @"/";
}

/// 验证请求参数是否合规
- (AGVerifyError *)ag_verifyCallParams:(NSDictionary *)params forAPIManager:(AGAPIManager *)manager {
    return nil;
}

/// 验证回调数据是否合规
- (AGVerifyError *)ag_verifyCallbackData:(id)data forAPIManager:(AGAPIManager *)manager {
    return nil;
}

/// API起飞前, 返回值为false即打断请求
- (BOOL) ag_beforeCallingAPI:(AGAPIManager *)manager {
    return YES;
}

/// API落地后, 返回值为false即打断回调
- (BOOL) ag_afterCallingAPI:(AGAPIManager *)manager {
    return YES;
}

/// API解析数据前
- (void) ag_beforeParseData:(AGAPIManager *)manager {}

/// API解析数据后
- (void) ag_afterParseData:(AGAPIManager *)manager {}

/// API失败回调执行前，返回值为false即打断回调
- (BOOL) ag_beforePerformApiCallbackFailure:(AGAPIManager *)manager {
    return YES;
}

/// API失败回调执行后
- (void) ag_afterPerformApiCallbackFailure:(AGAPIManager *)manager {}

/// API成功回调执行前，返回值为false即打断回调
- (BOOL) ag_beforePerformApiCallbackSuccess:(AGAPIManager *)manager {
    return YES;
}

/// API成功回调执行后
- (void) ag_afterPerformApiCallbackSuccess:(AGAPIManager *)manager {}

- (NSDictionary *)ag_reformAPIParams:(NSDictionary *)params {
    NSMutableDictionary *paramsM = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramsM addEntriesFromDictionary:[[self service] commonParams]];
    return paramsM;
}

/// 处理HTTP状态码
- (AGVerifyError *) verifyHTTPCode:(NSInteger)code {
    return [[self service] ag_verifyHTTPCode:code forAPIManager:self];
}

/// 全局错误，处理成功 返回 true 就不调用callback函数了，处理失败返回 false 继续往下走。
- (BOOL) handleGlobalError:(NSError *)error {
    return [[self service] ag_handleGlobalError:error forAPIManager:self];
}

- (void)ag_cancelRequest {
    if (self.isLoading) {
        [[[self service] session] ag_cancelAPIForAPIManager:self options:nil];
        self.requestId = nil;
        self.status = AGAPICallbackStatusCancel;
        [self _afterCallingAPI:self];
        [self _apiCallbackFailure:AGAPICallbackStatusCancel];
    }
}

#pragma mark - ---------- AGAPIAssembly Methods ----------
- (NSInteger)ag_connectTimeout {
    return [[self service] ag_connectTimeout];
}

- (NSInteger)ag_receiveTimeout {
    return [[self service] ag_receiveTimeout];
}

- (NSURLRequest *)ag_urlRequestForAPIManager:(AGAPIManager *)manager {
    return [[self service] ag_urlRequestForAPIManager:manager];
}

- (id)ag_errorDataForAPIManager:(nonnull AGAPIManager *)manager {
    return [[self service] ag_errorDataForAPIManager:manager];
}

- (NSString *)ag_finalURL:(nonnull NSString *)baseURL apiPath:(nonnull NSString *)apiPath params:(nonnull NSDictionary *)params {
    return [[self service] ag_finalURL:baseURL apiPath:apiPath params:params];
}

- (id)ag_finalDataForAPIManager:(nonnull AGAPIManager *)manager {
    return [[self service] ag_finalDataForAPIManager:manager];
}

#pragma mark - ---------- Private Methods ----------
- (void) _apiCallbackFailure:(AGAPICallbackStatus)status {
    self.status = status;
    __block BOOL result = YES;
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(ag_beforePerformApiCallbackFailure:)] &&
            [obj ag_beforePerformApiCallbackFailure:self] == NO) {
            result = NO;
            *stop = YES;
        }
    }];
    
    if (result && self.callbackBlock) {
        self.callbackBlock(self, self.requestNext);
    }
    
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(ag_afterPerformApiCallbackFailure:)]) {
            [obj ag_afterPerformApiCallbackFailure:self];
        }
    }];
}

- (void) _apiCallbackSuccess:(AGAPICallbackStatus)status {
    self.status = status;
    __block BOOL result = YES;
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(ag_beforePerformApiCallbackSuccess:)] &&
            [obj ag_beforePerformApiCallbackSuccess:self] == NO) {
            result = NO;
            *stop = YES;
        }
    }];
    
    if (self.callbackBlock) {
        self.callbackBlock(self, self.requestNext);
    }
    
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(ag_afterPerformApiCallbackSuccess:)]) {
            [obj ag_afterPerformApiCallbackSuccess:self];
        }
    }];
}

- (BOOL) _beforeCallingAPI:(AGAPIManager *)manager {
    __block BOOL result = YES;
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(ag_beforeCallingAPI:)] &&
            [obj ag_beforeCallingAPI:manager] == NO) {
            result = NO;
            *stop = YES;
        }
    }];
    return result;
}

- (BOOL) _afterCallingAPI:(AGAPIManager *)manager {
    __block BOOL result = YES;
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(ag_afterCallingAPI:)] &&
            [obj ag_afterCallingAPI:manager] == NO) {
            result = NO;
            *stop = YES;
        }
    }];
    return result;
}

/// API解析数据前
- (void) _beforeParseData:(AGAPIManager *)manager {
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(ag_beforeParseData:)]) {
            [obj ag_beforeParseData:manager];
        }
    }];
}

/// API解析数据后
- (void) _afterParseData:(AGAPIManager *)manager {
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(ag_afterParseData:)]) {
            [obj ag_afterParseData:manager];
        }
    }];
}

#pragma ------------------- 参数与数据校验 ----------------------
- (BOOL) _verifyCallbackData:(id)data {
    __block BOOL result = YES;
    [_verifiers enumerateObjectsUsingBlock:^(id<AGAPIVerifier>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(ag_verifyCallbackData:forAPIManager:)]) {
            self.error = [obj ag_verifyCallbackData:data forAPIManager:self];
            if (self.error) {
                result = NO;
                *stop = YES;
            }
        }
    }];
    return result;
}

- (BOOL) _verifyCallParams:(NSDictionary *)params {
    __block BOOL result = YES;
    [_verifiers enumerateObjectsUsingBlock:^(id<AGAPIVerifier>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj respondsToSelector:@selector(ag_verifyCallParams:forAPIManager:)]) {
            self.error = [obj ag_verifyCallParams:params forAPIManager:self];
            if (self.error) {
                result = NO;
                *stop = YES;
            }
        }
    }];
    return result;
}

- (BOOL) _verifyHTTPCode:(NSInteger)code {
    return [self verifyHTTPCode:code];
}

- (BOOL) _handleGlobalError:(NSError *)error {
    return [self handleGlobalError:error];
}

#pragma mark - ----------- Getter Methods ----------
- (NSMutableSet<id<AGAPIVerifier>> *)verifiers
{
    if (_verifiers == nil) {
        _verifiers = [NSMutableSet set];
    }
    return _verifiers;
}

- (NSMutableSet<id<AGAPIInterceptor>> *)interceptors
{
    if (_interceptors == nil) {
        _interceptors = [NSMutableSet set];
    }
    return _interceptors;
}

- (AGAPIService *) service {
    return [AGAPIService ag_dequeueAPIServiceForKey:[self ag_apiServiceKey]];
}

@end

#pragma mark ------------ API分页控制
@interface AGAPIPagedManager ()

/// 每页大小
@property (nonatomic, assign) NSInteger pageSize;

/// 当前页码
@property (nonatomic, assign) NSInteger currentPage;

/// 首页？
@property (nonatomic, assign) BOOL isFirstPage;

/// 最后一页？
@property (nonatomic, assign) BOOL isLastPage;

@end

@implementation AGAPIPagedManager

- (void)requestWithParams:(NSDictionary *)params
                 callback:(AGAPIManagerCallbackBlock)callback
                 iterator:(AGAPIIterator *)itor
                   serial:(BOOL)serial {
    _isFirstPage = YES;
    _currentPage = 1;
    [super ag_requestWithParams:params callback:callback iterator:itor serial:serial];
}

- (void)ag_requestNextPageWithParams:(NSDictionary *)params {
    if (self.isLoading) {
        [self _apiCallbackFailure:AGAPICallbackStatusRepetitionRequest];
        return;
    }
    if (self.isLastPage) {
        [self _apiCallbackFailure:AGAPICallbackStatusLastPageError];
        return;
    }
    [super ag_requestWithParams:params];
}

- (void)ag_requestNextPage {
    [self ag_requestNextPageWithParams:@{}];
}

- (NSDictionary *)ag_reformAPIParams:(NSDictionary *)params {
    NSMutableDictionary *paramsM = [NSMutableDictionary dictionaryWithDictionary:params];
    [paramsM addEntriesFromDictionary:[self ag_pagedParamsForAPIManager:self]];
    return [super ag_reformAPIParams:paramsM];
}

- (BOOL)ag_beforePerformApiCallbackSuccess:(AGAPIManager *)manager {
    _isLastPage = [self ag_isLastPagedForAPIManager:manager];
    _isFirstPage = _currentPage == 1;
    if (_isLastPage == NO) {
        _currentPage++;
    }
    return [super ag_beforePerformApiCallbackSuccess:manager];
}

#pragma mark AGAPIPageable
- (BOOL)ag_isLastPagedForAPIManager:(nonnull AGAPIManager *)manager {
    return [[self service] ag_isLastPagedForAPIManager:manager];
}

- (nullable NSDictionary *)ag_pagedParamsForAPIManager:(nonnull AGAPIManager *)manager {
    return [[self service] ag_pagedParamsForAPIManager:manager];
}

@end
