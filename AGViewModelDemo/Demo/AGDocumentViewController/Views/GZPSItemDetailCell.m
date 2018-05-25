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
#pragma mark - ----------- Life Cycle -----------
- (void)awakeFromNib {
    [super awakeFromNib];
    // TODO
    // 添加子视图
    [self _addSubviews];
    // 添加子视图约束
    [self _addSubviewCons];
    // 设置UI
    [self _setupUI];
}

#pragma mark - ----------- AGViewModelIncludable -----------
/**
 计算返回 bindingView 的 size
 
 @param vm viewModel
 @param bvS bindingViewSize
 @return 计算后的 Size
 */
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForBindingView:(CGSize)bvS
{
    // 计算
    if ( bvS.height < 44.) {
        NSString *detail = vm[kAGVMItemDetail];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGSize maxS = CGSizeMake(width - 30, CGFLOAT_MAX);
        CGSize textS = [detail ag_sizeOfFont:self.detailLabel.font maxSize:maxS];
        bvS.height = 33. + textS.height;
    }
    
    return bvS;
}

- (void)setViewModel:(AGViewModel *)viewModel
{
    [super setViewModel:viewModel];
    // 取出数据赋值
    NSString *detail = viewModel[kAGVMItemDetail];
    [self.detailLabel setText:detail];
}

#pragma mark - ----------- Event Methods -----------



#pragma mark - ---------- Private Methods ----------
// 添加子视图
- (void) _addSubviews
{
    
}

// 添加子视图约束
- (void) _addSubviewCons
{
    
}

// 设置UI
- (void) _setupUI
{
    // ...
    
}

#pragma mark - ----------- Getter Methods ----------



@end
