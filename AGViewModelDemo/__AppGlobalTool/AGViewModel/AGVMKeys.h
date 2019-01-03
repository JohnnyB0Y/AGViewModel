//
//  AGVMKeys_h
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/7.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  viewModel const keys

#import <Foundation/Foundation.h>
#ifndef AGVMKeys_h
#define AGVMKeys_h


#pragma mark - Define
/** TODO 宏 */
#define STRINGIFY(S) #S
#define DEFER_STRINGIFY(S) STRINGIFY(S)
#define PRAGMA_MESSAGE(MSG) _Pragma(STRINGIFY(message(MSG)))
#define FORMATTED_MESSAGE(MSG) "[TODO~" DEFER_STRINGIFY(__COUNTER__) "] " MSG " [LINE:" DEFER_STRINGIFY(__LINE__) "]"
#define AGTODO(MSG) PRAGMA_MESSAGE(FORMATTED_MESSAGE(MSG))


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// view model const key
//
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#pragma mark - 携带数据相关
/** 携带的对象 👉id👈  */
FOUNDATION_EXTERN NSString * const kAGVMObject;

/** 携带的数组 👉NSArray👈  */
FOUNDATION_EXTERN NSString * const kAGVMArray;

/** 携带的字典 👉NSDictionary👈  */
FOUNDATION_EXTERN NSString * const kAGVMDictionary;

/** 携带的AGViewModel 👉AGViewModel👈  */
FOUNDATION_EXTERN NSString * const kAGViewModel;

/** 携带的AGVMSection 👉AGVMSection👈  */
FOUNDATION_EXTERN NSString * const kAGVMSection;

/** 携带的AGVMManager 👉AGVMManager👈  */
FOUNDATION_EXTERN NSString * const kAGVMManager;

/** 携带的公共VM 👉AGViewModel👈 */
FOUNDATION_EXTERN NSString * const kAGVMCommonVM;
/** 携带的头部VM 👉AGViewModel👈 */
FOUNDATION_EXTERN NSString * const kAGVMHeaderVM;
/** 携带的尾部VM 👉AGViewModel👈 */
FOUNDATION_EXTERN NSString * const kAGVMFooterVM;

#pragma mark - 类型、状态描述相关
/** View Model 的类型 👉NSString👈 */
FOUNDATION_EXTERN NSString * const kAGVMType;

/** 是否选中？ 👉NSNumber👈 */
FOUNDATION_EXTERN NSString * const kAGVMSelected;

/** 是否禁用？ 👉NSNumber👈 */
FOUNDATION_EXTERN NSString * const kAGVMDisabled;

/** 是否删除？ 👉NSNumber👈 */
FOUNDATION_EXTERN NSString * const kAGVMDeleted;

/** 是否刷新？ 👉NSNumber👈 */
FOUNDATION_EXTERN NSString * const kAGVMReloaded;

/** 是否添加？ 👉NSNumber👈 */
FOUNDATION_EXTERN NSString * const kAGVMAdded;

#pragma mark - 跳转的控制器相关
/** 目标跳转控制器 - 👉Class👈 */
FOUNDATION_EXTERN NSString * const kAGVMTargetVCClass;

/** 目标跳转控制器 - 标题 👉NSString👈 */
FOUNDATION_EXTERN NSString * const kAGVMTargetVCTitle;

/** 目标跳转控制器 - 类型 👉NSString👈 */
FOUNDATION_EXTERN NSString * const kAGVMTargetVCType;

/** 目标跳转控制器 - 执行的代码块 👉Block👈 */
FOUNDATION_EXTERN NSString * const kAGVMTargetVCBlock;


#pragma mark - 显示的视图相关
/** view 类对象 👉Class👈 */
FOUNDATION_EXTERN NSString * const kAGVMViewClass;

/** view 类名字符串 👉NSString👈 */
FOUNDATION_EXTERN NSString * const kAGVMViewClassName;

#pragma mark 标记
/** view 标记 👉NSNumber👈 */
FOUNDATION_EXTERN NSString * const kAGVMViewTag;

#pragma mark 尺寸
/** 视图高度 👉NSNumber👈 */
FOUNDATION_EXTERN NSString * const kAGVMViewH;

/** 视图宽度 👉NSNumber👈 */
FOUNDATION_EXTERN NSString * const kAGVMViewW;

/** 宽高比 👉NSNumber👈 */
FOUNDATION_EXTERN NSString * const kAGVMViewAspectRatio;

/** 视图内边距 UIEdgeInsets 👉NSString👈 */
FOUNDATION_EXTERN NSString * const kAGVMViewEdgeInsets;

/** 视图外边距 UIEdgeInsets 👉NSString👈 */
FOUNDATION_EXTERN NSString * const kAGVMViewEdgeMargin;


#pragma mark 颜色
/** view 背景色 👉UIColor👈 */
FOUNDATION_EXTERN NSString * const kAGVMViewBGColor;
/** view 显示类型 👉NSNumber👈 */
FOUNDATION_EXTERN NSString * const kAGVMViewDisplayType;


#pragma mark 元素
/** 标题内容 👉NSString👈 */
FOUNDATION_EXTERN NSString * const kAGVMTitleText;
FOUNDATION_EXTERN NSString * const kAGVMTitlePlaceholder;
/** 标题颜色 👉UIColor👈 */
FOUNDATION_EXTERN NSString * const kAGVMTitleColor;

/** 子标题内容 👉NSString👈 */
FOUNDATION_EXTERN NSString * const kAGVMSubTitleText;
FOUNDATION_EXTERN NSString * const kAGVMSubTitlePlaceholder;
/** 子标题颜色 👉UIColor👈 */
FOUNDATION_EXTERN NSString * const kAGVMSubTitleColor;

/** 详情内容 👉NSString👈 */
FOUNDATION_EXTERN NSString * const kAGVMDetailText;
FOUNDATION_EXTERN NSString * const kAGVMDetailPlaceholder;
/** 详情颜色 👉UIColor👈 */
FOUNDATION_EXTERN NSString * const kAGVMDetailColor;

/** 图片 👉UIImage👈 */
FOUNDATION_EXTERN NSString * const kAGVMImage;

/** 网络图片 👉NSString👈 */
FOUNDATION_EXTERN NSString * const kAGVMImageURLText;
FOUNDATION_EXTERN NSString * const kAGVMImageURLPlaceholder;

#endif /* AGVMKeys_h */
