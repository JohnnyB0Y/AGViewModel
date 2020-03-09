//
//  UIView+AGViewModel.m
//  
//
//  Created by JohnnyB0Y on 2018/2/12.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "UIView+AGViewModel.h"
#import <objc/runtime.h>

static void *kAGViewModelProperty = &kAGViewModelProperty;
static void *kAGViewModelSubviewMT = &kAGViewModelSubviewMT;

@implementation UIView (AGViewModel)

#pragma mark - ---------- Public Methods ----------
+ (NSString *)ag_reuseIdentifier
{
    return NSStringFromClass(self);
}

+ (BOOL)ag_canAwakeNibInBundle:(NSBundle *)bundle
{
    if ( nil == bundle ) {
        bundle = [self ag_resourceBundle];
    }
    NSString *className = NSStringFromClass([self class]);
    NSString *nibPath = [bundle pathForResource:className ofType:@"nib"];
    if ( nil == nibPath ) {
        nibPath = [bundle pathForResource:className ofType:@"xib"];
    }
    return nibPath != nil;
}

+ (instancetype)ag_newFromNibInBundle:(NSBundle *)bundle
{
    if ( nil == bundle ) {
        bundle = [self ag_resourceBundle];
    }
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:bundle];
    return [[nib instantiateWithOwner:self options:nil] firstObject];
}

+ (NSBundle *)ag_resourceBundle
{
    return [NSBundle mainBundle];
}

#pragma mark management subview
- (void)ag_addSubview:(UIView *)view forKey:(NSString *)key
{
    [self addSubview:view];
    if (view && key) {
        [[self subviewMT] setObject:view forKey:key];
    }
}

- (nullable UIView *)ag_subviewForKey:(NSString *)key
{
    if (key) {
        return [[self subviewMT] objectForKey:key];
    }
    return nil;
}

- (void)ag_addSubview:(UIView *)view withName:(NSString *)name atPosition:(NSString *)position
{
    [self ag_addSubview:view forKey:[NSString stringWithFormat:@"%@%@", name, position]];
}

- (UIView *)ag_subviewWithName:(NSString *)name atPosition:(NSString *)position
{
    return [self ag_subviewForKey:[NSString stringWithFormat:@"%@%@", name, position]];
}

#pragma mark - ----------- Getter Setter Methods ----------
- (void)setViewModel:(AGViewModel *)viewModel
{
    objc_setAssociatedObject(self, kAGViewModelProperty, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AGViewModel *)viewModel
{
    return objc_getAssociatedObject(self, kAGViewModelProperty);
}

- (NSMapTable *)subviewMT
{
    id subviewMT = objc_getAssociatedObject(self, kAGViewModelSubviewMT);
    if (nil == subviewMT) {
        subviewMT = [NSMapTable strongToWeakObjectsMapTable];
        objc_setAssociatedObject(self, kAGViewModelSubviewMT, subviewMT, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return subviewMT;
}

- (CGFloat)width
{
    return CGRectGetWidth(self.frame);
}

- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height
{
    return CGRectGetHeight(self.frame);
}

- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)x
{
    return CGRectGetMinX(self.frame);
}

- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y
{
    return CGRectGetMinY(self.frame);
}

- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGFloat)centerX
{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX
{
    [self setCenter:CGPointMake(centerX, self.centerY)];
}

- (CGFloat)centerY
{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY
{
    [self setCenter:CGPointMake(self.centerX, centerY)];
}

@end

/// 标题控件
AGVMConstKeyNameDefine(kSVTitleLabel);
/// 子标题控件
AGVMConstKeyNameDefine(kSVSubtitleLabel);
/// 详情控件
AGVMConstKeyNameDefine(kSVDetailLabel);
/// 日期控件
AGVMConstKeyNameDefine(kSVDateLabel);
/// 头像控件
AGVMConstKeyNameDefine(kSVAvatarView);
/// 性别控件
AGVMConstKeyNameDefine(kSVSexView);
/// 分割线控件
AGVMConstKeyNameDefine(kSVPartingLine);

/// 位置-左
AGVMConstKeyNameDefine(pSVLeft);
/// 位置-右
AGVMConstKeyNameDefine(pSVRight);
/// 位置-顶
AGVMConstKeyNameDefine(pSVTop);
/// 位置-底
AGVMConstKeyNameDefine(pSVBottom);
/// 位置-中心
AGVMConstKeyNameDefine(pSVCenter);
