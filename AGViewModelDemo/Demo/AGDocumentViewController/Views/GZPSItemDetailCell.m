//
//  GZPSItemDetailCell.m
//  ProductionSafety
//
//  Created by JohnnyB0Y on 2017/11/5.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "GZPSItemDetailCell.h"
#import "AGGlobalVMKeys.h"

@interface GZPSItemDetailCell ()

@property (weak, nonatomic) IBOutlet UILabel *detailLabel;


@end

@implementation GZPSItemDetailCell
#pragma mark - ----------- AGViewModelIncludable -----------
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForLayout:(UIScreen *)screen
{
    CGSize bvS = CGSizeMake(screen.width, 0);
    // 计算
    NSString *detail = vm[kAGVMItemDetail];
    CGSize maxS = CGSizeMake(screen.width - 32, CGFLOAT_MAX);
    CGSize textS = [detail ag_sizeOfFont:self.detailLabel.font maxSize:maxS];
    bvS.height = 36. + textS.height;
    
    return bvS;
}

- (void)setViewModel:(AGViewModel *)viewModel
{
    [super setViewModel:viewModel];
    // 取出数据赋值
    NSString *detail = viewModel[kAGVMItemDetail];
    [self.detailLabel setText:detail];
}

@end
