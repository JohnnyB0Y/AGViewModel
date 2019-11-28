//
//  AGVMCommandQueue.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/11/16.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGVMProtocol.h"

NS_ASSUME_NONNULL_BEGIN

/**
 思考点：
 1, 参考 NSOperation、NSOperationQueue
 2, 希望能把多个网络请求串起来
 3, 有状态和优先级影响执行顺序、redo、undo
 4, 参考PromiseKit https://github.com/mxcl/PromiseKit
 */


@interface AGVMCommandQueue : NSObject


@end

NS_ASSUME_NONNULL_END
