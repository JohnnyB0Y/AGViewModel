//
//  AGBookListCell.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "AGBookListCell.h"
#import "AGBookAPIKeys.h"
#import <UIImageView+AFNetworking.h>

@interface AGBookListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end

@implementation AGBookListCell
#pragma mark - ----------- AGViewModelIncludable -----------
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForLayout:(UIScreen *)screen
{
    CGSize bvS = CGSizeMake(screen.width, 0);
    // 计算视图size
    CGFloat topH = 44.;
    CGFloat bottomH = 16.;
    
    CGSize maxS = CGSizeMake(screen.width - 32. - 60. - 8., CGFLOAT_MAX);
    NSString *summary = [vm ag_safeStringForKey:ak_AGBook_summary];
    CGFloat summaryH = [summary ag_sizeOfFont:self.summaryLabel.font
                                      maxSize:maxS].height;
    
    bvS.height = topH + summaryH + bottomH;
    
    if ( bvS.height < 90. ) {
        bvS.height = 90. + 32.;
    }
    return bvS;
}

- (void)setViewModel:(AGViewModel *)viewModel
{
	[super setViewModel:viewModel];
	// TODO
    // 把解析好的 API数据，赋值给视图。
    NSString *title = [viewModel ag_safeStringForKey:ak_AGBook_title];
    NSURL *imageURL = [viewModel ag_safeURLForKey:ak_AGBook_image];
    NSString *summary = [viewModel ag_safeStringForKey:ak_AGBook_summary];
    
    [self.titleLabel setText:title];
    [self.coverImageView setImageWithURL:imageURL];
    [self.summaryLabel setText:summary];
    
    // ...
    BOOL isSelected = [viewModel ag_safeBoolValueForKey:kAGVMSelected];
    UIColor *titleColor = isSelected ? [UIColor redColor] : [UIColor blackColor];
    [self.titleLabel setTextColor:titleColor];
}

#pragma mark - ----------- Event Methods -----------
- (void) coverImageViewTap:(UITapGestureRecognizer *)tap
{
    // 传递消息给控制器
    [self.viewModel ag_makeDelegateHandleAction:_cmd];
}


#pragma mark - ---------- Private Methods ----------
// 添加子视图
- (void) ag_addSubviews
{
    [super ag_addSubviews];
}

// 添加子视图约束
- (void) ag_layoutSubviews
{
    [super ag_layoutSubviews];
    
}

// 设置UI
- (void) ag_setupUI
{
    [super ag_setupUI];
    // ...
    self.coverImageView.userInteractionEnabled = YES;
}

- (void) ag_addActions
{
    [super ag_addActions];
	// ...
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(coverImageViewTap:)];
    
    [self.coverImageView addGestureRecognizer:tap];
}

#pragma mark - ----------- Getter Methods ----------



@end
