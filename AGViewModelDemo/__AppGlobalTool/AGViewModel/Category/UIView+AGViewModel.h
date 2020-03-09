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

NS_ASSUME_NONNULL_BEGIN

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


#pragma mark management subview
- (void)ag_addSubview:(UIView *)view forKey:(NSString *)key;
- (nullable UIView *)ag_subviewForKey:(NSString *)key;

/// 添加子控件到视图，name + position = key；
/// @param view 子控件
/// @param name 控件描述
/// @param position 位置描述（建议：l => left; r => right; t => top; b => bottom; c => center;)
- (void)ag_addSubview:(UIView *)view withName:(NSString *)name atPosition:(NSString *)position;

/// 取出子控件，name + position = key；
/// @param name 控件描述
/// @param position 位置描述
- (nullable UIView *)ag_subviewWithName:(NSString *)name atPosition:(NSString *)position;


#pragma mark Resource Methods
/** 如果你使用 nib、xib 创建视图，又需要打包成库文件的时候，请返回你的资源文件目录。*/
+ (NSBundle *) ag_resourceBundle; // 默认 main bundle

/** 能否从nil文件创建视图,bundle=nil,从main bundle加载. */
+ (BOOL) ag_canAwakeNibInBundle:(nullable NSBundle *)bundle;

/** 从 nib 创建实例,bundle=nil,从main bundle加载. */
+ (instancetype) ag_newFromNibInBundle:(nullable NSBundle *)bundle;

@end

/**
 子控件，默认 key
 k => key; SV => subview;
 */

/// 标题控件
AGVMConstKeyNameExtern kSVTitleLabel;
/// 子标题控件
AGVMConstKeyNameExtern kSVSubtitleLabel;
/// 详情控件
AGVMConstKeyNameExtern kSVDetailLabel;
/// 日期控件
AGVMConstKeyNameExtern kSVDateLabel;
/// 头像控件
AGVMConstKeyNameExtern kSVAvatarView;
/// 性别控件
AGVMConstKeyNameExtern kSVSexView;
/// 分割线控件
AGVMConstKeyNameExtern kSVPartingLine;

/// 位置-左
AGVMConstKeyNameExtern pSVLeft;
/// 位置-右
AGVMConstKeyNameExtern pSVRight;
/// 位置-顶
AGVMConstKeyNameExtern pSVTop;
/// 位置-底
AGVMConstKeyNameExtern pSVBottom;
/// 位置-中心
AGVMConstKeyNameExtern pSVCenter;

NS_ASSUME_NONNULL_END
