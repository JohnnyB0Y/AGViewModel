//
//  UIView+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/12.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "UIView+AGViewModel.h"
#import <objc/runtime.h>

static void *kAGViewModelProperty;

@implementation UIView (AGViewModel)

+ (BOOL)canAwakeFromNib
{
    NSString *className = NSStringFromClass([self class]);
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    return nibPath != nil;
}

+ (instancetype)ag_createFromNib
{
    // 有特殊需求，请在子类重写。
    if ( [self canAwakeFromNib] ) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
        return [[nib instantiateWithOwner:self options:nil] firstObject];
    }
    return nil;
}

#pragma mark - ----------- Getter Setter Methods ----------
- (void)setViewModel:(AGViewModel *)viewModel
{
    objc_setAssociatedObject(self, &kAGViewModelProperty, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AGViewModel *)viewModel
{
    return objc_getAssociatedObject(self, &kAGViewModelProperty);
}

@end
