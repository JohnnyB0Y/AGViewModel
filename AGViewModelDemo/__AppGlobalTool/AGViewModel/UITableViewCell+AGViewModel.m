//
//  UITableViewCell+AGViewModel.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/2/9.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "UITableViewCell+AGViewModel.h"
#import <objc/runtime.h>

static void *UITableViewCellViewModel;

@implementation UITableViewCell (AGViewModel)



#pragma mark - ---------- AGTableCellReusable ----------
+ (NSString *) ag_reuseIdentifier
{
	return NSStringFromClass([self class]);
}

+ (instancetype) ag_dequeueCellBy:(UITableView *)tableView for:(NSIndexPath *)indexPath
{
	if ( indexPath ) {
		return [tableView dequeueReusableCellWithIdentifier:[self ag_reuseIdentifier] forIndexPath:indexPath];
	}
	return [tableView dequeueReusableCellWithIdentifier:[self ag_reuseIdentifier]];
}

+ (void) ag_registerCellBy:(UITableView *)tableView
{
	NSString *className = NSStringFromClass([self class]);
	NSString *nibPath = [[NSBundle mainBundle] pathForResource:className ofType:@"nib"];
	if ( nibPath ) {
		UINib *nib = [UINib nibWithNibName:className bundle:nil];
		[tableView registerNib:nib forCellReuseIdentifier:[self ag_reuseIdentifier]];
	}
	else {
		[tableView registerClass:[self class] forCellReuseIdentifier:[self ag_reuseIdentifier]];
	}
}

#pragma mark - ----------- Getter Setter Methods ----------
- (void)setViewModel:(AGViewModel *)viewModel
{
	objc_setAssociatedObject(self, &UITableViewCellViewModel, viewModel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (AGViewModel *)viewModel
{
	return objc_getAssociatedObject(self, &UITableViewCellViewModel);
}

@end
