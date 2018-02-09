//
//  UICollectionReusableView+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/10.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "UICollectionReusableView+AGViewModel.h"
#import <objc/runtime.h>

static void *AGCollectionReusableViewModel;

@implementation UICollectionReusableView (AGViewModel)

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

#pragma mark - AGCollectionFooterViewReusable
+ (NSString *)ag_reuseIdentifier
{
    return NSStringFromClass([self class]);
}

+ (void)ag_registerFooterViewBy:(UICollectionView *)collectionView
{
    // 有特殊需求，请在子类重写。
    NSString *className = NSStringFromClass([self class]);
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if ( nibPath ) {
        UINib *nib = [UINib nibWithNibName:className bundle:nil];
        [collectionView registerNib:nib
         forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                withReuseIdentifier:[self ag_reuseIdentifier]];
    }
    else {
        [collectionView registerClass:[self class]
           forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                  withReuseIdentifier:[self ag_reuseIdentifier]];
    }
}

+ (UICollectionReusableView *)ag_dequeueFooterViewBy:(UICollectionView *)collectionView for:(NSIndexPath *)indexPath
{
    // 如果在此处奔溃，请优先检查视图是否已注册到 collectionView。
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                                              withReuseIdentifier:[self ag_reuseIdentifier]
                                                     forIndexPath:indexPath];
}

#pragma mark - AGCollectionHeaderViewReusable
+ (void)ag_registerHeaderViewBy:(UICollectionView *)collectionView
{
    // 有特殊需求，请在子类重写。
    NSString *className = NSStringFromClass([self class]);
    NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
    if ( nibPath ) {
        UINib *nib = [UINib nibWithNibName:className bundle:nil];
        [collectionView registerNib:nib
         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                withReuseIdentifier:[self ag_reuseIdentifier]];
    }
    else {
        [collectionView registerClass:[self class]
           forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                  withReuseIdentifier:[self ag_reuseIdentifier]];
    }
}

+ (UICollectionReusableView *)ag_dequeueHeaderViewBy:(UICollectionView *)collectionView for:(NSIndexPath *)indexPath
{
    // 如果在此处奔溃，请优先检查视图是否已注册到 collectionView。
    return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                              withReuseIdentifier:[self ag_reuseIdentifier]
                                                     forIndexPath:indexPath];
}

#pragma mark - ----------- AGVMIncludable -----------
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForBindingView:(CGSize)bvS
{
    // 有特殊需求，请在子类重写。
    if ( ! vm[kAGVMViewH] ) {
        bvS.height = 34.;
    }
    return bvS;
}

#pragma mark - ----------- Getter Setter Methods ----------
- (void)setViewModel:(AGViewModel *)viewModel
{
    objc_setAssociatedObject(self, &AGCollectionReusableViewModel, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AGViewModel *)viewModel
{
    return objc_getAssociatedObject(self, &AGCollectionReusableViewModel);
}

@end
