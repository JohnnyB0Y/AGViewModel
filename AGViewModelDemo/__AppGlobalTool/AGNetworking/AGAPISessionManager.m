//
//  AGAPISessionManager.m
//  AGViewModelDemo
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

- (void)callAPIForAPIManager:(nonnull AGAPIManager *)manager
                     options:(nullable NSObject *)options
                    callback:(nullable AGAPICallbackBlock)callback {
    
    __weak typeof(manager) weakManager = manager;
    NSURLSessionTask *task = [self.session dataTaskWithRequest:[manager requestForAPIManager:manager] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        __strong typeof(weakManager) strongManager = weakManager;
        if (nil == strongManager) return;
        
        if (callback && strongManager.requestId) {
            callback(data, (NSHTTPURLResponse *)response, error);
        }
    }];
    
    manager.requestId = @(task.taskIdentifier);
    [self.tasks setObject:task forKey:manager.requestId];
    
    [task resume];
}

- (void)cancelAPIForAPIManager:(nonnull AGAPIManager *)manager options:(nullable NSObject *)options {
    NSURLSessionTask *task = [self.tasks objectForKey:manager.requestId];
    [task cancel];
    [self.tasks removeObjectForKey:manager.requestId];
}

- (void)deleteAllCache:(nullable AGAPIManager *)manager options:(nullable NSObject *)options callback:(nullable AGAPIHandleBlock)callback {
}

- (void)deleteCacheForAPIManager:(nonnull AGAPIManager *)manager options:(nullable NSObject *)options callback:(nullable AGAPIHandleBlock)callback {
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
