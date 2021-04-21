//
//  AGAPIService.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2021/4/21.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGAPIProtocol.h"

@class AGAPISessionManager;

NS_ASSUME_NONNULL_BEGIN

@interface AGAPIService : NSObject

/// api session
@property (nonatomic, strong, readonly) id<AGAPISessionProtocol> session;

+ (instancetype) newWithAPISession:(id<AGAPISessionProtocol>)session;
- (instancetype) initWithAPISession:(id<AGAPISessionProtocol>)session;

- (void) registerAPIServiceForKey:(NSString *)key;
- (void) registerAPIServiceForDefault;
+ (nullable AGAPIService *) dequeueAPIServiceForKey:(NSString *)key;

/// 分页
- (nullable NSDictionary *) pagedParamsForAPIManager:(AGAPIManager *)manager;
- (BOOL) isLastPagedForAPIManager:(AGAPIManager *)manager;

@end

NS_ASSUME_NONNULL_END
