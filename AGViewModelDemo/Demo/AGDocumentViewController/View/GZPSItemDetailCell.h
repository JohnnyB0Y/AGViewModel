//
//  GZPSItemDetailCell.h
//  ProductionSafety
//
//  Created by JohnnyB0Y on 2017/11/5.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGVMKit.h"

@interface GZPSItemDetailCell : UITableViewCell <AGVMIncludable, AGTableCellReusable>

/** 持有的 viewModel */
@property (nonatomic, strong) AGViewModel *viewModel;

/** 从 nib 创建视图 */
+ (instancetype) ag_createFromNib;

@end
