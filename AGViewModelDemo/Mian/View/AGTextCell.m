//
//  AGTextCell.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/11/12.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGTextCell.h"

@interface AGTextCell ()



@end

@implementation AGTextCell
#pragma mark - ----------- Life Cycle -----------
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    
    if (self) {
        // TODO
        // 添加子视图
        [self _addSubviews];
        // 添加子视图约束
        [self _addSubviewCons];
        // 设置UI
        [self _setupUI];
    }
    
    return self;
}

#pragma mark - ----------- AGViewModelIncludable -----------
- (void)setViewModel:(AGViewModel *)viewModel
{
    [super setViewModel:viewModel];
    // 取出数据赋值
    NSString *title = self.viewModel[kAGVMItemTitle];
    [self.textLabel setText:title];
	
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
