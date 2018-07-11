//
//  AGBookDetailAPIManager.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//  图书详情 api

#import "CTAPIBaseManager.h"
#import "CTAPIBaseManager+WNAPIBaseManager.h"

@interface AGBookDetailAPIManager : CTAPIBaseManager<CTAPIManager, CTAPIManagerValidator>

/** isbn */
@property (nonatomic, strong) NSString *isbn;

@end
