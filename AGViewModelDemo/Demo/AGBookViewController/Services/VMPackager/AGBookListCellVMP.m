//
//  AGBookListCellVMP.m
//  AGViewModelDemo
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import "AGBookListCellVMP.h"
#import "AGBookListCell.h"
#import "AGBookAPIKeys.h"

@implementation AGBookListCellVMP

- (AGViewModel *) ag_packageData:(NSDictionary *)dict forObject:(id)obj
{
    // 组装数据，需要做归档
    AGViewModel *vm = [[AGVMPackager sharedInstance] ag_packageData:^(AGViewModel * _Nonnull package) {
        // 解析 API 数据
        package[ak_AGBook_title] = dict[@"title"];
        package[ak_AGBook_image] = dict[@"image"];
        
        NSString *summary = dict[@"summary"];
        summary = [summary stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        package[ak_AGBook_summary] = summary;
        
        package[ak_AGBook_isbn] = dict[@"isbn10"];
        package[kAGVMViewClass] = AGBookListCell.class;
        package[kAGVMViewClassName] = NSStringFromClass(AGBookListCell.class);
    }];
    
    // 并添加到归档中
    [vm ag_addArchivedObjectKey:ak_AGBook_title];
    [vm ag_addArchivedObjectKey:ak_AGBook_image];
    [vm ag_addArchivedObjectKey:ak_AGBook_summary];
    [vm ag_addArchivedObjectKey:ak_AGBook_isbn];
    [vm ag_addArchivedObjectKey:kAGVMViewClassName];
    
    return vm;
}

@end
