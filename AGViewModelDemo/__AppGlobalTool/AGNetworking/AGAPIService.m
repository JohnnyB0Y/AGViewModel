//
//  AGAPIService.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2021/4/21.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import "AGAPIService.h"

static NSMutableDictionary *apiServices = nil;

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

- (void) registerAPIServiceForKey:(NSString *)key {
    [apiServices setValue:self forKey:key];
}
- (void) registerAPIServiceForDefault {
    [self registerAPIServiceForKey:@"kAGAPIServiceDefault"];
}

+ (AGAPIService *)dequeueAPIServiceForKey:(NSString *)key {
    return apiServices[key];
}

/// 分页
- (NSDictionary *)pagedParamsForAPIManager:(AGAPIManager *)manager {
    return nil;
}

- (BOOL)isLastPagedForAPIManager:(AGAPIManager *)manager {
    return NO;
}

@end
