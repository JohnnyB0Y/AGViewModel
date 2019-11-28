//
//  UIViewController+AGViewModel.h
//  
//
//  Created by JohnnyB0Y on 2019/1/3.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGVMProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (AGViewModel)
<AGViewControllerProtocol>

- (void)setContext:(nullable AGViewModel *)context NS_REQUIRES_SUPER;
- (nullable AGViewModel *)context NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
