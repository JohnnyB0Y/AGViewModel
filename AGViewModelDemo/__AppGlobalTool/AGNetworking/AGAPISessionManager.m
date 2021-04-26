//
//  AGAPISessionManager.m
//  
//
//  Created by JohnnyB0Y on 2021/4/21.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import "AGAPISessionManager.h"
#import "AGAPIManager.h"

@interface AGAPISessionManager ()

/// URL会话
@property (nonatomic, strong) NSURLSession *session;

/// 任务字典
@property (nonatomic, strong) NSMutableDictionary *tasks;

@end

@implementation AGAPISessionManager

- (void)ag_callAPIForAPIManager:(nonnull AGAPIManager *)manager
                        options:(nullable NSObject *)options
                       callback:(nullable AGAPICallbackBlock)callback {
    
    __weak typeof(manager) weakManager = manager;
    __weak typeof(self) weakSelf = self;
    NSURLSessionTask *task = [self.session dataTaskWithRequest:[manager ag_urlRequestForAPIManager:manager] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            __strong typeof(weakManager) strongManager = weakManager;
            if (nil == strongManager) return;
            __strong typeof(weakSelf) self = weakSelf;
            if (nil == self) return;
            
            if (callback && strongManager.requestId) {
                callback(data, (NSHTTPURLResponse *)response, error);
            }
            
            // 移除task
            [self.tasks removeObjectForKey:strongManager.requestId];
        });
        
    }];
    
    manager.requestId = @(task.taskIdentifier);
    [self.tasks setObject:task forKey:manager.requestId];
    
    [task resume];
}

- (void)ag_cancelAPIForAPIManager:(nonnull AGAPIManager *)manager options:(nullable NSObject *)options {
    NSURLSessionTask *task = [self.tasks objectForKey:manager.requestId];
    [task cancel];
    [self.tasks removeObjectForKey:manager.requestId];
}

- (void)ag_deleteAllCache:(nullable AGAPIManager *)manager options:(nullable NSObject *)options callback:(nullable AGAPIHandleBlock)callback {
}

- (void)ag_deleteCacheForAPIManager:(nonnull AGAPIManager *)manager options:(nullable NSObject *)options callback:(nullable AGAPIHandleBlock)callback {
}

#pragma mark - ----------- Getter Methods ----------
- (NSURLSession *)session {
    if (_session == nil) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return _session;
}

- (NSMutableDictionary *)tasks {
    if (_tasks == nil) {
        _tasks = [NSMutableDictionary dictionaryWithCapacity:20];
    }
    return _tasks;
}

@end
