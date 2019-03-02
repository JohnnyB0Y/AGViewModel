//
//  UIView+AGViewModel.h
//  
//
//  Created by JohnnyB0Y on 2018/2/12.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGViewModel.h"
#import "AGVMProtocol.h"

@interface UIView (AGViewModel)
<AGVMResponsive>

@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGSize size;

@property(nonatomic, assign) CGFloat x;
@property(nonatomic, assign) CGFloat y;
@property(nonatomic, assign) CGPoint origin;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

- (void) setViewModel:(nullable AGViewModel *)viewModel NS_REQUIRES_SUPER;
- (nullable AGViewModel *) viewModel NS_REQUIRES_SUPER;


/** 如果你使用 nib、xib 创建视图，又需要打包成库文件的时候，请返回你的资源文件目录。*/
+ (NSBundle *) ag_resourceBundle; // 默认 main bundle

/** 能否从nil文件创建视图,bundle=nil,从main bundle加载. */
+ (BOOL) ag_canAwakeNibInBundle:(NSBundle *)bundle;

/** 从 nib 创建实例,bundle=nil,从main bundle加载. */
+ (instancetype) ag_newFromNibInBundle:(NSBundle *)bundle;

@end
