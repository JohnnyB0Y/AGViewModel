//
//  AGBookAPICaller.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/2/23.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "AGBookAPICaller.h"

@implementation AGBookAPICaller

@synthesize
listAPIManager = _listAPIManager,
detailAPIManager = _detailAPIManager;

@synthesize
listReformer = _listReformer,
handleReformer = _handleReformer;

#pragma mark - ---------- Public Methods ----------

- (void)cancelAllRequests
{
    /**
     取消所有已起飞的API请求。
     */
    [_listAPIManager cancelAllRequests];
    [_detailAPIManager cancelAllRequests];
}

#pragma mark - ----------- Getter Methods ----------
- (AGBookListAPIManager *)listAPIManager
{
    if (_listAPIManager == nil) {
        _listAPIManager = [AGBookListAPIManager new];
        _listAPIManager.paramSource = self.apiParamDelegate;
        _listAPIManager.delegate = self.apiCallBackDelegate;
    }
    return _listAPIManager;
}

- (AGBookDetailAPIManager *)detailAPIManager
{
    if (_detailAPIManager == nil) {
        _detailAPIManager = [AGBookDetailAPIManager new];
        _detailAPIManager.paramSource = self.apiParamDelegate;
        _detailAPIManager.delegate = self.apiCallBackDelegate;
    }
    return _detailAPIManager;
}

- (AGBookListAPIReformer *)listReformer
{
    if (_listReformer == nil) {
        _listReformer = [AGBookListAPIReformer new];
    }
    return _listReformer;
}

- (AGBookHandleReformer *)handleReformer
{
    if (_handleReformer == nil) {
        _handleReformer = [AGBookHandleReformer new];
    }
    return _handleReformer;
}

@end
