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

static NSBundle *currentBundle;

@implementation UIView (AGViewModel)

#pragma mark - ---------- Public Methods ----------
+ (BOOL)ag_canAwakeFromNib
{
    NSBundle *bundle = [self ag_currentBundle];
    NSString *className = NSStringFromClass([self class]);
    NSString *nibPath = [bundle pathForResource:className ofType:@"nib"];
    return nibPath != nil;
}

+ (instancetype)ag_createFromNib
{
    NSBundle *bundle = [self ag_currentBundle];
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:bundle];
    return [[nib instantiateWithOwner:self options:nil] firstObject];
}

/** 从 nib 创建实例,没有nib 时返回 nil */
+ (instancetype) ag_safeCreateFromNib
{
    // 有特殊需求，请在子类重写。
    if ( [self ag_canAwakeFromNib] ) {
        return [self ag_createFromNib];
    }
    return nil;
}

+ (NSBundle *) ag_currentBundle
{
    if ( nil == currentBundle ) {
        currentBundle = [NSBundle bundleForClass:[self class]];
        NSURL *url = [currentBundle URLForResource:@"MyLibrary" withExtension:@"bundle"];
        if ( url == nil ) {
            url = [currentBundle URLForResource:@"ResourceFramework" withExtension:@"bundle"];
        }
        if ( url ) {
            currentBundle = [NSBundle bundleWithURL:url];
        }
    }
    return currentBundle;
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

- (CGFloat)width
{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width
{
    CGRect newFrame = CGRectMake(self.x, self.y, width, self.height);
    [self setFrame:newFrame];
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height
{
    CGRect newFrame = CGRectMake(self.x, self.y, self.width, height);
    [self setFrame:newFrame];
}

- (CGSize)size
{
    return self.frame.size;
}

- (void)setSize:(CGSize)size
{
    CGRect newFrame = CGRectMake(self.x, self.y, size.width, size.height);
    [self setFrame:newFrame];
}

- (CGFloat)x
{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x
{
    CGRect newFrame = CGRectMake(x, self.y, self.width, self.height);
    [self setFrame:newFrame];
}

- (CGFloat)y
{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y
{
    CGRect newFrame = CGRectMake(self.x, y, self.width, self.height);
    [self setFrame:newFrame];
}

- (CGPoint)origin
{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin
{
    CGRect newFrame = CGRectMake(origin.x, origin.y, self.width, self.height);
    [self setFrame:newFrame];
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
