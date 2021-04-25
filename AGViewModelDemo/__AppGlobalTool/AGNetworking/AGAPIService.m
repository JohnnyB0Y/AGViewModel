//
//  AGAPIService.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2021/4/21.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import "AGAPIService.h"
#import "AGAPIManager.h"

static NSMutableDictionary *apiServices = nil;

@interface AGAPIService ()
/// api header
@property (nonatomic, strong, readwrite) NSMutableDictionary *headers;
/// api common params
@property (nonatomic, strong, readwrite) NSMutableDictionary *commonParams;
@end

@implementation AGAPIService

+ (instancetype)newWithAPISession:(id<AGAPISessionProtocol>)session {
    return [[self alloc] initWithAPISession:session];
}

- (instancetype)initWithAPISession:(id<AGAPISessionProtocol>)session {
    self = [self init];
    if (self) {
        _session = session;
        apiServices = [NSMutableDictionary dictionaryWithCapacity:3];
    }
    return self;
}

- (void) ag_registerAPIServiceForKey:(NSString *)key {
    [apiServices setValue:self forKey:key];
}
- (void) ag_registerAPIServiceForDefault {
    [self ag_registerAPIServiceForKey:@"kAGAPIServiceDefault"];
}

+ (AGAPIService *)ag_dequeueAPIServiceForKey:(NSString *)key {
    return apiServices[key];
}

/// 分页
- (NSDictionary *)ag_pagedParamsForAPIManager:(AGAPIManager *)manager {
    return nil;
}

- (BOOL)ag_isLastPagedForAPIManager:(AGAPIManager *)manager {
    return NO;
}

/// 校验HTTP状态码
- (AGVerifyError *) ag_verifyHTTPCode:(NSInteger)code forAPIManager:(AGAPIManager *)manager {
    return nil;
}

/// 全局错误，处理成功 返回 true 就不调用callback函数了，处理失败返回 false 继续往下走。
- (BOOL) ag_handleGlobalError:(NSError *)error forAPIManager:(AGAPIManager *)manager {
    return  NO;
}

- (NSString *)ag_baseURL {
    return nil;
}

- (NSInteger)ag_connectTimeout {
    return 15;
}

- (NSInteger)ag_receiveTimeout {
    return 15;
}

- (id)ag_errorDataForAPIManager:(nonnull AGAPIManager *)manager {
    return nil;
}

- (NSString *)ag_finalURL:(nonnull NSString *)baseURL apiPath:(nonnull NSString *)apiPath params:(nonnull NSDictionary *)params {
    NSMutableString *finalURL = [NSMutableString stringWithFormat:@"%@%@", baseURL, apiPath];
    
    if (params.count > 0) {
        [finalURL appendString:@"?"];
        __block NSInteger i = 0;
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if (i == 0) {
                [finalURL appendFormat:@"%@=%@", key, obj];
            }
            else {
                [finalURL appendFormat:@"&%@=%@", key, obj];
            }
        }];
    }
    return finalURL;
}

- (id)ag_finalDataForAPIManager:(nonnull AGAPIManager *)manager {
    if ([manager.rawData isKindOfClass:[NSDictionary class]] || [manager.rawData isKindOfClass:[NSArray class]]) {
        return manager.rawData;
    }
    else if ([manager.rawData isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:manager.rawData options:0 error:NULL];
    }
    else if ([manager.rawData isKindOfClass:[NSString class]]) {
        NSData *data = [manager.rawData dataUsingEncoding:NSUTF8StringEncoding];
        return [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
    }
    return nil;
}

- (NSURLRequest *)ag_urlRequestForAPIManager:(AGAPIManager *)manager {
    NSString *finalURL = [manager ag_finalURL:[self ag_baseURL] apiPath:[manager ag_apiPath] params:manager.finalParams];
    finalURL = [finalURL stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLQueryAllowedCharacterSet];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:finalURL]];
    request.HTTPMethod = [manager ag_apiMethod];
    request.timeoutInterval = [manager ag_connectTimeout];
    request.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
    return request;
}

#pragma mark - ----------- Getter Methods ----------
- (NSMutableDictionary *)headers {
    if (_headers == nil) {
        _headers = [NSMutableDictionary dictionary];
    }
    return _headers;
}

- (NSMutableDictionary *)commonParams {
    if (_commonParams == nil) {
        _commonParams = [NSMutableDictionary dictionary];
    }
    return _commonParams;
}

@end
