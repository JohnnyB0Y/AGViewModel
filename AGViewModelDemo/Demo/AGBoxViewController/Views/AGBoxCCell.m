//
//  AGBoxCCell.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/8/20.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGBoxCCell.h"
#import "AGBoxVMKeys.h"

@interface AGBoxCCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;


@end

@implementation AGBoxCCell
#pragma mark - ----------- AGViewModelIncludable -----------
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForLayout:(UIScreen *)screen
{
    return CGSizeMake(144., 144.);
}

- (void)setViewModel:(AGViewModel *)viewModel
{
    [super setViewModel:viewModel];
    // 取出数据赋值
    self.titleLabel.text = viewModel[kAGVMBoxTitle];
    self.colorView.backgroundColor = viewModel[kAGVMBoxColor];
}

@end
