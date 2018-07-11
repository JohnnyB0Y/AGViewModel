//
//  CTAPIBaseManager+WNAPIBaseManager.m
//  WritingNotes
//
//  Created by JohnnyB0Y on 2018/5/13.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "CTAPIBaseManager+WNAPIBaseManager.h"
#import <objc/runtime.h>

static void *kWNAPIBaseManagerVerifyError = &kWNAPIBaseManagerVerifyError;

@implementation CTAPIBaseManager (WNAPIBaseManager)

- (void)setVerifyError:(AGVerifyError *)verifyError
{
    objc_setAssociatedObject(self, kWNAPIBaseManagerVerifyError, verifyError, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AGVerifyError *)verifyError
{
    return objc_getAssociatedObject(self, kWNAPIBaseManagerVerifyError);
}

@end
