//
//  NSMutableArray+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/11/17.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "NSMutableArray+AGViewModel.h"

@implementation NSMutableArray (AGViewModel)

+ (NSMutableArray *)ag_arrayAddObjectsWithCount:(NSUInteger)count usingBlock:(id  _Nullable (NS_NOESCAPE^)(NSUInteger))block
{
    NSMutableArray *arrM = [self arrayWithCapacity:count];
    [arrM ag_addObjectsWithCount:count usingBlock:block];
    return arrM;
}

- (void)ag_addObjectsWithCount:(NSUInteger)count usingBlock:(NS_NOESCAPE id  _Nullable (^)(NSUInteger))block
{
    if (nil == block) return;
    
    for (NSInteger i = 0; i<count; i++) {
        id obj = block(i);
        if (obj) {
            [self addObject:obj];
        }
    }
}

@end
