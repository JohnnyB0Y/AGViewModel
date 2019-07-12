//
//  AGVMTableViewCell.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2019/7/12.
//  Copyright © 2019 JohnnyB0Y. All rights reserved.
//

#import "AGVMTableViewCell.h"

@implementation AGVMTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if ( self ) {
        [self ag_addSubviews];
        [self ag_layoutSubviews];
        [self ag_setupUI];
        [self ag_addActions];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self ag_addSubviews];
    [self ag_layoutSubviews];
    [self ag_setupUI];
    [self ag_addActions];
    
}

#pragma mark Override Methods
- (void)ag_addSubviews
{
    
}

- (void)ag_layoutSubviews
{
    
}

- (void)ag_setupUI
{
    
}

- (void)ag_addActions
{
    
}

@end
