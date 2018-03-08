//
//  NSString+AGCalculate.m
//
//
//  Created by JohnnyB0Y on 2017/7/31.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  字符串计算分类

#import "NSString+AGCalculate.h"

@implementation NSString (AGCalculate)

- (CGSize) ag_sizeOfFont:(UIFont *)font maxSize:(CGSize)maxS
{
    if ( self.length <= 0 ) return CGSizeZero;
    
    CGSize textS = [self boundingRectWithSize:maxS
                                      options:(NSStringDrawingTruncatesLastVisibleLine |
                                               NSStringDrawingUsesLineFragmentOrigin |
                                               NSStringDrawingUsesFontLeading)
                                   attributes:@{NSFontAttributeName : font}
                                      context:nil].size;
    return textS;
}

- (CGSize) ag_sizeOfFontSize:(CGFloat)fontSize maxSize:(CGSize)maxS
{
    if ( self.length <= 0 ) return CGSizeZero;
    
    UIFont *font = [UIFont systemFontOfSize:fontSize];
    return [self ag_sizeOfFont:font maxSize:maxS];
}

@end

