//
//  AGDoubanService.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//  豆瓣服务器

#import <UIKit/UIKit.h>
#import <CTNetworking.h>

extern NSString * const AGDoubanServiceIdentifier;

@interface AGDoubanService : NSObject<CTServiceProtocol>

@property (nonatomic, assign)CTServiceAPIEnvironment apiEnvironment;

- (NSURLRequest *)requestWithParams:(NSDictionary *)params
                         methodName:(NSString *)methodName
                        requestType:(CTAPIManagerRequestType)requestType;

- (NSDictionary *)resultWithResponseData:(NSData *)responseData
                                response:(NSURLResponse *)response
                                 request:(NSURLRequest *)request
                                   error:(NSError **)error;

@end
