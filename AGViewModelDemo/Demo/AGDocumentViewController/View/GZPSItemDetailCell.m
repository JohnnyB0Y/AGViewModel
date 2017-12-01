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

+ (instancetype) ag_createFromNib
{
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class])
                                bundle:nil];
    return [[nib instantiateWithOwner:self options:nil] firstObject];
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
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class])
                                bundle:nil];
    [tableView registerNib:nib forCellReuseIdentifier:[self ag_reuseIdentifier]];
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
        NSString *detail = _viewModel[kAGVMItemDetail];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGSize textS = [detail ag_sizeCalculateInBlock:^CGSize(NSString *text, CGSize screenS, CGSize maxS) {
            maxS = CGSizeMake(width - 30., CGFLOAT_MAX);
            return [text ag_sizeOfFont:self.detailLabel.font maxSize:maxS];
        }];
        
        bvS.height = 33. + textS.height;
    }
    
    
    return bvS;
}

- (void)setViewModel:(AGViewModel *)viewModel
{
    _viewModel = viewModel;
    
    // 取出数据赋值
    NSString *detail = _viewModel[kAGVMItemDetail];
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
