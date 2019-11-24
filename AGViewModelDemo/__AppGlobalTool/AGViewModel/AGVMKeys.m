#import "AGVMKeys.h"


#pragma mark - 携带数据相关
AGVMConstKeyNameDefine(kAGVMObject);         ///< 携带的对象 👉id👈
AGVMConstKeyNameDefine(kAGVMArray);          ///< 携带的数组 👉NSArray👈
AGVMConstKeyNameDefine(kAGVMTextArray);      ///< 携带的字符串数组 👉NSArray<NSString>👈
AGVMConstKeyNameDefine(kAGVMAttrTextArray);  ///< 携带的富文本字符串数组 👉NSArray<NSAttributedString>👈
AGVMConstKeyNameDefine(kAGVMNumberArray);    ///< 携带的数字数组 👉NSArray<NSNumber>👈
AGVMConstKeyNameDefine(kAGVMDictionary);     ///< 携带的字典 👉NSDictionary👈
AGVMConstKeyNameDefine(kAGViewModel);        ///< 携带的AGViewModel 👉AGViewModel👈
AGVMConstKeyNameDefine(kAGVMSection);        ///< 携带的AGVMSection 👉AGVMSection👈
AGVMConstKeyNameDefine(kAGVMManager);        ///< 携带的AGVMManager 👉AGVMManager👈
AGVMConstKeyNameDefine(kAGVMCommonVM);       ///< 携带的公共VM 👉AGViewModel👈
AGVMConstKeyNameDefine(kAGVMHeaderVM);       ///< 携带的头部VM 👉AGViewModel👈
AGVMConstKeyNameDefine(kAGVMFooterVM);       ///< 携带的尾部VM 👉AGViewModel👈


#pragma mark - 状态描述相关
AGVMConstKeyNameDefine(kAGVMSelected);   ///< 是否选中？ 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMDisabled);   ///< 是否禁用？ 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMDeleted);    ///< 是否删除？ 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMReloaded);   ///< 是否刷新？ 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMAdded);      ///< 是否添加？ 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMShowed);     ///< 是否显示？ 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMOpened);     ///< 是否打开？ 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMClosed);     ///< 是否关闭？ 👉NSNumber👈


#pragma mark - Block 的存取相关
AGVMConstKeyNameDefine(kAGVMTargetVCClass);  ///< 目标跳转控制器 - 类对象      👉Class👈
AGVMConstKeyNameDefine(kAGVMTargetVCTitle);  ///< 目标跳转控制器 - 标题       👉NSString👈
AGVMConstKeyNameDefine(kAGVMTargetVCType);   ///< 目标跳转控制器 - 类型       👉NSString👈
AGVMConstKeyNameDefine(kAGVMTargetVCBlock);  ///< 目标跳转控制器 - 执行的代码块 👉Block👈


#pragma mark - 显示的视图相关
AGVMConstKeyNameDefine(kAGVMViewClass);      ///< view 类对象 👉Class👈
AGVMConstKeyNameDefine(kAGVMView);           ///< view 对象 👉UIView👈
AGVMConstKeyNameDefine(kAGVMViewHidden);     ///< view 隐藏 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMViewClassName);  ///< view 类名字符串 👉NSString👈


#pragma mark 类型or标记
AGVMConstKeyNameDefine(kAGVMViewTag);        ///< view 标记 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMIndexPath);      ///< 位置信息 👉NSIndexPath👈
AGVMConstKeyNameDefine(kAGVMType);           ///< View Model 的类型 👉NSString👈
AGVMConstKeyNameDefine(kAGVMIndex);          ///< 位置信息  👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMCapacity);       ///< 容量标记  👉NSNumber👈


#pragma mark 尺寸
AGVMConstKeyNameDefine(kAGVMViewH);              ///< 视图高度 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMViewW);              ///< 视图宽度 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMViewAspectRatio);    ///< 宽高比 👉NSNumber👈
AGVMConstKeyNameDefine(kAGVMViewEdgeInsets);     ///< 视图内边距 UIEdgeInsets 👉NSString👈
AGVMConstKeyNameDefine(kAGVMViewEdgeMargin);     ///< 视图外边距 UIEdgeInsets 👉NSString👈


#pragma mark 颜色
AGVMConstKeyNameDefine(kAGVMViewBGColor);        ///< view 背景色 👉UIColor👈
AGVMConstKeyNameDefine(kAGVMViewDisplayType);    ///< view 显示类型 👉NSNumber👈


#pragma mark 元素
AGVMConstKeyNameDefine(kAGVMTitleText);              ///< 标题内容 👉NSString👈
AGVMConstKeyNameDefine(kAGVMTitlePlaceholder);       ///< 标题占位符 👉NSString👈
AGVMConstKeyNameDefine(kAGVMTitleAttrText);          ///< 富文本标题 👉NSAttributedString👈
AGVMConstKeyNameDefine(kAGVMTitleAttrPlaceholder);   ///< 富文本标题占位符 👉NSAttributedString👈
AGVMConstKeyNameDefine(kAGVMTitleColor);             ///< 标题颜色 👉UIColor👈
AGVMConstKeyNameDefine(kAGVMTitleFont);              ///< 标题字体大小 👉UIFont👈


AGVMConstKeyNameDefine(kAGVMSubTitleText);           ///< 子标题内容 👉NSString👈
AGVMConstKeyNameDefine(kAGVMSubTitlePlaceholder);    ///< 子标题占位符 👉NSString👈
AGVMConstKeyNameDefine(kAGVMSubTitleAttrText);       ///< 富文本子标题 👉NSAttributedString👈
AGVMConstKeyNameDefine(kAGVMSubTitleAttrPlaceholder);///< 富文本子标题占位符 👉NSAttributedString👈
AGVMConstKeyNameDefine(kAGVMSubTitleColor);          ///< 子标题颜色 👉UIColor👈
AGVMConstKeyNameDefine(kAGVMSubTitleFont);           ///< 子标题字体大小 👉UIFont👈


AGVMConstKeyNameDefine(kAGVMDetailText);             ///< 详情内容 👉NSString👈
AGVMConstKeyNameDefine(kAGVMDetailPlaceholder);      ///< 详情内容占位符 👉NSString👈
AGVMConstKeyNameDefine(kAGVMDetailAttrText);         ///< 富文本详情内容 👉NSAttributedString👈
AGVMConstKeyNameDefine(kAGVMDetailAttrPlaceholder);  ///< 富文本详情内容占位符 👉NSAttributedString👈
AGVMConstKeyNameDefine(kAGVMDetailColor);            ///< 详情颜色 👉UIColor👈
AGVMConstKeyNameDefine(kAGVMDetailFont);             ///< 详情字体大小 👉UIFont👈


AGVMConstKeyNameDefine(kAGVMImage);              ///< 图片 👉UIImage👈
AGVMConstKeyNameDefine(kAGVMPlaceholderImage);   ///< 占位图片 👉UIImage👈
AGVMConstKeyNameDefine(kAGVMThumbnailImage);     ///< 缩略图 👉UIImage👈


AGVMConstKeyNameDefine(kAGVMImageURLText);       ///< 网络图片 👉NSString👈
AGVMConstKeyNameDefine(kAGVMImageURL);           ///< 网络图片 👉NSURL👈
AGVMConstKeyNameDefine(kAGVMImageURLPlaceholder);///< 占位网络图片 👉NSString👈


AGVMConstKeyNameDefine(kAGVMImageName); ///< 图片名 👉NSString👈
