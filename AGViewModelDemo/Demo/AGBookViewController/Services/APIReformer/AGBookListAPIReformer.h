//
//  AGBookListAPIReformer.h
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGVMKit.h"
#import <CTNetworking.h>
#import "AGBookListCellVMP.h"
#import "AGAPIProtocol.h"

@interface AGBookListAPIReformer : NSObject  <CTAPIManagerDataReformer, AGAPIReformer>

/** vmp */
@property (nonatomic, strong, readonly) AGBookListCellVMP *bookListCellVMP;

@end
