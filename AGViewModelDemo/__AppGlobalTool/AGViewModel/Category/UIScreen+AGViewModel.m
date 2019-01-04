//
//  UIScreen+AGViewModel.m
//  
//
//  Created by JohnnyB0Y on 2019/1/4.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "UIScreen+AGViewModel.h"

@implementation UIScreen (AGViewModel)

#pragma mark - ----------- Getter Methods ----------
- (CGFloat)width
{
    return self.bounds.size.width;
}

- (CGFloat)height
{
    return self.bounds.size.height;
}

- (UIDeviceOrientation)deviceOrientation
{
    return [UIDevice currentDevice].orientation;
}

- (UIInterfaceOrientation)statusBarOrientation
{
    return [UIApplication sharedApplication].statusBarOrientation;
}

@end
