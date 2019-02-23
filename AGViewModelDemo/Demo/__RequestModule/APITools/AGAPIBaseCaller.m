//
//  AGAPIBaseCaller
//
//  Created by JohnnyB0Y on 16/5/10.
//  Copyright © 2016年 JohnnyB0Y. All rights reserved.
//

#import "AGAPIBaseCaller.h"
#import <CTMediator+CTAppContext.h>

@implementation AGAPIBaseCaller

#pragma mark - ----------- Life Cycle -------------
- (instancetype)initWithAPIDelegate:(id<CTAPIManagerCallBackDelegate,CTAPIManagerParamSource>)delegate
{
    self = [self init];
    if ( self == nil ) return nil;
    
    _apiParamDelegate = delegate;
    _apiCallBackDelegate = delegate;
    
    return self;
}

+ (instancetype)newWithAPIDelegate:(id<CTAPIManagerCallBackDelegate,CTAPIManagerParamSource>)delegate
{
    return [[self alloc] initWithAPIDelegate:delegate];
}

#pragma mark - ---------- Public Methods -----------
- (void)cancelAllRequests
{
    NSLog(@"请在子类重写该 cancelAllRequests 方法！");
}

#pragma mark - ---------- Getter Methods ------------
- (BOOL)isReachable
{
    return [[CTMediator sharedInstance] CTNetworking_isReachable];
}

@end
