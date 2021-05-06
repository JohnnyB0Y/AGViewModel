//
//  AGTaobaoAPIHub.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2021/5/6.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import "AGAPINetworking.h"
#import "AGTaobaoListAPIManager.h"
#import "AGBookListAPIReformer.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGTaobaoAPIHub : AGAPIHub

/// 淘宝产品列表
@property (nonatomic, strong, readonly) AGTaobaoListAPIManager *productList;

/// 淘宝产品列表数据过滤
@property (nonatomic, strong, readonly) AGBookListAPIReformer *productListReformer;

@end

NS_ASSUME_NONNULL_END
