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

/** min < idx < max; return BOOL. */
#define AGIsIndexInRange(min, idx, max) ((min) < (idx)) && ((idx) < (max))

#define AGAssertIndexRange(min, idx, max) NSAssert(AGIsIndexInRange((min), (idx), (max)), @"Index out of range.")

#define AGAssertParameter(parameter) NSParameterAssert((parameter))


#pragma mark 常量 声明&定义 宏
typedef NSString * const AGVMConstKeyName NS_EXTENSIBLE_STRING_ENUM;

/// 声明常量 👉AGVMConstKeyExtern kAGVMObject;👈
#define AGVMConstKeyNameExtern FOUNDATION_EXTERN AGVMConstKeyName

/// 定义常量 👉AGVMConstKeyNameDefine(kAGVMObject);👈
#define AGVMConstKeyNameDefine(keyName) AGVMConstKeyName keyName = @#keyName

/// 定义静态常量 👉AGVMStaticConstKeyNameDefine(kAGVMObject);👈
#define AGVMStaticConstKeyNameDefine(keyName) static AGVMConstKeyNameDefine(keyName)


// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
//
// view model const key
//
// ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

#pragma mark - 携带数据相关
AGVMConstKeyNameExtern kAGVMObject;         ///< 携带的对象 👉id👈
AGVMConstKeyNameExtern kAGVMArray;          ///< 携带的数组 👉NSArray👈
AGVMConstKeyNameExtern kAGVMTextArray;      ///< 携带的字符串数组 👉NSArray<NSString>👈
AGVMConstKeyNameExtern kAGVMAttrTextArray;  ///< 携带的富文本字符串数组 👉NSArray<NSAttributedString>👈
AGVMConstKeyNameExtern kAGVMNumberArray;    ///< 携带的数字数组 👉NSArray<NSNumber>👈
AGVMConstKeyNameExtern kAGVMDictionary;     ///< 携带的字典 👉NSDictionary👈
AGVMConstKeyNameExtern kAGViewModel;        ///< 携带的AGViewModel 👉AGViewModel👈
AGVMConstKeyNameExtern kAGVMSection;        ///< 携带的AGVMSection 👉AGVMSection👈
AGVMConstKeyNameExtern kAGVMManager;        ///< 携带的AGVMManager 👉AGVMManager👈
AGVMConstKeyNameExtern kAGVMCommonVM;       ///< 携带的公共VM 👉AGViewModel👈
AGVMConstKeyNameExtern kAGVMHeaderVM;       ///< 携带的头部VM 👉AGViewModel👈
AGVMConstKeyNameExtern kAGVMFooterVM;       ///< 携带的尾部VM 👉AGViewModel👈


#pragma mark - 状态描述相关
AGVMConstKeyNameExtern kAGVMSelected;   ///< 是否选中？ 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMDisabled;   ///< 是否禁用？ 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMDeleted;    ///< 是否删除？ 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMReloaded;   ///< 是否刷新？ 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMAdded;      ///< 是否添加？ 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMShowed;     ///< 是否显示？ 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMOpened;     ///< 是否打开？ 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMClosed;     ///< 是否关闭？ 👉NSNumber👈


#pragma mark - Block 的存取相关
AGVMConstKeyNameExtern kAGVMTargetVCClass;  ///< 目标跳转控制器 - 类对象      👉Class👈
AGVMConstKeyNameExtern kAGVMTargetVCTitle;  ///< 目标跳转控制器 - 标题       👉NSString👈
AGVMConstKeyNameExtern kAGVMTargetVCType;   ///< 目标跳转控制器 - 类型       👉NSString👈
AGVMConstKeyNameExtern kAGVMTargetVCBlock;  ///< 目标跳转控制器 - 执行的代码块 👉Block👈


#pragma mark - 显示的视图相关
AGVMConstKeyNameExtern kAGVMViewClass;      ///< view 类对象 👉Class👈
AGVMConstKeyNameExtern kAGVMView;           ///< view 对象 👉UIView👈
AGVMConstKeyNameExtern kAGVMViewHidden;     ///< view 隐藏 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMViewClassName;  ///< view 类名字符串 👉NSString👈


#pragma mark 类型or标记
AGVMConstKeyNameExtern kAGVMViewTag;        ///< view 标记 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMIndexPath;      ///< 位置信息 👉NSIndexPath👈
AGVMConstKeyNameExtern kAGVMType;           ///< View Model 的类型 👉NSString👈
AGVMConstKeyNameExtern kAGVMIndex;          ///< 位置信息  👉NSNumber👈
AGVMConstKeyNameExtern kAGVMCapacity;       ///< 容量标记  👉NSNumber👈


#pragma mark 尺寸
AGVMConstKeyNameExtern kAGVMViewH;              ///< 视图高度 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMViewW;              ///< 视图宽度 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMViewAspectRatio;    ///< 宽高比 👉NSNumber👈
AGVMConstKeyNameExtern kAGVMViewEdgeInsets;     ///< 视图内边距 UIEdgeInsets 👉NSString👈
AGVMConstKeyNameExtern kAGVMViewEdgeMargin;     ///< 视图外边距 UIEdgeInsets 👉NSString👈


#pragma mark 颜色
AGVMConstKeyNameExtern kAGVMViewBGColor;        ///< view 背景色 👉UIColor👈
AGVMConstKeyNameExtern kAGVMViewDisplayType;    ///< view 显示类型 👉NSNumber👈


#pragma mark 元素
AGVMConstKeyNameExtern kAGVMTitleText;              ///< 标题内容 👉NSString👈
AGVMConstKeyNameExtern kAGVMTitlePlaceholder;       ///< 标题占位符 👉NSString👈
AGVMConstKeyNameExtern kAGVMTitleAttrText;          ///< 富文本标题 👉NSAttributedString👈
AGVMConstKeyNameExtern kAGVMTitleAttrPlaceholder;   ///< 富文本标题占位符 👉NSAttributedString👈
AGVMConstKeyNameExtern kAGVMTitleColor;             ///< 标题颜色 👉UIColor👈
AGVMConstKeyNameExtern kAGVMTitleFont;              ///< 标题字体大小 👉UIFont👈


AGVMConstKeyNameExtern kAGVMSubTitleText;           ///< 子标题内容 👉NSString👈
AGVMConstKeyNameExtern kAGVMSubTitlePlaceholder;    ///< 子标题占位符 👉NSString👈
AGVMConstKeyNameExtern kAGVMSubTitleAttrText;       ///< 富文本子标题 👉NSAttributedString👈
AGVMConstKeyNameExtern kAGVMSubTitleAttrPlaceholder;///< 富文本子标题占位符 👉NSAttributedString👈
AGVMConstKeyNameExtern kAGVMSubTitleColor;          ///< 子标题颜色 👉UIColor👈
AGVMConstKeyNameExtern kAGVMSubTitleFont;           ///< 子标题字体大小 👉UIFont👈


AGVMConstKeyNameExtern kAGVMDetailText;             ///< 详情内容 👉NSString👈
AGVMConstKeyNameExtern kAGVMDetailPlaceholder;      ///< 详情内容占位符 👉NSString👈
AGVMConstKeyNameExtern kAGVMDetailAttrText;         ///< 富文本详情内容 👉NSAttributedString👈
AGVMConstKeyNameExtern kAGVMDetailAttrPlaceholder;  ///< 富文本详情内容占位符 👉NSAttributedString👈
AGVMConstKeyNameExtern kAGVMDetailColor;            ///< 详情颜色 👉UIColor👈
AGVMConstKeyNameExtern kAGVMDetailFont;             ///< 详情字体大小 👉UIFont👈


AGVMConstKeyNameExtern kAGVMImage;              ///< 图片 👉UIImage👈
AGVMConstKeyNameExtern kAGVMPlaceholderImage;   ///< 占位图片 👉UIImage👈
AGVMConstKeyNameExtern kAGVMThumbnailImage;     ///< 缩略图 👉UIImage👈


AGVMConstKeyNameExtern kAGVMImageURLText;       ///< 网络图片 👉NSString👈
AGVMConstKeyNameExtern kAGVMImageURL;           ///< 网络图片 👉NSURL👈
AGVMConstKeyNameExtern kAGVMImageURLPlaceholder;///< 占位网络图片 👉NSString👈


AGVMConstKeyNameExtern kAGVMImageName; ///< 图片名 👉NSString👈

#endif /* AGVMKeys_h */
