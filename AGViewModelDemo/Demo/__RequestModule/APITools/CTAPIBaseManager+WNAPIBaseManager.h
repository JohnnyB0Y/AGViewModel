//
//  CTAPIBaseManager+WNAPIBaseManager.h
//  WritingNotes
//
//  Created by JohnnyB0Y on 2018/5/13.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "CTAPIBaseManager.h"
#import <AGVerifyManager/AGVerifyManager.h>
#import "AGVMKit.h"
#import <CTNetworking.h>

@interface CTAPIBaseManager (WNAPIBaseManager)

/** 过滤器错误信息 */
@property (nonatomic, strong) AGVerifyError *verifyError;

/** vm */
@property (nonatomic, strong) AGViewModel *viewModel;

@end
