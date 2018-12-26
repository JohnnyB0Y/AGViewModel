//
//  UITableViewCell+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/9.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "UITableViewCell+AGViewModel.h"

@implementation UITableViewCell (AGViewModel)

#pragma mark - ---------- AGTableCellReusable ----------
+ (NSString *) ag_reuseIdentifier
{
	return NSStringFromClass([self class]);
}

+ (void) ag_registerCellBy:(UITableView *)tableView
{
    // 有特殊需求，请在子类重写。
    if ( [self ag_canAwakeFromNib] ) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier:[self ag_reuseIdentifier]];
	}
	else {
		[tableView registerClass:[self class] forCellReuseIdentifier:[self ag_reuseIdentifier]];
	}
}

+ (instancetype) ag_dequeueCellBy:(UITableView *)tableView for:(NSIndexPath *)indexPath
{
    // 如果在此处奔溃，请优先检查视图是否已注册到 tableView。
    if ( indexPath ) {
        return [tableView dequeueReusableCellWithIdentifier:[self ag_reuseIdentifier] forIndexPath:indexPath];
    }
    return [tableView dequeueReusableCellWithIdentifier:[self ag_reuseIdentifier]];
}

#pragma mark - ----------- AGVMIncludable -----------
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForBindingView:(CGSize)bvS
{
    // 有特殊需求，请在子类重写。
    if ( ! vm[kAGVMViewH] ) {
        bvS.height = 44.;
    }
    return bvS;
}

- (void)setViewModel:(AGViewModel *)viewModel
{
    [super setViewModel:viewModel];
    
    self.textLabel.text = [viewModel ag_safeStringForKey:kAGVMTitleText];
    UIImage *image = viewModel[kAGVMImage];
    if ( [image isKindOfClass:[UIImage class]] ) {
        self.imageView.image = image;
    }
}

@end
