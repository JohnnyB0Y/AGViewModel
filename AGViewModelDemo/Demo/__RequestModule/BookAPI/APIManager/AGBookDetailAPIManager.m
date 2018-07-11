//
//  AGBookDetailAPIManager.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//  图书详情 api

#import "AGBookDetailAPIManager.h"
#import "AGDoubanService.h"

@implementation AGBookDetailAPIManager

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        self.validator = (id<CTAPIManagerValidator>)self;
        self.cachePolicy = CTAPIManagerCachePolicyNoCache;
    }
    
    return self;
}

#pragma mark - CTAPIManager
- (NSString *)methodName
{
    return [NSString stringWithFormat:@"book/isbn/%@", self.isbn];
}

- (NSString *)serviceIdentifier
{
    return AGDoubanServiceIdentifier;
}

- (CTAPIManagerRequestType)requestType
{
    return CTAPIManagerRequestTypeGet;
}

#pragma mark - CTAPIManagerValidator
- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *_Nonnull)manager
       isCorrectWithCallBackData:(NSDictionary *_Nullable)data
{
    return CTAPIManagerErrorTypeNoError;
}

- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *_Nonnull)manager
         isCorrectWithParamsData:(NSDictionary *_Nullable)data
{
    return CTAPIManagerErrorTypeNoError;
}

@end
