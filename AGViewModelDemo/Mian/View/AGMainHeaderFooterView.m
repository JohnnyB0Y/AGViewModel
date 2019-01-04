//
//  AGMainHeaderFooterView.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/12/31.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGMainHeaderFooterView.h"
#import "AGVMKit.h"

@interface AGMainHeaderFooterView ()



@end


@implementation AGMainHeaderFooterView
#pragma mark - ----------- Life Cycle -----------
- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
	self = [super initWithReuseIdentifier:reuseIdentifier];
    if ( self ) {
        // 添加子视图
        [self _addSubviews];
        // 添加子视图约束
        [self _addSubviewCons];
        // 设置UI
        [self _setupUI];
		// 添加actions
		[self _addActions];
    }
    return self;
}

#pragma mark - ----------- AGViewModelIncludable -----------
- (void)setViewModel:(AGViewModel *)viewModel
{
	[super setViewModel:viewModel];
	// TODO
    self.textLabel.text = viewModel[kAGVMTitleText];
	
}

#pragma mark - ----------- Event Methods -----------



#pragma mark - ---------- Private Methods ----------
// 添加子视图
- (void) _addSubviews
{
    // ...
    
}

// 添加子视图约束
- (void) _addSubviewCons
{
    // ...
    
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
