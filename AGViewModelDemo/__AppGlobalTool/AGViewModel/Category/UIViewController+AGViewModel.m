//
//  UIViewController+AGViewModel.m
//
//
//  Created by JohnnyB0Y on 2019/1/3.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "UIViewController+AGViewModel.h"
#import "UIView+AGViewModel.h"
#import <objc/runtime.h>

static void *kAGContextProperty = &kAGContextProperty;

@implementation UIViewController (AGViewModel)


#pragma mark - ----------- Life Cycle ----------
+ (instancetype)newWithContext:(AGViewModel *)context
{
    NSBundle *bundle = [UIView ag_currentBundle];
    NSString *clsName = NSStringFromClass(self);
    UIViewController *viewController = nil;
    
    switch ( [self typeOfCreateInstance] ) {
        case AGResourceFileTypeStoryboard: {
            viewController = [self _instanceCreateFromStoryboardWithName:clsName bundle:bundle];
            if ( viewController == nil ) {
                viewController = [self _instanceCreateFromNibWithName:clsName bundle:bundle];
                if ( viewController == nil ) {
                    viewController = [self _instanceCreateFromCode];
                }
            }
            
        } break;
            
        case AGResourceFileTypeNib: {
            viewController = [self _instanceCreateFromNibWithName:clsName bundle:bundle];
            if ( viewController == nil ) {
                viewController = [self _instanceCreateFromStoryboardWithName:clsName bundle:bundle];
                if ( viewController == nil ) {
                    viewController = [self _instanceCreateFromCode];
                }
            }
            
        } break;
            
        case AGResourceFileTypeCode: {
            viewController = [self _instanceCreateFromCode];
            
        } break;
    }
    
    if ( context && viewController ) {
        [viewController setContext:context];
        return viewController;
    }
    
    return viewController;
}

/** 从Storyboard文件创建控制器 和 传递contextVM */
+ (instancetype) newWithStoryboardWithContext:(nullable AGViewModel *)context
{
    NSBundle *bundle = [UIView ag_currentBundle];
    NSString *clsName = NSStringFromClass(self);
    return [self _instanceCreateFromStoryboardWithName:clsName bundle:bundle];
}

/** 从Nib文件创建控制器 和 传递contextVM */
+ (instancetype) newWithNibWithContext:(nullable AGViewModel *)context
{
    NSBundle *bundle = [UIView ag_currentBundle];
    NSString *clsName = NSStringFromClass(self);
    return [self _instanceCreateFromNibWithName:clsName bundle:bundle];
}

#pragma mark - ---------- Private Methods ----------
+ (instancetype) _instanceCreateFromStoryboardWithName:(NSString *)clsName bundle:(NSBundle *)bundle
{
    // 从 storyboard 创建
    NSString *sbPath = [bundle pathForResource:clsName ofType:@"storyboard"];
    if ( sbPath ) {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:clsName bundle:bundle];
        return [sb instantiateInitialViewController];
    }
    return nil;
}

+ (instancetype) _instanceCreateFromNibWithName:(NSString *)clsName bundle:(NSBundle *)bundle
{
    // 从 nib 创建
    NSString *nibPath = [bundle pathForResource:clsName ofType:@"nib"];
    if ( nibPath ) {
        return [[self alloc] initWithNibName:clsName bundle:bundle];
    }
    return nil;
}

+ (instancetype) _instanceCreateFromCode
{
    // 代码创建
    return [[self alloc] init];
}

#pragma mark override methods
+ (AGResourceFileType)typeOfCreateInstance
{
    return AGResourceFileTypeNib;
}

#pragma mark - ----------- Getter Methods ----------
- (AGViewModel *)context
{
    return objc_getAssociatedObject(self, kAGContextProperty);
}

#pragma mark - ----------- Setter Methods ----------
- (void)setContext:(AGViewModel *)context
{
    objc_setAssociatedObject(self, kAGContextProperty, context, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
