//
//  AGBookListAPIManager.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//  书籍列表

#import <CTAPIBaseManager.h>
#import "CTAPIBaseManager+WNAPIBaseManager.h"

@interface AGBookListAPIManager : CTAPIBaseManager
<CTAPIManager, CTAPIManagerValidator, CTPagableAPIManager>

@property (nonatomic, assign) NSInteger pageSize;
@property (nonatomic, assign, readonly) NSUInteger currentPageNumber;
@property (nonatomic, assign, readonly) BOOL isLastPage;

- (void)loadNextPage;

@end
