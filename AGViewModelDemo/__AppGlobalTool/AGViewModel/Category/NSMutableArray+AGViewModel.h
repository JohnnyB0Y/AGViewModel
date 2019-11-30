//
//  NSMutableArray+AGViewModel.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/11/17.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (AGViewModel)

+ (NSMutableArray *)ag_arrayAddObjectsWithCount:(NSUInteger)count usingBlock:(_Nullable id(NS_NOESCAPE^)(NSUInteger idx))block;

- (void)ag_addObjectsWithCount:(NSUInteger)count usingBlock:(_Nullable id(NS_NOESCAPE^)(NSUInteger idx))block;

@end

NS_ASSUME_NONNULL_END
