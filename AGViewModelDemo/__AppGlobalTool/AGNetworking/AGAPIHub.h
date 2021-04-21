//
//  AGAPIHub.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2021/4/21.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGAPIProtocol.h"

@class AGAPIManager;

NS_ASSUME_NONNULL_BEGIN

@interface AGAPIHub : NSObject

@end

@interface AGAPIIterator : NSObject

@property (nonatomic, copy, readonly) NSArray<AGAPIManager *> *apis;
@property (nonatomic, assign, readonly) NSInteger next;

@property (nonatomic, assign) NSInteger finishedCount;
@property (nonatomic, strong) NSMutableArray<NSError *> *errors;
@property (nonatomic, copy) AGAPIManagerGroupCallbackBlock callbackBlock;

- (instancetype)initWithAPIs:(NSArray<AGAPIManager *> *)apis;

- (AGAPIManager *) nextAPIManager;

- (void) finishedOneAPIAndCheckCallback;

@end

NS_ASSUME_NONNULL_END
