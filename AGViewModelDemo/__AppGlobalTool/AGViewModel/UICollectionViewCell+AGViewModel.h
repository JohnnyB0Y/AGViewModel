//
//  UICollectionViewCell+AGViewModel.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/9.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGViewModel.h"
#import "AGVMProtocol.h"

@interface UICollectionViewCell (AGViewModel) <AGVMIncludable, AGTableCellReusable>

@end
