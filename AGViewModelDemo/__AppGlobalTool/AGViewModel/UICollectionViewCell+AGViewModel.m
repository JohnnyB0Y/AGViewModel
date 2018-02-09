//
//  UICollectionViewCell+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/9.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "UICollectionViewCell+AGViewModel.h"
#import <objc/runtime.h>

static void *AGCollectionViewCellViewModel;

@implementation UICollectionViewCell (AGViewModel)

+ (instancetype)ag_createFromNib
{
    // 有特殊需求，请在子类重写。
    NSString *className = NSStringFromClass([self class]);
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if ( nibPath ) {
        UINib *nib = [UINib nibWithNibName:className bundle:nil];
        return [[nib instantiateWithOwner:self options:nil] firstObject];
    }
    return nil;
}

#pragma mark - ---------- AGCollectionCellProtocol ----------
+ (NSString *) ag_reuseIdentifier
{
	return NSStringFromClass([self class]);
}

+ (void) ag_registerCellBy:(UICollectionView *)collectionView
{
    // 有特殊需求，请在子类重写。
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

#pragma mark - ----------- Getter Setter Methods ----------
- (void)setViewModel:(AGViewModel *)viewModel
{
	objc_setAssociatedObject(self, &AGCollectionViewCellViewModel, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AGViewModel *)viewModel
{
	return objc_getAssociatedObject(self, &AGCollectionViewCellViewModel);
}
@end
