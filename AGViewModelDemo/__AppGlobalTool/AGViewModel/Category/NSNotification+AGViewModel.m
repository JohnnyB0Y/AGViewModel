//
//  NSNotification+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/11/28.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "NSNotification+AGViewModel.h"
#import "AGViewModel.h"
#import <objc/runtime.h>

static void *kAGViewModelProperty = &kAGViewModelProperty;

@implementation NSNotification (AGViewModel)

+ (instancetype) notificationWithName:(NSNotificationName)aName
                               object:(nullable id)anObject
                            viewModel:(nullable AGViewModel *)vm
{
    NSNotification *notification = [NSNotification notificationWithName:aName object:anObject];
    notification.viewModel = vm;
    return notification;
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
