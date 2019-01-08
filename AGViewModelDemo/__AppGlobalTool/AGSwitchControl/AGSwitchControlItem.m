//
//  AGSwitchControlItem.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/1/6.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "AGSwitchControlItem.h"

@interface AGSwitchControlItem ()

/** title label */
@property (nonatomic, strong) UILabel *titleLabel;

/** under line */
@property (nonatomic, strong) UIView *underline;

@end

@implementation AGSwitchControlItem
#pragma mark - ----------- Life Cycle -----------
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if ( self ) {
        // 添加子视图
        [self _addSubviews];
    }
    return self;
}

#pragma mark - ----------- AGViewModelIncludable -----------
- (CGSize) ag_viewModel:(AGViewModel *)vm sizeForBindingView:(nonnull UIScreen *)screen
{
    NSString *title = vm[kAGVMTitleText];
    NSString *edgeStr = vm[kAGVMViewEdgeInsets];
    
    CGSize textS = [title ag_sizeOfFont:self.titleLabel.font maxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    if ( edgeStr ) {
        UIEdgeInsets edge = UIEdgeInsetsFromString(edgeStr);
        textS.width += edge.left + edge.right;
        textS.height += edge.top + edge.bottom;
    }
    else {
        textS.width += 16.;
        textS.height += 15.;
    }
    
    return textS;
}

- (void)setViewModel:(AGViewModel *)viewModel
{
	[super setViewModel:viewModel];
	// TODO
	NSString *title = viewModel[kAGVMTitleText];
    UIColor *color = viewModel[kAGVMTitleColor];
    UIFont *font = viewModel[kAGVMTitleFont];
    
    [self.titleLabel setText:title];
    
    if ( color ) {
        [self.titleLabel setTextColor:color];
    }
    
    if ( font ) {
        [self.titleLabel setFont:font];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.titleLabel.frame = self.contentView.frame;
    
    [self makeUnderlineCenter];
}

#pragma mark - ---------- Public Methods ----------
- (void)makeUnderlineCenter
{
    self.underline.x = (self.contentView.width - self.underline.width) * 0.5;
    self.underline.y = self.contentView.height - self.underline.height - _underlineBottomMargin;
}

#pragma mark - ---------- Private Methods ----------
// 添加子视图
- (void) _addSubviews
{
    // ...
    self.titleLabel = [UILabel new];
//    self.titleLabel.hidden = YES;
//    self.contentView.backgroundColor = [UIColor orangeColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.titleLabel];
    
    self.underline = [UIView new];
    self.underline.layer.cornerRadius = 2;
    self.underline.layer.masksToBounds = YES;
    self.underline.hidden = YES;
    self.underline.backgroundColor = [UIColor blackColor];
    self.underline.size = CGSizeMake(18., 4.);
    self.underlineBottomMargin = 2.;
    [self.contentView addSubview:self.underline];
}

#pragma mark - ----------- Getter Methods ----------




@end
