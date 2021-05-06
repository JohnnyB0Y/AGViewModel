//
//  AGTaobaoAPIHub.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2021/5/6.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import "AGAPIHub.h"
#import "AGTaobaoListAPIManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGTaobaoAPIHub : AGAPIHub

/// 淘宝产品列表
@property (nonatomic, strong, readonly) AGTaobaoListAPIManager *productList;

@end

NS_ASSUME_NONNULL_END
