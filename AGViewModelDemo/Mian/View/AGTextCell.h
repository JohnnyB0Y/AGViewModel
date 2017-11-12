//
//  AGTextCell.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/11/12.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGVMKit.h"
#import "AGGlobalVMKeys.h"

@interface AGTextCell : UITableViewCell <AGVMIncludable, AGTableCellReusable>

/** 持有的 viewModel */
@property (nonatomic, strong) AGViewModel *viewModel;


@end
