//
//  AGDoubanService.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//  豆瓣服务器

#import "AGDoubanService.h"
#import <AFNetworking/AFNetworking.h>

/** 必须是类名，因为服务工厂直接根据标识创建服务类 */
NSString * const AGDoubanServiceIdentifier = @"AGDoubanService";

@interface AGDoubanService ()

@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) AFHTTPRequestSerializer *httpRequestSerializer;

@end

@implementation AGDoubanService

- (NSURLRequest *)requestWithParams:(NSDictionary *)params
                         methodName:(NSString *)methodName
                        requestType:(CTAPIManagerRequestType)requestType
{
    if (requestType == CTAPIManagerRequestTypeGet) {
        
        NSMutableDictionary *finalParams = [params mutableCopy];
        
        NSString *urlString = [NSString stringWithFormat:@"%@/%@", self.baseURL, methodName];
        NSMutableURLRequest *request
        = [self.httpRequestSerializer requestWithMethod:@"GET"
                                              URLString:urlString
                                             parameters:finalParams
                                                  error:nil];
        request.originRequestParams = params;
        request.actualRequestParams = params;
        return request;
    }
    
    return nil;
}

- (BOOL)handleCommonErrorWithResponse:(CTURLResponse *)response manager:(CTAPIBaseManager *)manager errorType:(CTAPIManagerErrorType)errorType
{
    return YES;
}

- (NSDictionary *)resultWithResponseObject:(id)responseObject
                                  response:(NSURLResponse *)response
                                   request:(NSURLRequest *)request
                                     error:(NSError *__autoreleasing *)error
{
    NSMutableDictionary *result = [[NSMutableDictionary alloc] init];
    if ( [responseObject isKindOfClass:[NSDictionary class]] ) {
        result[kCTApiProxyValidateResultKeyResponseObject] = responseObject;
        return result;
    }
    
    if ( [responseObject isKindOfClass:[NSData class]] ) {
        result[kCTApiProxyValidateResultKeyResponseString] = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        result[kCTApiProxyValidateResultKeyResponseObject] = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:NULL];
        return result;
    }
    return nil;
}


#pragma mark - getters and setters
- (NSString *)baseURL
{
    return @"https://api.douban.com/v2";
}

- (AFHTTPRequestSerializer *)httpRequestSerializer
{
    if (_httpRequestSerializer == nil) {
        _httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return _httpRequestSerializer;
}

@end
