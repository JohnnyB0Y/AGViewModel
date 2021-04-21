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

@interface AGAPIManager ()

@property (nonatomic, copy) dispatch_block_t requestNext;
/// 重试次数
@property (nonatomic, assign) NSInteger numberOfTry;
/// 重试中？
@property (nonatomic, assign) NSInteger isRetrying;

@end

@implementation AGAPIManager

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
    
    AGAPIService *service = [AGAPIService dequeueAPIServiceForKey:[self apiServiceKey]];
    if (service == nil) {
        _status = AGAPICallbackStatusApiServiceUnregistered;
        _callbackBlock ? _callbackBlock(self, nil) : nil;
    }
    
    // 参数校验
    _finalParams = [self reformAPIParams:params];
    
    // 下一个
    if (itor && serial) {
        self.requestNext = ^() {
            [[itor nextAPIManager] requestWithAPISerialIterator:itor];
        };
    }
    
    // 发起请求
    __weak typeof(self) weakSelf = self;
    _isLoading = YES;
    [service.session callAPIForAPIManager:self options:nil callback:^(id  _Nullable data, NSError * _Nullable error) {
        __strong typeof(weakSelf) self = weakSelf;
        if (nil == self) return;
        self->_isLoading = NO;
        
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
        else {
            // 成功
            self.numberOfTry = 0;
            self.isRetrying = NO;
            [self _apiCallbackSuccess:AGAPICallbackStatusSuccess];
        }
        
        if (itor && serial == NO && self.isRetrying == NO) {
            // 完成一条，累加一次，检查一次
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

- (NSDictionary *)reformAPIParams:(NSDictionary *)params {
    NSMutableDictionary *paramsM = [NSMutableDictionary dictionaryWithDictionary:params];
    AGAPIService *service = [AGAPIService dequeueAPIServiceForKey:[self apiServiceKey]];
    [paramsM addEntriesFromDictionary:[service pagedParamsForAPIManager:self]];
    return paramsM;
}

- (NSString *)apiServiceKey {
    return @"kAGAPIServiceDefault";
}

- (AGAPIMethodType)apiMethod {
    return AGAPIMethodTypeGet;
}

- (NSString *)apiPath {
    return @"/";
}

#pragma mark - ---------- Private Methods ----------
- (void) _apiCallbackFailure:(AGAPICallbackStatus)status {
    self.status = status;
    self.callbackBlock(self, self.requestNext);
}

- (void) _apiCallbackSuccess:(AGAPICallbackStatus)status {
    self.status = status;
    self.callbackBlock(self, self.requestNext);
}

@end
