////
////  AGLikeButtom.h
////
////  Created by JohnnyB0Y on 2017/4/8.
////  Copyright © 2017年 JohnnyB0Y. All rights reserved.
////  点赞按钮 （图片 + 文字）(功能待完善)
//
///**
// 问题
// 1.设置标题和设置enable状态有顺序依赖！
//
// */
//
//#import <UIKit/UIKit.h>
//@class AGLikeButtom;
//
///** 快速创建 likeBtn */
//AGLikeButtom * ag_likeButtom(UIEdgeInsets edgeInsets, CGFloat contentInterval, CGFloat height);
//
//
//@interface AGLikeButtom : UIControl <NSCopying>
//
///** 图片 */
//@property (nonatomic, strong, readonly) UIImageView *customImageView;
///** 文字 */
//@property (nonatomic, strong, readonly) UILabel *customTitleLabel;
//
///** 纯图片或文字时中心布局 */
//@property (nonatomic, assign) BOOL centerLayout;
//
///**
// 快速创建点赞按钮
//
// @param edgeInset 内容边缘间距
// @param contentInterval 图片和文字的间隔
// @param height 视图的高度
// @return 点赞按钮
// */
//+ (instancetype) ag_likeBtnWithContentEdgeInsets:(UIEdgeInsets)edgeInsets contentInterval:(CGFloat)contentInterval height:(CGFloat)height;
//
//- (instancetype) initWithContentEdgeInsets:(UIEdgeInsets)edgeInsets contentInterval:(CGFloat)contentInterval height:(CGFloat)height;
//
///** 快速设置图片、文字内容、文字颜色 */
//- (void) ag_setNorImage:(NSString *)imageName;
//- (void) ag_setHigImage:(NSString *)imageName;
//- (void) ag_setDisImage:(NSString *)imageName;
//- (void) ag_setSelImage:(NSString *)imageName;
//
//- (void) ag_setNorTitle:(NSString *)title;
//- (void) ag_setHigTitle:(NSString *)title;
//- (void) ag_setDisTitle:(NSString *)title;
//- (void) ag_setSelTitle:(NSString *)title;
//
//- (void) ag_setNorTitleColor:(UIColor *)color;
//- (void) ag_setHigTitleColor:(UIColor *)color;
//- (void) ag_setDisTitleColor:(UIColor *)color;
//- (void) ag_setSelTitleColor:(UIColor *)color;
//
//- (void) ag_setCornerRadius:(CGFloat)cornerRadius;
//- (void) ag_setImageCornerRadius:(CGFloat)cornerRadius;
//- (void) ag_setImageCircle;
//- (void) ag_setBackgroundImage:(UIImage *)image;
//- (void) ag_setBackgroundImageName:(NSString *)imageName;
//- (void) ag_setTitleFontSize:(CGFloat)fontSize;
//
//- (void) ag_setBorderWidth:(CGFloat)width;
//- (void) ag_setBorderColor:(UIColor *)color;
//
///** 提示标记微章 */
//- (void) ag_setBadgeImage:(NSString *)imageName;
//- (void) ag_setBadgeColor:(UIColor *)color;
//- (void) ag_setBadgeSize:(CGSize)size;
//- (void) ag_showBadge;
//- (void) ag_hideBadge;
//
///** 网络图片 */
//- (void) ag_setNorImageUrl:(NSString *)imageUrl placeholderImage:(NSString *)placeholder;
//
//@end
