//
//  AGVMPackager.m
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/9.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  View Model 包装者

#import "AGVMPackager.h"


@implementation AGVMPackager

+ (instancetype) sharedInstance
{
    static id sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (NSArray<AGViewModel *> *) ag_packageItems:(NSArray *)items
                                    commonVM:(AGViewModel *)commonVM
                                     inBlock:(AGVMPackageDatasBlock)block
                                    capacity:(NSUInteger)capacity
{
    NSMutableArray *arrM = ag_mutableArray(items.count);
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AGViewModel *vm =
        [AGViewModel ag_viewModelWithModel:commonVM.bindingModel
                                  capacity:capacity];
        block ? block(vm.bindingModel, obj, idx) : nil;
        [arrM addObject:vm];
    }];
    
    return [arrM copy];
}

/**
 组装 ViewModel
 
 @param package 赋值数据的 Block
 @param commonVM 添加的共同数据字典
 @param capacity 字典每次增量拷贝的内存大小
 @return ViewModel
 */
- (AGViewModel *) ag_package:(NS_NOESCAPE AGVMPackageDataBlock)package
                    commonVM:(AGViewModel *)commonVM
                    capacity:(NSUInteger)capacity
{
    AGViewModel *vm =
    [AGViewModel ag_viewModelWithModel:commonVM.bindingModel
                              capacity:capacity];
    package ? package(vm.bindingModel) : nil;
    return vm;
}

- (AGViewModel *) ag_package:(NS_NOESCAPE AGVMPackageDataBlock)package
                    capacity:(NSUInteger)capacity
{
    return [self ag_package:package commonVM:nil capacity:capacity];
}

- (AGViewModel *) ag_package:(NS_NOESCAPE AGVMPackageDataBlock)package
{
    return [self ag_package:package capacity:6];
}

/**
 分解 JSON字典 为常量。（嵌套支持）

 @param object 待分解的字典或数组
 @param moduleName 模块的名称
 */
- (void) ag_resolveStaticKeyFromObject:(id)object
                            moduleName:(NSString *)moduleName
{
    [self _resolveStaticKeyFromObject:object moduleName:moduleName];
}

#pragma mark - ---------- Private Methods ----------
- (void) _resolveStaticKeyFromObject:(id)object
                          moduleName:(NSString *)moduleName
{
    if ( [object isKindOfClass:[NSDictionary class]] ) {
        // 字典
        NSMutableString *definitionStrM = [NSMutableString string];
        NSMutableString *takeOutStrM = [NSMutableString string];
        NSMutableString *assignStrM = [NSMutableString string];
        
        // 1.遍历字典，把字典中的所有key取出来，生成对应的属性代码
        [object enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ( [obj isKindOfClass:[NSDictionary class]] ||
                 [obj isKindOfClass:[NSArray class]] ) {
                // 先打印自身
                NSMutableString *definitionStrM = [NSMutableString string];
                NSMutableString *takeOutStrM = [NSMutableString string];
                NSMutableString *assignStrM = [NSMutableString string];
                [self _appendStrWithKey:key
                             moduleName:moduleName
                            returnClass:[self _returnClassName:obj]
                         definitionStrM:definitionStrM
                            takeOutStrM:takeOutStrM
                             assignStrM:assignStrM];
                
                [self _printDefinitionStrM:definitionStrM
                               takeOutStrM:takeOutStrM
                                assignStrM:assignStrM];
                
                
                // 继续遍历打印
                [self _resolveStaticKeyFromObject:obj moduleName:moduleName];
                
            }
            else {
                // 普通对象
                [self _appendStrWithKey:key
                             moduleName:moduleName
                            returnClass:[self _returnClassName:obj]
                         definitionStrM:definitionStrM
                            takeOutStrM:takeOutStrM
                             assignStrM:assignStrM];
            }
            
        }];
        [self _printDefinitionStrM:definitionStrM
                       takeOutStrM:takeOutStrM
                        assignStrM:assignStrM];
        
    }
    else if ([object isKindOfClass:[NSArray class]] ) {
        // 继续遍历打印
        id firstObj = [object firstObject];
        [self _resolveStaticKeyFromObject:firstObj moduleName:moduleName];
        
    }
}

- (void) _appendStrWithKey:(NSString *)key
                moduleName:(NSString *)moduleName
               returnClass:(NSString *)returnClass
            definitionStrM:(NSMutableString *)definitionStrM
               takeOutStrM:(NSMutableString *)takeOutStrM
                assignStrM:(NSMutableString *)assignStrM
{
    NSString *newKey;
    // 1.1 把 key 首字母变大写 并 去掉下划线
    if ( [key containsString:@"_"] ) {
        newKey = [[key capitalizedString] stringByReplacingOccurrencesOfString:@"_" withString:@""];
    }
    else {
        newKey = key;
    }
    
    // 1.2 完整 数据key
    newKey = [NSString stringWithFormat:@"ak_%@_%@", moduleName, newKey];
    // ...
    NSString *definitionStr = [NSString stringWithFormat:@"/** %@ <#description#> 👉%@👈 */\nstatic NSString * const %@ = @\"%@\";", key, returnClass, newKey, newKey];
    
    [definitionStrM appendFormat:@"\n%@\n",definitionStr];
    // ...
    NSString *takeOutStr = [NSString stringWithFormat:@"// %@\npackage[%@] = dict[@\"%@\"];", key, newKey, key];
    
    [takeOutStrM appendFormat:@"\n%@\n",takeOutStr];
    // ...
    NSString *assignStr = [NSString stringWithFormat:@"%@ *%@ = _viewModel[%@];", returnClass, key, newKey];
    
    [assignStrM appendFormat:@"\n%@\n", assignStr];
}

- (void) _printDefinitionStrM:(NSMutableString *)definitionStrM
                  takeOutStrM:(NSMutableString *)takeOutStrM
                   assignStrM:(NSMutableString *)assignStrM
{
    [self _printString:@"🦋" row:1];
    printf("%s\n", [definitionStrM UTF8String]);
    [self _printString:@"🦋" row:1];
    printf("\n\n");
    
    [self _printString:@"🍀" row:1];
    printf("%s\n", [takeOutStrM UTF8String]);
    [self _printString:@"🍀" row:1];
    printf("\n\n");
    
    [self _printString:@"😈" row:1];
    printf("%s\n", [assignStrM UTF8String]);
    [self _printString:@"😈" row:1];
    printf("\n\n");
}

- (void) _printString:(NSString *)str row:(NSInteger)row
{
    for (int i = 0; i < row; i++) {
        for (int j = 0; j < 24; j++) {
            printf("%s", [str UTF8String]);
        }
        printf("\n");
    }
}

- (NSString *) _returnClassName:(id)obj
{
    NSString *returnClassName;
    if ( [obj isKindOfClass:[NSString class]] ) {
        returnClassName = @"NSString";
    }
    else if ( [obj isKindOfClass:[NSNumber class]] ) {
        returnClassName = @"NSNumber";
    }
    else if ( [obj isKindOfClass:[NSArray class]] ) {
        returnClassName = @"NSArray";
    }
    else if ( [obj isKindOfClass:[NSDictionary class]] ) {
        returnClassName = @"NSDictionary";
    }
    return returnClassName;
}

@end



/** 全局 vm packager */
AGVMPackager * ag_sharedVMPackager()
{
    return [AGVMPackager sharedInstance];
}

