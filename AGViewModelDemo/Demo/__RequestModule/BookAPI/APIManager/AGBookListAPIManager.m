//
//  AGBookListAPIManager.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "AGBookListAPIManager.h"
#import "AGDoubanService.h"
#import <AGVerifyManager.h>

@interface AGBookListAPIManager () <AGVerifyManagerVerifiable>

@property (nonatomic, assign, readwrite) BOOL isFirstPage;
@property (nonatomic, assign, readwrite) BOOL isLastPage;
@property (nonatomic, assign, readwrite) NSUInteger pageNumber;

@end

@implementation AGBookListAPIManager

- (instancetype)init
{
    self = [super init];
    
    if ( self ) {
        self.validator = (id<CTAPIManagerValidator>)self;
        self.cachePolicy = CTAPIManagerCachePolicyNoCache;
        _pageSize = 16;
        _pageNumber = 0;
        _isFirstPage = YES;
        _isLastPage = NO;
    }
    
    return self;
}

#pragma mark - public methods
- (NSInteger)loadData
{
    [self cleanData];
    return [super loadData];
}

- (void)loadNextPage
{
    if (self.isLastPage) {
        if ([self.interceptor respondsToSelector:@selector(manager:didReceiveResponse:)]) {
            [self.interceptor manager:self didReceiveResponse:nil];
        }
        return;
    }
    
    if (!self.isLoading) {
        [super loadData];
    }
}

- (void)cleanData
{
    [super cleanData];
    self.isFirstPage = YES;
    self.pageNumber = 0;
}

- (NSDictionary *)reformParams:(NSDictionary *)params
{
    NSMutableDictionary *result = [params mutableCopy];
    if (result == nil) {
        result = [[NSMutableDictionary alloc] init];
    }
    
    if (result[@"count"] == nil) {
        result[@"count"] = @(self.pageSize);
    }
    else {
        self.pageSize = [result[@"count"] integerValue];
    }
    
    // start
    if (result[@"start"] == nil) {
        if (self.isFirstPage == NO) {
            result[@"start"] = @(self.pageNumber * self.pageSize);
        }
        else {
            result[@"start"] = @(0);
        }
    }
    else {
        self.pageNumber = [result[@"start"] unsignedIntegerValue] / self.pageSize;
    }
    
    return result;
}

#pragma mark - interceptors
- (BOOL)beforePerformSuccessWithResponse:(CTURLResponse *)response
{
    self.isFirstPage = NO;
    NSInteger totalPageCount = ceil([response.content[@"total"] doubleValue]/(double)self.pageSize);
    if (self.pageNumber == totalPageCount - 1) {
        self.isLastPage = YES;
    } else {
        self.isLastPage = NO;
    }
    self.pageNumber++;
    return [super beforePerformSuccessWithResponse:response];
}

#pragma mark - CTAPIManager
- (NSString *)methodName
{
    return @"book/search";
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
- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *)manager
       isCorrectWithCallBackData:(NSDictionary *)data
{
    // 判断返回数据是否有错
    
    return CTAPIManagerErrorTypeNoError;
}

- (CTAPIManagerErrorType)manager:(CTAPIBaseManager *)manager
         isCorrectWithParamsData:(NSDictionary *)data
{
    __block CTAPIManagerErrorType errorType = CTAPIManagerErrorTypeNoError;
    
    // 判断参数是否有错
    NSString *q = data[@"q"];
    [ag_newAGVerifyManager() ag_executeVerifying:^(id<AGVerifyManagerVerifying>  _Nonnull start) {
        
        start
        .verifyDataWithMsg(self, q, @"搜索关键字错误！");
        
    } completion:^(AGVerifyError * _Nullable firstError, NSArray<AGVerifyError *> * _Nullable errors) {
        
        if ( firstError ) {
            self.verifyError = firstError;
            errorType = CTAPIManagerErrorTypeParamsError;
        }
        
    }];
    
    return errorType;
}

#pragma mark - AGVerifyManagerVerifiable
- (nullable AGVerifyError *)ag_verifyData:(nonnull id)data {
    
    AGVerifyError *error;
    if ( [data isKindOfClass:[NSString class]] ) {
        NSString *newObj = data;
        if ( newObj.length <= 0 ) {
            error = [AGVerifyError new];
            error.msg = @"字符串不能为空！";
        }
    }
    else {
        error = [AGVerifyError new];
        error.msg = @"应为字符串类型！";
    }
    return error;
}


@end
