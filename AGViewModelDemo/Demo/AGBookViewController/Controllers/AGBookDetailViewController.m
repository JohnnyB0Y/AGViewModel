//
//  AGBookDetailViewController.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "AGBookDetailViewController.h"
#import <UIImageView+AFNetworking.h>
#import "AGBookAPIKeys.h"

@interface AGBookDetailViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *coverImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *summaryLabel;

@end

@implementation AGBookDetailViewController

#pragma mark - ----------- Life Cycle ----------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self _addSubviews];
    
    [self _addSubviewCons];
    
    [self _setupUI];
    
    [self _addActions];
    
    [self _networkRequest];
}

#pragma mark - ---------- Event Methods ----------
- (void) rightBarButtonItemClick:(id)sender
{
    self.context[kAGVMDeleted] = @(YES);
}

#pragma mark - ---------- Private Methods ----------
#pragma mark add SubViews
- (void) _addSubviews
{
    
}

#pragma mark add SubViewCons
- (void) _addSubviewCons
{
    
}

#pragma mark setup UI
- (void) _setupUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = [self.context ag_safeStringForKey:ak_AGBook_title];
    
    NSString *title = [self.context ag_safeStringForKey:ak_AGBook_title];
    NSURL *imageURL = [self.context ag_safeURLForKey:ak_AGBook_image];
    NSString *summary = [self.context ag_safeStringForKey:ak_AGBook_summary];
    
    [self.titleLabel setText:title];
    [self.coverImageView setImageWithURL:imageURL];
    [self.summaryLabel setText:summary];
}

#pragma mark add actions
- (void) _addActions
{
    // TODO
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"删除" style:UIBarButtonItemStyleDone target:self action:@selector(rightBarButtonItemClick:)];
    
}

#pragma mark network request
- (void) _networkRequest
{
    
}

@end
