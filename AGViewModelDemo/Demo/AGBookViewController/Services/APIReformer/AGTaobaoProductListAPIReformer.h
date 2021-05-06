//
//  AGTaobaoProductListAPIReformer.h
//  
//
//  Created by JohnnyB0Y on 2018/5/25.
//  Copyright © 2018年 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AGBookListCellVMP.h"
#import "AGAPINetworking.h"

@interface AGTaobaoProductListAPIReformer : NSObject  <AGAPIReformer>

/** vmp */
@property (nonatomic, strong, readonly) AGBookListCellVMP *bookListCellVMP;

@end
