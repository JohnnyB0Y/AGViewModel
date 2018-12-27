//
//  AGBookListAPIReformer.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "AGBookListAPIReformer.h"
#import "AGBookListAPIManager.h"


@implementation AGBookListAPIReformer {
    AGBookListCellVMP *_bookListCellVMP;
}

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)responseData
{
	NSArray *list = ag_safeArray(responseData[@"books"]);
	if ( [manager isKindOfClass:[AGBookListAPIManager class]] ) {
		// 书籍列表
        AGVMManager *vmm = ag_newAGVMManager(1);
		// 打包书籍
        [vmm ag_packageSectionItems:list packager:self.bookListCellVMP forObject:manager];
		
		return vmm;
	}
	
	return nil;
}

#pragma mark - ----------- Getter Methods ----------
- (AGBookListCellVMP *)bookListCellVMP
{
    if (_bookListCellVMP == nil) {
        _bookListCellVMP = [AGBookListCellVMP new];
    }
    return _bookListCellVMP;
}

@end
