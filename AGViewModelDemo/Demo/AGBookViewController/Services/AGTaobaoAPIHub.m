//
//  AGTaobaoAPIHub.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2021/5/6.
//  Copyright © 2021 JohnnyB0Y. All rights reserved.
//

#import "AGTaobaoAPIHub.h"

@implementation AGTaobaoAPIHub

@synthesize productList = _productList;
@synthesize productListReformer = _productListReformer;


- (void)ag_cancleAllRequest {
    [self.productList ag_cancelRequest];
}

#pragma mark - ----------- Getter Methods ----------
- (AGTaobaoListAPIManager *)productList {
    if (_productList == nil) {
        _productList = [[AGTaobaoListAPIManager alloc] init];
    }
    return _productList;
}

- (AGBookListAPIReformer *)productListReformer {
    if ( _productListReformer == nil) {
        _productListReformer = [AGBookListAPIReformer new];
    }
    return _productListReformer;
}

@end
