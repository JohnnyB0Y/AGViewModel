//
//  AGBoxBCell.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/8/20.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGBoxBCell.h"
#import "AGBoxVMKeys.h"

@interface AGBoxBCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;


@end

@implementation AGBoxBCell
#pragma mark - ----------- Life Cycle -----------
- (void)awakeFromNib {
    [super awakeFromNib];
    // TODO
    // 添加子视图
    [self _addSubviews];
    // 添加子视图约束
    [self _addSubviewCons];
    
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
    bvS.width = 110.;
    bvS.height = 110.;
    return bvS;
}

- (void)setViewModel:(AGViewModel *)viewModel
{
    [super setViewModel:viewModel];
    // 取出数据赋值
    self.titleLabel.text = viewModel[kAGVMBoxTitle];
    self.colorView.backgroundColor = viewModel[kAGVMBoxColor];
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

#pragma mark - ----------- Getter Methods ----------




@end
