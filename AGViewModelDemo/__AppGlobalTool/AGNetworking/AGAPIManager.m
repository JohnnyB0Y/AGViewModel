//
//  AGAPIManager.m
//  AGViewModelDemo
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
- (void) request {
    [self requestWithCallback:self.callbackBlock];
}
- (void) requestWithCallback:(AGAPIManagerCallbackBlock)callback {
    NSDictionary *params = self.paramsBlock ? self.paramsBlock(self) : @{};
    [self requestWithParams:params callback:callback];
}
- (void) requestWithParams:(NSDictionary *)params callback:(AGAPIManagerCallbackBlock)callback {
    [self requestWithParams:params callback:callback iterator:nil serial:NO];
}
- (void) requestWithParams:(NSDictionary *)params
                  callback:(AGAPIManagerCallbackBlock)callback
                  iterator:(AGAPIIterator *)itor
                    serial:(BOOL)serial {
    _callbackBlock = callback;
    
    if (self.isLoading) {
        [self _apiCallbackFailure:AGAPICallbackStatusRepetitionRequest];
        return;
    }
    
    // 启动服务
    AGAPIService *service = [AGAPIService dequeueAPIServiceForKey:[self apiServiceKey]];
    if (service == nil) {
        [self _apiCallbackFailure:AGAPICallbackStatusApiServiceUnregistered];
        return;
    }
    
    // 检测网络可用性
    
    
    // 参数校验
    _finalParams = [self reformAPIParams:params];
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
            AGAPIManager *api = [itor nextAPIManager];
            if (api) {
                [api requestWithAPISerialIterator:itor params:params];
            }
            else if (itor.callbackBlock) { // 完成
                itor.callbackBlock(itor.apis, YES);
            }
        };
    }
    
    // 发起请求
    __weak typeof(self) weakSelf = self;
    _isLoading = YES;
    [service.session callAPIForAPIManager:self options:nil callback:^(id  _Nullable data, NSHTTPURLResponse *response, NSError * _Nullable error) {
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
                    [self retryRequest:self.numberOfTry];
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
                self.finalData = [self finalDataForAPIManager:self];
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
            [itor finishedOneAPIAndCheckCallback];
        }
    }];
}

- (void)requestWithAPISerialIterator:(AGAPIIterator *)itor {
    NSDictionary *params = self.paramsBlock ? self.paramsBlock(self) : @{};
    [self requestWithParams:params callback:self.callbackBlock iterator:itor serial:YES];
}

- (void)requestWithAPIGroupIterator:(AGAPIIterator *)itor {
    NSDictionary *params = self.paramsBlock ? self.paramsBlock(self) : @{};
    [self requestWithParams:params callback:self.callbackBlock iterator:itor serial:NO];
}

- (void)retryRequest:(NSInteger)numberOfTry {
    if (self.isRetrying || self.isLoading) {
        [self _apiCallbackFailure:AGAPICallbackStatusRepetitionRequest];
        return;
    }
    self.numberOfTry = numberOfTry;
    self.isRetrying = YES;
    [self request];
}

#pragma 配置
- (void) configRequestCallback:(AGAPIManagerCallbackBlock)callback {
    _callbackBlock = callback;
}
- (void) configRequestParams:(AGAPIManagerParamsBlock)params {
    _paramsBlock = params;
}

/// 添加数据校验器
- (void) useVerifier:(id<AGAPIVerifier>)verifier {
    [self.verifiers addObject:verifier];
}
/// 添加生命周期观察者
- (void) useInterceptor:(id<AGAPIInterceptor>)interceptor {
    [self.interceptors addObject:interceptor];
}

- (NSString *)apiServiceKey {
    return @"kAGAPIServiceDefault";
}

- (AGAPIMethodType)apiMethodType {
    return AGAPIMethodTypeGet;
}

- (NSString *)apiMethod {
    switch ([self apiMethodType]) {
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

- (NSString *)apiPath {
    return @"/";
}

/// 验证请求参数是否合规
- (AGVerifyError *)verifyCallParamsForAPIManager:(AGAPIManager *)manager params:(NSDictionary *)params {
    return nil;
}

/// 验证回调数据是否合规
- (AGVerifyError *)verifyCallbackDataForAPIManager:(AGAPIManager *)manager data:(id)data {
    return nil;
}

/// API起飞前, 返回值为false即打断请求
- (BOOL) beforeCallingAPI:(AGAPIManager *)manager {
    return YES;
}

/// API落地后, 返回值为false即打断回调
- (BOOL) afterCallingAPI:(AGAPIManager *)manager {
    return YES;
}

/// API解析数据前
- (void) beforeParseData:(AGAPIManager *)manager {}

/// API解析数据后
- (void) afterParseData:(AGAPIManager *)manager {}

/// API失败回调执行前，返回值为false即打断回调
- (BOOL) beforePerformApiCallbackFailure:(AGAPIManager *)manager {
    return YES;
}

/// API失败回调执行后
- (void) afterPerformApiCallbackFailure:(AGAPIManager *)manager {}

/// API成功回调执行前，返回值为false即打断回调
- (BOOL) beforePerformApiCallbackSuccess:(AGAPIManager *)manager {
    return YES;
}

/// API成功回调执行后
- (void) afterPerformApiCallbackSuccess:(AGAPIManager *)manager {}

- (NSDictionary *)reformAPIParams:(NSDictionary *)params {
    NSMutableDictionary *paramsM = [NSMutableDictionary dictionaryWithDictionary:params];
    AGAPIService *service = [AGAPIService dequeueAPIServiceForKey:[self apiServiceKey]];
    [paramsM addEntriesFromDictionary:[service pagedParamsForAPIManager:self]];
    [paramsM addEntriesFromDictionary:[service commonParams]];
    return paramsM;
}

/// 处理HTTP状态码
- (AGVerifyError *) verifyHTTPCode:(NSInteger)code {
    return [[self service] verifyHTTPCode:code forAPIManager:self];
}

/// 全局错误，处理成功 返回 true 就不调用callback函数了，处理失败返回 false 继续往下走。
- (BOOL) handleGlobalError:(NSError *)error {
    return [[self service] handleGlobalError:error forAPIManager:self];
}

- (void)cancelRequest {
    if (self.isLoading) {
        [[[self service] session] cancelAPIForAPIManager:self options:nil];
        self.requestId = nil;
        [self _afterCallingAPI:self];
        [self _apiCallbackFailure:AGAPICallbackStatusCancel];
    }
}

#pragma mark - ---------- AGAPIAssembly Methods ----------
- (NSInteger)connectTimeout {
    return [[self service] connectTimeout];
}

- (NSInteger)receiveTimeout {
    return [[self service] receiveTimeout];
}

- (NSURLRequest *)requestForAPIManager:(AGAPIManager *)manager {
    return [[self service] requestForAPIManager:manager];
}

- (id)errorDataForAPIManager:(nonnull AGAPIManager *)manager {
    return [[self service] errorDataForAPIManager:manager];
}

- (NSString *)finalURL:(nonnull NSString *)baseURL apiPath:(nonnull NSString *)apiPath params:(nonnull NSDictionary *)params {
    return [[self service] finalURL:baseURL apiPath:apiPath params:params];
}

- (id)finalDataForAPIManager:(nonnull AGAPIManager *)manager {
    return [[self service] finalDataForAPIManager:manager];
}

#pragma mark - ---------- Private Methods ----------
- (void) _apiCallbackFailure:(AGAPICallbackStatus)status {
    self.status = status;
    __block BOOL result = YES;
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj beforePerformApiCallbackFailure:self] == NO) {
            result = NO;
            *stop = YES;
        }
    }];
    
    if (result && self.callbackBlock) {
        self.callbackBlock(self, self.requestNext);
    }
    
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj afterPerformApiCallbackFailure:self];
    }];
}

- (void) _apiCallbackSuccess:(AGAPICallbackStatus)status {
    self.status = status;
    __block BOOL result = YES;
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj beforePerformApiCallbackSuccess:self] == NO) {
            result = NO;
            *stop = YES;
        }
    }];
    
    if (self.callbackBlock) {
        self.callbackBlock(self, self.requestNext);
    }
    
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj afterPerformApiCallbackSuccess:self];
    }];
}

- (BOOL) _beforeCallingAPI:(AGAPIManager *)manager {
    __block BOOL result = YES;
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj beforeCallingAPI:manager] == NO) {
            result = NO;
            *stop = YES;
        }
    }];
    return result;
}

- (BOOL) _afterCallingAPI:(AGAPIManager *)manager {
    __block BOOL result = YES;
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj afterCallingAPI:manager] == NO) {
            result = NO;
            *stop = YES;
        }
    }];
    return result;
}

/// API解析数据前
- (void) _beforeParseData:(AGAPIManager *)manager {
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj beforeParseData:manager];
    }];
}

/// API解析数据后
- (void) _afterParseData:(AGAPIManager *)manager {
    [_interceptors enumerateObjectsUsingBlock:^(id<AGAPIInterceptor>  _Nonnull obj, BOOL * _Nonnull stop) {
        [obj afterParseData:manager];
    }];
}

- (BOOL) _verifyCallbackData:(id)data {
    __block BOOL result = YES;
    [_verifiers enumerateObjectsUsingBlock:^(id<AGAPIVerifier>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj verifyCallbackDataForAPIManager:self data:data] == NO) {
            result = NO;
            *stop = YES;
        }
    }];
    return result;
}

- (BOOL) _verifyCallParams:(NSDictionary *)params {
    __block BOOL result = YES;
    [_verifiers enumerateObjectsUsingBlock:^(id<AGAPIVerifier>  _Nonnull obj, BOOL * _Nonnull stop) {
        if ([obj verifyCallParamsForAPIManager:self params:params] == NO) {
            result = NO;
            *stop = YES;
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
    return [AGAPIService dequeueAPIServiceForKey:[self apiServiceKey]];
}

@end
