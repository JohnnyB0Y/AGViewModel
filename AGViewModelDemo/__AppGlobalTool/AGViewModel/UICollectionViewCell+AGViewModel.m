//
//  UICollectionViewCell+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/9.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "UICollectionViewCell+AGViewModel.h"
#import <objc/runtime.h>

static void *UICollectionViewCellViewModel;

@implementation UICollectionViewCell (AGViewModel)
#pragma mark - ---------- AGCollectionCellProtocol ----------
+ (NSString *) ag_reuseIdentifier
{
	return NSStringFromClass([self class]);
}

+ (void) ag_registerCellBy:(UICollectionView *)collectionView
{
	NSString *className = NSStringFromClass([self class]);
	NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
	if ( nibPath ) {
		UINib *nib = [UINib nibWithNibName:className bundle:nil];
		[collectionView registerNib:nib forCellWithReuseIdentifier:[self ag_reuseIdentifier]];
	}
	else {
		[collectionView registerClass:[self class] forCellWithReuseIdentifier:[self ag_reuseIdentifier]];
	}
}

+ (__kindof UICollectionViewCell *) ag_dequeueCellBy:(UICollectionView *)collectionView for:(NSIndexPath *)indexPath
{
	return [collectionView dequeueReusableCellWithReuseIdentifier:[self ag_reuseIdentifier] forIndexPath:indexPath];
}

#pragma mark - ----------- Getter Setter Methods ----------
- (void)setViewModel:(AGViewModel *)viewModel
{
	objc_setAssociatedObject(self, &UICollectionViewCellViewModel, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AGViewModel *)viewModel
{
	return objc_getAssociatedObject(self, &UICollectionViewCellViewModel);
}
@end
