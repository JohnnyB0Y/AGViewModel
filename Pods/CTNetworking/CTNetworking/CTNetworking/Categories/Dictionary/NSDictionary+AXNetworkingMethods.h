//
//  NSDictionary+AXNetworkingMethods.h
//  RTNetworking
//
//  Created by casa on 14-5-6.
//  Copyright (c) 2014年 casatwy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (AXNetworkingMethods)

- (NSString *)CT_jsonString;
- (NSString *)CT_transformToUrlParamString;

@end
