//
//  AGTaobaoAPIService.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2021/5/6.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import "AGTaobaoAPIService.h"
#import "AGAPIManager.h"
#import <AGVerifyManager/AGVerifyManager.h>

@implementation AGTaobaoAPIService

/// 分页
- (NSDictionary *)ag_pagedParamsForAPIManager:(AGAPIManager *)manager {
    return nil;
}

- (BOOL)ag_isLastPagedForAPIManager:(AGAPIManager *)manager {
    return NO;
}

/// 校验HTTP状态码
- (AGVerifyError *) ag_verifyHTTPCode:(NSInteger)code forAPIManager:(AGAPIManager *)manager {
    if (code != 200) {
        return [[AGVerifyError alloc] init].setCode(0).setMsg(@"请求错误");
    }
    return nil;
}

/// 全局错误，处理成功 返回 true 就不调用callback函数了，处理失败返回 false 继续往下走。
- (BOOL) ag_handleGlobalError:(NSError *)error forAPIManager:(AGAPIManager *)manager {
    if (error) {
        return NO;
    }
    return YES;
}

- (NSString *)ag_baseURL {
    if (self.environment == AGAPIEnvironmentDevelop) {
        // 开发环境
        return @"https://suggest.taobao.com/";
    }
    else if (self.environment == AGAPIEnvironmentReleaseCandidate) {
        // 预发布环境
        return @"https://suggest.taobao.com/";
    }
    // 生产环境
    return @"https://suggest.taobao.com/";
}

- (NSInteger)ag_connectTimeout {
    return 15;
}

- (NSInteger)ag_receiveTimeout {
    return 15;
}

- (id)ag_errorDataForAPIManager:(nonnull AGAPIManager *)manager {
    // 统一的错误处理
    return nil;
}

@end
