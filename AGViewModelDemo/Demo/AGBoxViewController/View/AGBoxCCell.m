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
#pragma mark - ----------- Life Cycle -----------
- (void)awakeFromNib {
    [super awakeFromNib];
    // TODO
    // 添加子视图
    [self _addSubviews];
    // 添加子视图约束
    [self _addSubviewCons];
    
}

+ (instancetype) ag_createFromNib
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class])
                                bundle:nil];
    AGBoxCCell *item = [[nib instantiateWithOwner:self
                                                              options:nil] firstObject];
    return item;
}

#pragma mark - ---------- AGCollectionCellProtocol ----------
+ (NSString *) ag_reuseIdentifier
{
    return NSStringFromClass([self class]);
}

+ (void) ag_registerCellBy:(UICollectionView *)collectionView
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class])
                                bundle:nil];
    [collectionView registerNib:nib forCellWithReuseIdentifier:[self ag_reuseIdentifier]];
}

+ (__kindof UICollectionViewCell *) ag_dequeueCellBy:(UICollectionView *)collectionView for:(NSIndexPath *)indexPath
{
    return [collectionView dequeueReusableCellWithReuseIdentifier:[self ag_reuseIdentifier] forIndexPath:indexPath];
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
    
    bvS.width = 144.;
    bvS.height = 144.;
    
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
