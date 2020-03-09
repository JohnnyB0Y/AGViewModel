//
//  AGVMBasePackager.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/12/20.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "AGVMProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface AGVMBasePackager : NSObject
<AGVMPackagable>

/// 可复用的视图类集合，可用于滚动视图注册
@property (nonatomic, strong, readonly) NSMutableSet<Class<AGViewReusable>> *classSet;

/// 可复用的视图类名字符串集合，可用于滚动视图注册
@property (nonatomic, strong, readonly) NSMutableSet<NSString *> *classNameSet;

@end

NS_ASSUME_NONNULL_END
