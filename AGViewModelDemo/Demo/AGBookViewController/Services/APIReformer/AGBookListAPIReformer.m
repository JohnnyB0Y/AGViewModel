//
//  AGBookListAPIReformer.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "AGBookListAPIReformer.h"
#import "AGBookListAPIManager.h"
#import "AGTaobaoListAPIManager.h"


@implementation AGBookListAPIReformer {
    AGBookListCellVMP *_bookListCellVMP;
}

- (id)manager:(CTAPIBaseManager *)manager reformData:(NSDictionary *)responseData
{
    // 豆瓣接口下架了，用淘宝接口模拟
	NSArray *list = ag_safeArray(responseData[@"result"]);
    
    static int page = 0; // 模拟数据分页
    if ([manager isKindOfClass:[AGBookListAPIManager class]]) {
        BOOL isFirstPage = [manager performSelector:@selector(isFirstPage)];
        page = isFirstPage ? 1 : page + 1;
    }
    NSMutableArray *arrM = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSString *summary = @"我是段描述信息";
            if (idx % 3 == 0) {
                summary = @"我是一段长长的描述信息，我是一段长长的描述信息，我是一段长长的描述信息，我是一段长长的描述信息，我是一段长长的描述信息。";
            }
            else if (idx % 3 == 1) {
                summary = @"最近想做一些公共服务demo，例如天气预报，翻译等，需要用到一些接口，于是就收集了各种免费 api 接口资源，特汇总给大家，便于大家查找。最近想做一些公共服务demo，例如天气预报，翻译等，需要用到一些接口，于是就收集了各种免费 api 接口资源，特汇总给大家，便于大家查找。";
            }
            
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"title"] = [NSString stringWithFormat:@"%@: %d", [obj firstObject], page];
            dictM[@"image"] = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fbpic.588ku.com%2Felement_origin_min_pic%2F00%2F85%2F21%2F2456e89031013a0.jpg&refer=http%3A%2F%2Fbpic.588ku.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1622879215&t=ae8ef03dab8088895279eb5525c19e5f";
            dictM[@"summary"] = [NSString stringWithFormat:@"%@: %@", dictM[@"title"], summary];
            dictM[@"isbn10"] = @"1100";
            
            [arrM addObject:dictM];
        }
        else {
            [arrM addObject:obj];
        }
    }];
    list = [arrM copy];
    
	if ( [manager isKindOfClass:[AGBookListAPIManager class]] ) {
		// 书籍列表
        AGVMManager *vmm = ag_newAGVMManager(1);
		// 打包书籍
        [vmm ag_packageSectionItems:list packager:self.bookListCellVMP forObject:manager];
		
		return vmm;
	}
	
	return nil;
}

- (id)ag_reformData:(id)data options:(id)options forAPIManager:(AGAPIManager *)manager {
    // 豆瓣接口下架了，用淘宝接口模拟
    NSArray *list = ag_safeArray(data[@"result"]);
    
    if (list.count < 1) {
        return nil;
    }
    
    static int page = 0; // 模拟数据分页
    if ([manager isKindOfClass:[AGTaobaoListAPIManager class]]) {
        BOOL isFirstPage = [manager performSelector:@selector(isFirstPage)];
        page = isFirstPage ? 1 : page + 1;
    }
    NSMutableArray *arrM = [NSMutableArray array];
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[NSArray class]]) {
            NSString *summary = @"我是段描述信息";
            if (idx % 3 == 0) {
                summary = @"我是一段长长的描述信息，我是一段长长的描述信息，我是一段长长的描述信息，我是一段长长的描述信息，我是一段长长的描述信息。";
            }
            else if (idx % 3 == 1) {
                summary = @"最近想做一些公共服务demo，例如天气预报，翻译等，需要用到一些接口，于是就收集了各种免费 api 接口资源，特汇总给大家，便于大家查找。最近想做一些公共服务demo，例如天气预报，翻译等，需要用到一些接口，于是就收集了各种免费 api 接口资源，特汇总给大家，便于大家查找。";
            }
            
            NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
            dictM[@"title"] = [NSString stringWithFormat:@"%@: %d", [obj firstObject], page];
            dictM[@"image"] = @"https://gimg2.baidu.com/image_search/src=http%3A%2F%2Fbpic.588ku.com%2Felement_origin_min_pic%2F00%2F85%2F21%2F2456e89031013a0.jpg&refer=http%3A%2F%2Fbpic.588ku.com&app=2002&size=f9999,10000&q=a80&n=0&g=0n&fmt=jpeg?sec=1622879215&t=ae8ef03dab8088895279eb5525c19e5f";
            dictM[@"summary"] = [NSString stringWithFormat:@"%@: %@", dictM[@"title"], summary];
            dictM[@"isbn10"] = @"1100";
            
            [arrM addObject:dictM];
        }
        else {
            [arrM addObject:obj];
        }
    }];
    list = [arrM copy];
    
    if ( [manager isKindOfClass:[AGTaobaoListAPIManager class]] ) {
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
