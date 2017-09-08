//
//  NSString+AGCalculate.h
//
//
//  Created by JohnnyB0Y on 2017/7/31.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  字符串计算分类

#import <UIKit/UIKit.h>

typedef CGSize(^AGSizeCalculateBlock)(NSString *text, CGSize screenS, CGSize maxS);


@interface NSString (AGCalculate)

/** 计算文字 size */
- (CGSize) ag_sizeOfFont:(UIFont *)font maxSize:(CGSize)maxS;
- (CGSize) ag_sizeOfFontSize:(CGFloat)fontSize maxSize:(CGSize)maxS;
- (CGSize) ag_sizeCalculateInBlock:(AGSizeCalculateBlock)block;

@end


NSString * ag_stringFromIntegerValue(NSInteger integer);
