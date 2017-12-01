//
//  GZPSItemHeaderView.h
//  ProductionSafety
//
//  Created by JohnnyB0Y on 2017/11/5.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGVMKit.h"

@interface GZPSItemHeaderView : UITableViewHeaderFooterView <AGVMIncludable, AGTableHeaderFooterViewReusable>


/** 持有的 viewModel */
@property (nonatomic, strong) AGViewModel *viewModel;

/** tap */
@property (nonatomic, assign) SEL cellTap;


@end
