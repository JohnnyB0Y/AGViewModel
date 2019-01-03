//
//  UIViewController+AGViewModel.m
//
//
//  Created by JohnnyB0Y on 2019/1/3.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "UIViewController+AGViewModel.h"
#import <objc/runtime.h>

static void *kAGContextProperty = &kAGContextProperty;

@implementation UIViewController (AGViewModel)


#pragma mark - ----------- Life Cycle ----------
+ (instancetype)newWithContext:(AGViewModel *)context
{
    NSBundle *bundle = [self _currentBundle];
    NSString *clsName   = NSStringFromClass(self);
    UIViewController *viewController = nil;
    
    switch ( [self typeOfCreateInstance] ) {
        case 0: {
            viewController = [self _instanceCreateFromStoryboardWithName:clsName bundle:bundle];
            if ( viewController == nil ) {
                viewController = [self _instanceCreateFromNibWithName:clsName bundle:bundle];
                if ( viewController == nil ) {
                    viewController = [self _instanceCreateFromCode];
                }
            }
            
        } break;
            
        case 1: {
            viewController = [self _instanceCreateFromNibWithName:clsName bundle:bundle];
            if ( viewController == nil ) {
                viewController = [self _instanceCreateFromStoryboardWithName:clsName bundle:bundle];
                if ( viewController == nil ) {
                    viewController = [self _instanceCreateFromCode];
                }
            }
            
        } break;
            
        case 2: {
            viewController = [self _instanceCreateFromCode];
            
        } break;
    }
    
    if ( context && viewController ) {
        [viewController setContext:context];
        return viewController;
    }
    
    return viewController;
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

+ (NSBundle *) _currentBundle
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSURL *url = [bundle URLForResource:@"MyLibrary" withExtension:@"bundle"];
    if ( url == nil ) {
        url = [bundle URLForResource:@"ResourceFramework" withExtension:@"bundle"];
    }
    if ( url ) {
        bundle = [NSBundle bundleWithURL:url];
    }
    return bundle;
}

#pragma mark override methods
+ (AGViewControllerFromType)typeOfCreateInstance
{
    return AGViewControllerFromNib;
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
