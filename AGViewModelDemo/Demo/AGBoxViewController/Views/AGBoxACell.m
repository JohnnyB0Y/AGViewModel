//
//  AGBoxACell.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/8/20.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGBoxACell.h"
#import "AGBoxVMKeys.h"

@interface AGBoxACell ()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *colorView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;


@end

@implementation AGBoxACell
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
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForBindingView:(UIScreen *)screen
{
    return CGSizeMake(100, 90);
}

- (void)setViewModel:(AGViewModel *)viewModel
{
    [super setViewModel:viewModel];
    // 取出数据赋值
    self.titleLabel.text = viewModel[kAGVMBoxTitle];
    self.colorView.backgroundColor = viewModel[kAGVMBoxColor];
    
    NSUInteger index = [viewModel[kAGBoxACellSegmentedControlSelectedIndex] integerValue];
    
    if ( self.segmentedControl.numberOfSegments > index ) {
        [self.segmentedControl setSelectedSegmentIndex:index];
    }
    
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


NSString * const kAGBoxACellSegmentedControlSelectedIndex
= @"kAGBoxACellSegmentedControlSelectedIndex";


