//
//  AGSwitchControlItem.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/1/6.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGVMKit.h"

@interface AGSwitchControlItem : UICollectionViewCell

/** title label */
@property (nonatomic, strong, readonly) UILabel *titleLabel;

/** under line */
@property (nonatomic, strong, readonly) UIView *underline;

/** under line bottom margin */
@property (nonatomic, assign) CGFloat underlineBottomMargin;

- (void) makeUnderlineCenter;

@end
