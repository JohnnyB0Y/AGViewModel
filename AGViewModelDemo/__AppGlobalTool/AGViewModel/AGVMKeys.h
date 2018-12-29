//
//  AGVMKeys_h
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/7.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  viewModel const keys

#import <UIKit/UIKit.h>
#ifndef AGVMKeys_h
#define AGVMKeys_h

// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// view model const key
//
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#pragma mark - 携带数据相关
/** 携带的对象 👉id👈  */
static NSString * const kAGVMObject = @"kAGVMObject";

/** 携带的数组 👉NSArray👈  */
static NSString * const kAGVMArray = @"kAGVMArray";

/** 携带的字典 👉NSDictionary👈  */
static NSString * const kAGVMDictionary = @"kAGVMDictionary";

/** 携带的AGViewModel 👉AGViewModel👈  */
static NSString * const kAGViewModel = @"kAGViewModel";

/** 携带的AGVMSection 👉AGVMSection👈  */
static NSString * const kAGVMSection = @"kAGVMSection";

/** 携带的AGVMManager 👉AGVMManager👈  */
static NSString * const kAGVMManager = @"kAGVMManager";

/** 携带的公共VM 👉AGViewModel👈 */
static NSString * const kAGVMCommonVM = @"kAGVMCommonVM";
/** 携带的头部VM 👉AGViewModel👈 */
static NSString * const kAGVMHeaderVM = @"kAGVMHeaderVM";
/** 携带的尾部VM 👉AGViewModel👈 */
static NSString * const kAGVMFooterVM = @"kAGVMFooterVM";

#pragma mark - 类型、状态描述相关
/** View Model 的类型 👉NSString👈 */
static NSString * const kAGVMType = @"kAGVMType";

/** 是否选中？ 👉NSNumber👈 */
static NSString * const kAGVMSelected = @"kAGVMSelected";

/** 是否禁用？ 👉NSNumber👈 */
static NSString * const kAGVMDisabled = @"kAGVMDisabled";

/** 是否删除？ 👉NSNumber👈 */
static NSString * const kAGVMDeleted = @"kAGVMDeleted";

/** 是否刷新？ 👉NSNumber👈 */
static NSString * const kAGVMReloaded = @"kAGVMReloaded";

/** 是否添加？ 👉NSNumber👈 */
static NSString * const kAGVMAdded = @"kAGVMAdded";

#pragma mark - 跳转的控制器相关
/** 目标跳转控制器 - 👉Class👈 */
static NSString * const kAGVMTargetVCClass = @"kAGVMTargetVCClass";

/** 目标跳转控制器 - 标题 👉NSString👈 */
static NSString * const kAGVMTargetVCTitle = @"kAGVMTargetVCTitle";

/** 目标跳转控制器 - 类型 👉NSString👈 */
static NSString * const kAGVMTargetVCType = @"kAGVMTargetVCType";

/** 目标跳转控制器 - 执行的代码块 👉Block👈 */
static NSString * const kAGVMTargetVCBlock = @"kAGVMTargetVCBlock";


#pragma mark - 显示的视图相关
/** view 类对象 👉Class👈 */
static NSString * const kAGVMViewClass = @"kAGVMViewClass";

/** view 类名字符串 👉NSString👈 */
static NSString * const kAGVMViewClassName = @"kAGVMViewClassName";

#pragma mark 标记
/** view 标记 👉NSNumber👈 */
static NSString * const kAGVMViewTag = @"kAGVMViewTag";

#pragma mark 尺寸
/** 视图高度 👉NSNumber👈 */
static NSString * const kAGVMViewH = @"kAGVMViewH";

/** 视图宽度 👉NSNumber👈 */
static NSString * const kAGVMViewW = @"kAGVMViewW";

/** 宽高比 👉NSNumber👈 */
static NSString * const kAGVMViewAspectRatio = @"kAGVMViewAspectRatio";

/** 视图内边距 UIEdgeInsets 👉NSString👈 */
static NSString * const kAGVMViewEdgeInsets = @"kAGVMViewEdgeInsets";

/** 视图外边距 UIEdgeInsets 👉NSString👈 */
static NSString * const kAGVMViewEdgeMargin = @"kAGVMViewEdgeMargin";


#pragma mark 颜色
/** view 背景色 👉UIColor👈 */
static NSString * const kAGVMViewBGColor = @"kAGVMViewBGColor";
/** view 显示类型 👉NSNumber👈 */
static NSString * const kAGVMViewDisplayType = @"kAGVMViewDisplayType";


#pragma mark 元素
/** 标题内容 👉NSString👈 */
static NSString * const kAGVMTitleText = @"kAGVMTitleText";
static NSString * const kAGVMTitlePlaceholder = @"kAGVMTitlePlaceholder";
/** 标题颜色 👉UIColor👈 */
static NSString * const kAGVMTitleColor = @"kAGVMTitleColor";

/** 子标题内容 👉NSString👈 */
static NSString * const kAGVMSubTitleText = @"kAGVMSubTitleText";
static NSString * const kAGVMSubTitlePlaceholder = @"kAGVMSubTitlePlaceholder";
/** 子标题颜色 👉UIColor👈 */
static NSString * const kAGVMSubTitleColor = @"kAGVMSubTitleColor";

/** 详情内容 👉NSString👈 */
static NSString * const kAGVMDetailText = @"kAGVMDetailText";
static NSString * const kAGVMDetailPlaceholder = @"kAGVMDetailPlaceholder";
/** 详情颜色 👉UIColor👈 */
static NSString * const kAGVMDetailColor = @"kAGVMDetailColor";

/** 图片 👉UIImage👈 */
static NSString * const kAGVMImage = @"kAGVMImage";

/** 网络图片 👉NSString👈 */
static NSString * const kAGVMImageURLText = @"kAGVMImageURLText";
static NSString * const kAGVMImageURLPlaceholder = @"kAGVMImageURLPlaceholder";

#endif /* AGVMKeys_h */
