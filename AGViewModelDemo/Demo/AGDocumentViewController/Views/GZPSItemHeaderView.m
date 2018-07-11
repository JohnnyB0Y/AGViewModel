//
//  GZPSItemHeaderView.m
//  ProductionSafety
//
//  Created by JohnnyB0Y on 2017/11/5.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "GZPSItemHeaderView.h"
#import <Masonry.h>
#import "AGGlobalVMKeys.h"

@interface GZPSItemHeaderView ()

/** headerLine */
@property (strong, nonatomic) UIView *headerLine;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *subTitleLabel;
@property (strong, nonatomic) UIButton *arrowBtn;

@end

@implementation GZPSItemHeaderView
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
    }
    return self;
}

#pragma mark - ----------- AGViewModelIncludable -----------
- (void)setViewModel:(AGViewModel *)viewModel
{
    [super setViewModel:viewModel];
    // 取出数据赋值
    NSString *title = viewModel[kAGVMItemTitle];
    NSString *subTitle = viewModel[kAGVMItemSubTitle];
	BOOL isOpen = [viewModel ag_safeBoolValueForKey:kAGVMItemArrowIsOpen];
    
    [self.titleLabel setText:title];
    [self.subTitleLabel setText:subTitle];
	self.arrowBtn.selected = isOpen;
    
}


#pragma mark - ----------- Event Methods -----------
- (void) cellTap:(UITapGestureRecognizer *)tap
{
    _cellTap = _cmd;
    [self.viewModel ag_callDelegateToDoForAction:_cmd];
}

#pragma mark - ---------- Private Methods ----------
// 添加子视图
- (void) _addSubviews
{
    // ...
    [self.contentView addSubview:self.headerLine];
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subTitleLabel];
    [self.contentView addSubview:self.arrowBtn];
}

// 添加子视图约束
- (void) _addSubviewCons
{
    // ...
    [self.headerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(self.contentView);
        make.height.mas_equalTo(10.);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.contentView).mas_offset(5);
        make.left.mas_equalTo(16.);
    }];
    
    [self.subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.left.mas_equalTo(self.titleLabel.mas_right).mas_offset(16.);
    }];
    
    [self.arrowBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.titleLabel);
        make.right.mas_equalTo(-8.);
		make.size.mas_equalTo(CGSizeMake(16., 16.));
    }];
}

// 设置UI
- (void) _setupUI
{
    // ...
    UIView *bgView = [UIView new];
    bgView.backgroundColor = [UIColor whiteColor];
    self.backgroundView = bgView;
	
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cellTap:)];
    [self addGestureRecognizer:tap];
	
	[self.arrowBtn setImage:[UIImage imageNamed:@"arrow-down-o"] forState:UIControlStateNormal];
	[self.arrowBtn setImage:[UIImage imageNamed:@"arrow-up-o"] forState:UIControlStateSelected];
}



#pragma mark - ----------- Getter Methods ----------
- (UILabel *)titleLabel
{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont boldSystemFontOfSize:20.];
    }
    return _titleLabel;
}

- (UILabel *)subTitleLabel
{
    if (_subTitleLabel == nil) {
        _subTitleLabel = [[UILabel alloc] init];
        _subTitleLabel.textColor = [UIColor grayColor];
        _subTitleLabel.font = [UIFont systemFontOfSize:14.];
    }
    return _subTitleLabel;
}

- (UIButton *)arrowBtn
{
	if (_arrowBtn == nil) {
		_arrowBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	}
	return _arrowBtn;
}

- (UIView *)headerLine
{
    if (_headerLine == nil) {
        _headerLine = [UIView new];
        _headerLine.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    return _headerLine;
}

@end
