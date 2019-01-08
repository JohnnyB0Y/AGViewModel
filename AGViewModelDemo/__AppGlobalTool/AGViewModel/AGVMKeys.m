#import <Foundation/Foundation.h>



#pragma mark - 携带数据相关
/** 携带的对象 👉id👈  */
NSString * const kAGVMObject = @"kAGVMObject";

/** 携带的数组 👉NSArray👈  */
NSString * const kAGVMArray = @"kAGVMArray";

/** 携带的字典 👉NSDictionary👈  */
NSString * const kAGVMDictionary = @"kAGVMDictionary";

/** 携带的AGViewModel 👉AGViewModel👈  */
NSString * const kAGViewModel = @"kAGViewModel";

/** 携带的AGVMSection 👉AGVMSection👈  */
NSString * const kAGVMSection = @"kAGVMSection";

/** 携带的AGVMManager 👉AGVMManager👈  */
NSString * const kAGVMManager = @"kAGVMManager";

/** 携带的公共VM 👉AGViewModel👈 */
NSString * const kAGVMCommonVM = @"kAGVMCommonVM";
/** 携带的头部VM 👉AGViewModel👈 */
NSString * const kAGVMHeaderVM = @"kAGVMHeaderVM";
/** 携带的尾部VM 👉AGViewModel👈 */
NSString * const kAGVMFooterVM = @"kAGVMFooterVM";

#pragma mark - 类型、状态描述相关
/** View Model 的类型 👉NSString👈 */
NSString * const kAGVMType = @"kAGVMType";

/** 位置信息 👉NSNumber👈 */
NSString * const kAGVMIndex = @"kAGVMIndex";

/** 容量 👉NSNumber👈 */
NSString * const kAGVMCapacity = @"kAGVMCapacity";

/** 是否选中？ 👉NSNumber👈 */
NSString * const kAGVMSelected = @"kAGVMSelected";

/** 是否禁用？ 👉NSNumber👈 */
NSString * const kAGVMDisabled = @"kAGVMDisabled";

/** 是否删除？ 👉NSNumber👈 */
NSString * const kAGVMDeleted = @"kAGVMDeleted";

/** 是否刷新？ 👉NSNumber👈 */
NSString * const kAGVMReloaded = @"kAGVMReloaded";

/** 是否添加？ 👉NSNumber👈 */
NSString * const kAGVMAdded = @"kAGVMAdded";

#pragma mark - 跳转的控制器相关
/** 目标跳转控制器 - 👉Class👈 */
NSString * const kAGVMTargetVCClass = @"kAGVMTargetVCClass";

/** 目标跳转控制器 - 标题 👉NSString👈 */
NSString * const kAGVMTargetVCTitle = @"kAGVMTargetVCTitle";

/** 目标跳转控制器 - 类型 👉NSString👈 */
NSString * const kAGVMTargetVCType = @"kAGVMTargetVCType";

/** 目标跳转控制器 - 执行的代码块 👉Block👈 */
NSString * const kAGVMTargetVCBlock = @"kAGVMTargetVCBlock";


#pragma mark - 显示的视图相关
/** view 类对象 👉Class👈 */
NSString * const kAGVMViewClass = @"kAGVMViewClass";

/** view 对象 👉UIView👈 */
NSString * const kAGVMView = @"kAGVMView";

/** view 类名字符串 👉NSString👈 */
NSString * const kAGVMViewClassName = @"kAGVMViewClassName";

#pragma mark 标记
/** view 标记 👉NSNumber👈 */
NSString * const kAGVMViewTag = @"kAGVMViewTag";

#pragma mark 尺寸
/** 视图高度 👉NSNumber👈 */
NSString * const kAGVMViewH = @"kAGVMViewH";

/** 视图宽度 👉NSNumber👈 */
NSString * const kAGVMViewW = @"kAGVMViewW";

/** 宽高比 👉NSNumber👈 */
NSString * const kAGVMViewAspectRatio = @"kAGVMViewAspectRatio";

/** 视图内边距 UIEdgeInsets 👉NSString👈 */
NSString * const kAGVMViewEdgeInsets = @"kAGVMViewEdgeInsets";

/** 视图外边距 UIEdgeInsets 👉NSString👈 */
NSString * const kAGVMViewEdgeMargin = @"kAGVMViewEdgeMargin";


#pragma mark 颜色
/** view 背景色 👉UIColor👈 */
NSString * const kAGVMViewBGColor = @"kAGVMViewBGColor";
/** view 显示类型 👉NSNumber👈 */
NSString * const kAGVMViewDisplayType = @"kAGVMViewDisplayType";


#pragma mark 元素
/** 标题内容 👉NSString👈 */
NSString * const kAGVMTitleText = @"kAGVMTitleText";
NSString * const kAGVMTitlePlaceholder = @"kAGVMTitlePlaceholder";
/** 标题颜色 👉UIColor👈 */
NSString * const kAGVMTitleColor = @"kAGVMTitleColor";
NSString * const kAGVMTitleFont = @"kAGVMTitleFont";

/** 子标题内容 👉NSString👈 */
NSString * const kAGVMSubTitleText = @"kAGVMSubTitleText";
NSString * const kAGVMSubTitlePlaceholder = @"kAGVMSubTitlePlaceholder";
/** 子标题颜色 👉UIColor👈 */
NSString * const kAGVMSubTitleColor = @"kAGVMSubTitleColor";
NSString * const kAGVMSubTitleFont = @"kAGVMSubTitleFont";

/** 详情内容 👉NSString👈 */
NSString * const kAGVMDetailText = @"kAGVMDetailText";
NSString * const kAGVMDetailPlaceholder = @"kAGVMDetailPlaceholder";
/** 详情颜色 👉UIColor👈 */
NSString * const kAGVMDetailColor = @"kAGVMDetailColor";
NSString * const kAGVMDetailFont = @"kAGVMDetailFont";

/** 图片 👉UIImage👈 */
NSString * const kAGVMImage = @"kAGVMImage";

/** 网络图片 👉NSString👈 */
NSString * const kAGVMImageURLText = @"kAGVMImageURLText";
NSString * const kAGVMImageURLPlaceholder = @"kAGVMImageURLPlaceholder";
