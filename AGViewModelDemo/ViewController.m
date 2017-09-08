//
//  ViewController.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2017/4/23.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "ViewController.h"
#import "AGBoxCollectionViewController.h"
#import "AGVMKit.h"

@interface ViewController ()

/** vm */
@property (nonatomic, strong) AGViewModel *vm;

/** textField */
@property (nonatomic, strong) UITextField *textField;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // add Target
    [self.textField addTarget:self action:@selector(textFieldEditingChanged:) forControlEvents:UIControlEventEditingChanged];
    
    
    // VM Notify
    __weak typeof(self) weakSelf = self;
    [self.vm ag_addObserver:self forKeys:@[kAGVMTargetVCTitle] block:^(AGViewModel * _Nonnull vm, NSString * _Nonnull key, NSDictionary<NSKeyValueChangeKey,id> * _Nonnull change) {
        
        NSString *title = change[NSKeyValueChangeNewKey];
        NSLog(@"模型修改标题 : %@ - %@", title, key);
        
        [weakSelf setTitle:title];
        
    }];
    
    
    // 模型修改
    self.vm[kAGVMTargetVCTitle] = @"龙的传人";
}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
    
    // 进入
    AGBoxCollectionViewController *vc
    = [AGBoxCollectionViewController ag_viewControllerWithViewModel:nil];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - ---------- Event Methods ----------
- (void) textFieldEditingChanged:(UITextField *)tf
{
    NSLog(@"用户输入标题 : %@", tf.text);
    self.vm[kAGVMTargetVCTitle] = tf.text;
}

#pragma mark - ----------- Getter Methods ----------
- (AGViewModel *)vm
{
    if (_vm == nil) {
        NSDictionary *dict = @{kAGVMViewW : @44};
        _vm = ag_viewModel(dict);
    }
    return _vm;
}

- (UITextField *)textField
{
    if (_textField == nil) {
        CGFloat width = 300.;
        CGFloat height = 30.;
        CGFloat x = (self.view.frame.size.width - width) / 2.;
        CGFloat y = 220;
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(x, y, width, height)];
        _textField.borderStyle = UITextBorderStyleRoundedRect;
        _textField.placeholder = @"修改标题";
        [self.view addSubview:_textField];
    }
    return _textField;
}

@end
