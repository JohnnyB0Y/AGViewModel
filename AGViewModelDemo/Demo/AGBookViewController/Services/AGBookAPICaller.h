//
//  AGBookAPICaller.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/2/23.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "AGAPIBaseCaller.h"

// api manager
#import "AGBookListAPIManager.h"
#import "AGBookDetailAPIManager.h"

// api reformer
#import "AGBookListAPIReformer.h"
#import "AGBookHandleReformer.h"


NS_ASSUME_NONNULL_BEGIN

/**

 当模块的API很多的时候，
 可以把模块相关的API集合在一起管理；

 */

@interface AGBookAPICaller : AGAPIBaseCaller

/** 豆瓣书籍列表 api */
@property (nonatomic, strong, readonly) AGBookListAPIManager *listAPIManager;

/** 豆瓣书籍详情 api */
@property (nonatomic, strong, readonly) AGBookDetailAPIManager *detailAPIManager;

/** 书籍列表 reformer */
@property (nonatomic, strong, readonly) AGBookListAPIReformer *listReformer;

/** 书籍处理 reformer */
@property (nonatomic, strong, readonly) AGBookHandleReformer *handleReformer;

@end

NS_ASSUME_NONNULL_END
