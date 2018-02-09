//
//  AGBoxACell.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/8/20.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGVMKit.h"

@interface AGBoxACell : UICollectionViewCell

/** 从 nib 创建实例 */
+ (instancetype) ag_createFromNib;

@end


UIKIT_EXTERN NSString * const kAGBoxACellSegmentedControlSelectedIndex;
