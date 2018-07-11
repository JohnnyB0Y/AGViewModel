//
//  AGBookHandleReformer.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "AGBookHandleReformer.h"
#import "AGBookDetailAPIManager.h"
#import "AGBookListCellVMP.h"

@implementation AGBookHandleReformer

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)responseData
{
	NSDictionary *data = ag_safeDictionary(responseData);
	if ( [manager isKindOfClass:[AGBookDetailAPIManager class]] ) {
		// 图书详情
        AGBookListCellVMP *vmp = [AGBookListCellVMP new];
		return [vmp ag_packageData:data forObject:manager];
	}
	
	return nil;
}

@end
