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
	// 添加actions
	[self _addActions];
}

#pragma mark - ----------- AGViewModelIncludable -----------
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForBindingView:(UIScreen *)screen
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
    NSString *title = [viewModel ag_safeStringForKey:ak_AGBook_title];
    NSURL *imageURL = [viewModel ag_safeURLForKey:ak_AGBook_image];
    NSString *summary = [viewModel ag_safeStringForKey:ak_AGBook_summary];
    
    [self.titleLabel setText:title];
    [self.coverImageView setImageWithURL:imageURL];
    [self.summaryLabel setText:summary];
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

- (void) _addActions
{
	// ...
	
}

#pragma mark - ----------- Getter Methods ----------



@end
