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

#pragma mark - ---------- AGTableCellReusable ----------
+ (NSString *) ag_reuseIdentifier
{
    return NSStringFromClass([self class]);
}

+ (instancetype) ag_dequeueCellBy:(UITableView *)tableView for:(NSIndexPath *)indexPath
{
    return [tableView dequeueReusableCellWithIdentifier:[self ag_reuseIdentifier] forIndexPath:indexPath];
}

+ (void) ag_registerCellBy:(UITableView *)tableView
{
    [tableView registerClass:[self class] forCellReuseIdentifier:[self ag_reuseIdentifier]];
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
    
    
    
    return bvS;
}

- (void)setViewModel:(AGViewModel *)viewModel
{
    _viewModel = viewModel;
    
    // 取出数据赋值
    NSString *title = _viewModel[kAGVMItemTitle];
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
