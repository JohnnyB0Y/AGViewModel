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

- (NSDictionary *)resultWithResponseObject:(id)responseObject
                                  response:(NSURLResponse *)response
                                   request:(NSURLRequest *)request
                                     error:(NSError **)error;

/*
 return true means should continue the error handling process in CTAPIBaseManager
 return false means stop the error handling process
 
 如果检查错误之后，需要继续走fail路径上报到业务层的，return YES。（例如网络错误等，需要业务层弹框）
 如果检查错误之后，不需要继续走fail路径上报到业务层的，return NO。（例如用户token失效，此时挂起API，调用刷新token的API，成功之后再重新调用原来的API。那么这种情况就不需要继续走fail路径上报到业务。）
 */
- (BOOL)handleCommonErrorWithResponse:(CTURLResponse *)response
                              manager:(CTAPIBaseManager *)manager
                            errorType:(CTAPIManagerErrorType)errorType;

@end
