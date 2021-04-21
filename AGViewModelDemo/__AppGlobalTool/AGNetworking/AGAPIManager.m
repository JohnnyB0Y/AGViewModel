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

//@interface AGAPIManager ()
//
//
//
//@end

@implementation AGAPIManager

#pragma 请求起飞
- (void) request {
    [self requestWithCallback:self.callbackBlock];
}
- (void) requestWithCallback:(AGAPIManagerCallbackBlock)callback {
    NSDictionary *params = self.paramsBlock ? self.paramsBlock(self) : @{};
    [self requestWithParams:params callback:self.callbackBlock];
}
- (void) requestWithParams:(NSDictionary *)params callback:(AGAPIManagerCallbackBlock)callback {
    [self requestWithParams:params callback:callback iterator:nil serial:NO];
}
- (void) requestWithParams:(NSDictionary *)params
                  callback:(AGAPIManagerCallbackBlock)callback
                  iterator:(AGAPIIterator *)itor
                    serial:(BOOL)serial {
    _callbackBlock = callback;
    
    AGAPIService *service = [AGAPIService dequeueAPIServiceForKey:[self apiServiceKey]];
    if (service == nil) {
        _status = AGAPICallbackStatusApiServiceUnregistered;
        _callbackBlock ? _callbackBlock(self, nil) : nil;
    }
    
    // 参数校验
    
    // 发起请求
    __weak typeof(self) weakSelf = self;
    [service.session callAPIForAPIManager:self options:nil callback:^(id  _Nullable data, NSError * _Nullable error) {
        __strong typeof(weakSelf) self = weakSelf;
        if (nil == self) return;
        
        void(^next)() = nil;
        if (itor && serial) {
            next = ^() {
                [[itor nextAPIManager] requestWithAPISerialIterator:itor];
            };
        }
        
        if (error) {
            // 出错
            // ... 错误处理！！！！
            self.callbackBlock(self, next);
        }
        else {
            // 成功
            self.status = AGAPICallbackStatusSuccess;
            self.callbackBlock(self, next);
        }
        
        if (itor && serial == NO) {
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

#pragma 配置
- (void) configRequestCallback:(AGAPIManagerCallbackBlock)callback {
    _callbackBlock = callback;
}
- (void) configRequestParams:(AGAPIManagerParamsBlock)params {
    _paramsBlock = params;
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

@end
