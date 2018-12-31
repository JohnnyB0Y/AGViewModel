//
//  UIView+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/12.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "UIView+AGViewModel.h"
#import <objc/runtime.h>

static void *kAGViewModelProperty = &kAGViewModelProperty;

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
    // 有特殊需求，请在子类重写。
    if ( [self ag_canAwakeFromNib] ) {
        NSBundle *bundle = [self ag_currentBundle];
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:bundle];
        return [[nib instantiateWithOwner:self options:nil] firstObject];
    }
    return nil;
}

+ (NSBundle *) ag_currentBundle
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

#pragma mark - ----------- Getter Setter Methods ----------
- (void)setViewModel:(AGViewModel *)viewModel
{
    objc_setAssociatedObject(self, kAGViewModelProperty, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AGViewModel *)viewModel
{
    return objc_getAssociatedObject(self, kAGViewModelProperty);
}

@end
