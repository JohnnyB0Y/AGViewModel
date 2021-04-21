//
//  AGAPIHub.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2021/4/21.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import "AGAPIHub.h"
#import "AGAPIManager.h"
#import "AGAPIProtocol.h"


@implementation AGAPIHub

- (void) serialRequestAPIs:(NSArray<AGAPIManager *> *)apis {
    AGAPIIterator *itor = [[AGAPIIterator alloc] initWithAPIs:apis];
    AGAPIManager *api = [itor nextAPIManager];
    [api requestWithAPISerialIterator:itor];
}

- (void) groupRequestAPIs:(NSArray<AGAPIManager *> *)apis callback:(AGAPIManagerGroupCallbackBlock)callback {
    AGAPIIterator *itor = [[AGAPIIterator alloc] initWithAPIs:apis];
    AGAPIManager *api = [itor nextAPIManager];
    while (api) {
        [api requestWithAPIGroupIterator:itor];
        api = [itor nextAPIManager];
    }
}

@end

@implementation AGAPIIterator

- (instancetype)initWithAPIs:(NSArray<AGAPIManager *> *)apis {
    self = [self init];
    if (self) {
        _apis = apis;
        _next = 0;
    }
    return self;
}

- (AGAPIManager *) nextAPIManager {
    if (_next >= _apis.count) {
        return nil;
    }
    return _apis[_next++];
}

- (void)finishedOneAPIAndCheckCallback {
    // 完成一条，累加一次，检查一次
    if (++self.finishedCount >= self.apis.count) {
        __block BOOL allSuccess = YES;
        [self.apis enumerateObjectsUsingBlock:^(AGAPIManager * _Nonnull api, NSUInteger idx, BOOL * _Nonnull stop) {
            if (api.status != AGAPICallbackStatusSuccess) {
                allSuccess = NO;
                *stop = YES;
            }
        }];
        
        self.callbackBlock ? self.callbackBlock(self.apis, allSuccess) : nil;
    }
}

@end
