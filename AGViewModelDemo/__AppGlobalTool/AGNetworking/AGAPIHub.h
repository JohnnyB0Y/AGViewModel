//
//  AGAPIHub.h
//  
//
//  Created by JohnnyB0Y on 2021/4/21.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGAPIProtocol.h"

@class AGAPIManager;

NS_ASSUME_NONNULL_BEGIN

@interface AGAPIHub : NSObject

- (void) ag_serialRequestAPIs:(NSArray<AGAPIManager *> *)apis callback:(AGAPIManagerGroupCallbackBlock)callback;

- (void) ag_groupRequestAPIs:(NSArray<AGAPIManager *> *)apis callback:(AGAPIManagerGroupCallbackBlock)callback;

- (void) ag_cancleAllRequest;

@end

@interface AGAPIIterator : NSObject

@property (nonatomic, copy, readonly) NSArray<AGAPIManager *> *apis;
@property (nonatomic, assign, readonly) NSInteger next;

@property (nonatomic, assign) NSInteger finishedCount;
@property (nonatomic, copy) AGAPIManagerGroupCallbackBlock callbackBlock;

- (instancetype)initWithAPIs:(NSArray<AGAPIManager *> *)apis;

- (AGAPIManager *) ag_nextAPIManager;

- (void) ag_finishedOneAPIAndCheckCallback;

@end

NS_ASSUME_NONNULL_END
