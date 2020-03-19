//
//  AGVMBaseGenerator.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/12/20.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "AGVMBaseGenerator.h"

@implementation AGVMBaseGenerator

@synthesize classSet = _classSet;
- (NSMutableSet<Class<AGViewReusable>> *)classSet
{
    if (nil == _classSet) {
        _classSet = [[NSMutableSet alloc] initWithCapacity:6];
    }
    return _classSet;
}

@synthesize classNameSet = _classNameSet;
- (NSMutableSet<NSString *> *)classNameSet
{
    if (nil == _classNameSet) {
        _classNameSet = [[NSMutableSet alloc] initWithCapacity:6];
    }
    return _classNameSet;
}

@end
