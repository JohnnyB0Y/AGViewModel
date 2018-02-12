//
//  UICollectionViewCell+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/9.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "UICollectionViewCell+AGViewModel.h"

@implementation UICollectionViewCell (AGViewModel)

#pragma mark - ---------- AGCollectionCellProtocol ----------
+ (NSString *) ag_reuseIdentifier
{
	return NSStringFromClass([self class]);
}

+ (void) ag_registerCellBy:(UICollectionView *)collectionView
{
    // 有特殊需求，请在子类重写。
    if ( [self canAwakeFromNib] ) {
        UINib *nib = [UINib nibWithNibName:NSStringFromClass([self class]) bundle:nil];
		[collectionView registerNib:nib forCellWithReuseIdentifier:[self ag_reuseIdentifier]];
	}
	else {
		[collectionView registerClass:[self class] forCellWithReuseIdentifier:[self ag_reuseIdentifier]];
	}
}

+ (__kindof UICollectionViewCell *) ag_dequeueCellBy:(UICollectionView *)collectionView for:(NSIndexPath *)indexPath
{
    // 如果在此处奔溃，请优先检查视图是否已注册到 collectionView。
	return [collectionView dequeueReusableCellWithReuseIdentifier:[self ag_reuseIdentifier] forIndexPath:indexPath];
}

#pragma mark - ----------- AGVMIncludable -----------
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForBindingView:(CGSize)bvS
{
    // 有特殊需求，请在子类重写。
    if ( ! vm[kAGVMViewH] ) {
        bvS.height = 54.;
    }
    if ( ! vm[kAGVMViewW] ) {
        bvS.width = 54.;
    }
    return bvS;
}

@end
