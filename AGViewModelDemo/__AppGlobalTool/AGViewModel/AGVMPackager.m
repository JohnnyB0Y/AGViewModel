//
//  AGVMPackager.m
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/9.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  View Model 包装者

#import "AGVMPackager.h"
#import "AGVMFunction.h"
#import "AGVMSection.h"
#import "AGVMManager.h"

/** 能否转换 */
BOOL ag_canJSONTransformStringWithObject(id obj);
/** 开始转换 */
NSString * ag_JSONTransformStringWithObject(id obj, AGVMJSONTransformBlock block, AGViewModel *vm, BOOL *isString);

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
                                     mergeVM:(AGViewModel *)mergeVM
                                     inBlock:(__attribute__((noescape)) AGVMPackageDatasBlock)block
                                    capacity:(NSInteger)capacity
{
    if ( items == nil ) return nil;
    NSAssert([items isKindOfClass:[NSArray class]], @"传入的 items 类型错误！");
    
    NSMutableArray *arrM = ag_newNSMutableArray(items.count);
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        AGViewModel *vm =
        [AGViewModel newWithModel:mergeVM.bindingModel
                         capacity:capacity];
        block ? block(vm.bindingModel, obj, idx) : nil;
        [arrM addObject:vm];
    }];
    
    return [arrM copy];
}

/**
 组装 ViewModel
 
 @param package 赋值数据的 Block
 @param mergeVM 添加的共同数据字典
 @param capacity 字典每次增量拷贝的内存大小
 @return ViewModel
 */
- (AGViewModel *) ag_package:(NS_NOESCAPE AGVMPackageDataBlock)package
                     mergeVM:(AGViewModel *)mergeVM
                    capacity:(NSInteger)capacity
{
    AGViewModel *vm =
    [AGViewModel newWithModel:mergeVM.bindingModel
                     capacity:capacity];
    package ? package(vm.bindingModel) : nil;
    return vm;
}

- (AGViewModel *) ag_package:(NS_NOESCAPE AGVMPackageDataBlock)package
                    capacity:(NSInteger)capacity
{
    return [self ag_package:package mergeVM:nil capacity:capacity];
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
    if ( [key rangeOfString:@"_"].length > 0 ) {
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
    NSString *assignStr = [NSString stringWithFormat:@"%@ *%@ = viewModel[%@];", returnClass, key, newKey];
    
    [assignStrM appendFormat:@"\n%@\n", assignStr];
}

- (void) _printDefinitionStrM:(NSMutableString *)definitionStrM
                  takeOutStrM:(NSMutableString *)takeOutStrM
                   assignStrM:(NSMutableString *)assignStrM
{
    [self _printString:@"🦋-" row:1];
    printf("%s\n", [definitionStrM UTF8String]);
    [self _printString:@"-🦋" row:1];
    printf("\n\n");
    
    [self _printString:@"-🍀" row:1];
    printf("%s\n", [takeOutStrM UTF8String]);
    [self _printString:@"🍀-" row:1];
    printf("\n\n");
    
    [self _printString:@"😈-" row:1];
    printf("%s\n", [assignStrM UTF8String]);
    [self _printString:@"-😈" row:1];
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


#pragma mark JSON Transform
/**
 数组转成字符串 - 可替换自定义key - 可自行处理特殊类型（NSString、NSNumber、NSURL、实现NSFastEnumeration或AGVMJSONTransformable协议对象、{其他类型自行处理}）
 
 @param array 待转换的数组
 @param exchangeKeyVM 需要替换key的VM，格式 {原Key:新Key}
 @param block 自行处理Block（通过写入 useDefault 来控制采用 返回处理结果 还是 默认处理结果）
 @return JSON字符串
 */
NSString * ag_newJSONStringWithArray(NSArray *array,
                                  AGViewModel *exchangeKeyVM,
                                  AGVMJSONTransformBlock block)
{
    if ([array isKindOfClass:[NSArray class]] ) {
        // 开 {
        NSMutableString *strM = [NSMutableString stringWithString:@"["];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            BOOL isString = NO;
            NSString *newStr = ag_JSONTransformStringWithObject(obj, block, exchangeKeyVM, &isString);
            if ( newStr && (strM.length <= 1) ) {
                isString ? [strM appendFormat:@"\"%@\"", newStr] : [strM appendString:newStr];
            }
            else {
                isString ? [strM appendFormat:@",\"%@\"", newStr] : [strM appendFormat:@",%@", newStr];
            }
        }];
        // 闭 }
        [strM appendString:@"]"];
        return [strM copy];
    }
    NSCAssert(array == nil, @"传入的array 不是 NSArray对象.");
    return nil;
}

/**
 字典转成字符串 - 可替换自定义key - 可自行处理特殊类型（NSString、NSNumber、NSURL、实现NSFastEnumeration或AGVMJSONTransformable协议对象、{其他类型自行处理}）
 @desction
 @param dict 待转换的字典
 @param exchangeKeyVM 需要替换key的VM，格式 {原Key:新Key}
 @param block 自行处理Block（通过写入 useDefault 来控制采用 返回处理结果 还是 默认处理结果）
 @return JSON字符串
 */
NSString * ag_newJSONStringWithDictionary(NSDictionary *dict,
                                 AGViewModel *exchangeKeyVM,
                                 AGVMJSONTransformBlock block)
{
    if ([dict isKindOfClass:[NSDictionary class]] ) {
        // 开 {
        NSMutableString *strM = [NSMutableString stringWithString:@"{"];
        [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            BOOL isString = NO;
            NSString *keyStr = ag_JSONTransformStringWithObject(key, block, exchangeKeyVM, nil);
            NSString *objStr = ag_JSONTransformStringWithObject(obj, block, exchangeKeyVM, &isString);
            if ( keyStr && objStr ) {
                // 是否需要替换 自定义key
                if ( [exchangeKeyVM isKindOfClass:[AGViewModel class]] ) {
                    NSString *newKey = exchangeKeyVM[keyStr];
                    if ( [newKey isKindOfClass:[NSString class]] ) {
                        keyStr = newKey;
                    }
                    else if ( newKey != nil ) {
                        NSCAssert(NO, @"exchangeKeyVM 取出的自定义key不是 NSString对象.");
                    }
                }
                else if ( exchangeKeyVM != nil ) {
                    NSCAssert(NO, @"传入的exchangeKeyVM 不是 AGViewModel对象.");
                }
                // 拼接字典字符串
                if ( strM.length <= 1 ) {
                    isString ? [strM appendFormat:@"\"%@\":\"%@\"", keyStr, objStr] : [strM appendFormat:@"\"%@\":%@", keyStr, objStr];
                }
                else {
                    isString ? [strM appendFormat:@",\"%@\":\"%@\"", keyStr, objStr] : [strM appendFormat:@",\"%@\":%@", keyStr, objStr];
                }
            }
        }];
        
        // 闭 }
        [strM appendString:@"}"];
        return [strM copy];
    }
    NSCAssert(NO, @"传入的dict 不是 NSDictionary对象.");
    return nil;
}

NSString * ag_JSONTransformStringWithObject(id obj,
                                            AGVMJSONTransformBlock block,
                                            AGViewModel *vm,
                                            BOOL *isString)
{
    // 特殊处理
    if ( block ) {
        BOOL useDefault = NO;
        id result = block(obj, &useDefault);
        if ( useDefault == NO ) {
            // 用户拦截了
            BOOL canTransform = ag_canJSONTransformStringWithObject(result);
            NSCAssert(canTransform, @"自行处理Block，请返回 NSString、NSNumber、NSURL、NSDictionary、NSArray、NSSet、NSMapTable、NSHashTable、AGViewModel、AGVMSection、AGVMManager对象 或者 nil.");
            if ( canTransform ) {
                return ag_JSONTransformStringWithObject(result, nil, vm, isString);
            }
        }
    }
    
    // 默认处理
    if ( obj == nil ) { return nil; }
    else if ( [obj isKindOfClass:[NSString class]] ) {
        if ( isString ) { *isString = YES; }
        return obj;
    }
    else if ( [obj isKindOfClass:[NSNumber class]] ) {
        return [obj stringValue];
    }
    else if ( [obj isKindOfClass:[NSURL class]] ) {
        if ( isString ) { *isString = YES; }
        return [obj absoluteString];
    }
    else if ( [obj isKindOfClass:[NSDictionary class]] ) {
        return ag_newJSONStringWithDictionary(obj, vm, block);
    }
    else if ( [obj isKindOfClass:[NSArray class]] ) {
        return ag_newJSONStringWithArray([obj allObjects], vm, block);
    }
    else if ( [obj respondsToSelector:@selector(ag_toJSONStringWithExchangeKey:customTransform:)] ) {
        return [obj ag_toJSONStringWithExchangeKey:vm customTransform:block];
    }
    else if ( [obj respondsToSelector:@selector(ag_toJSONStringWithCustomTransform:)] ) {
        return [obj ag_toJSONStringWithCustomTransform:block];
    }
    else if ( [obj respondsToSelector:@selector(ag_toJSONString)] ) {
        return [obj ag_toJSONString];
    }
    else if ( [obj isKindOfClass:[NSSet class]] ) {
        return ag_newJSONStringWithArray([obj allObjects], vm, block);
    }
    else if ( [obj isKindOfClass:[NSMapTable class]] ) {
        return ag_newJSONStringWithDictionary([obj dictionaryRepresentation], vm, block);
    }
    else if ( [obj isKindOfClass:[NSHashTable class]] ) {
        return ag_newJSONStringWithArray([obj allObjects], vm, block);
    }
    return nil;
}

BOOL ag_canJSONTransformStringWithObject(id obj)
{
    if ( obj == nil ) { return YES; }
    else if ( [obj isKindOfClass:[NSString class]] )     { return YES; }
    else if ( [obj isKindOfClass:[NSNumber class]] )     { return YES; }
    else if ( [obj isKindOfClass:[NSURL class]] )        { return YES; }
    else if ( [obj isKindOfClass:[NSDictionary class]] ) { return YES; }
    else if ( [obj isKindOfClass:[NSArray class]] )      { return YES; }
    else if ( [obj isKindOfClass:[NSSet class]] )        { return YES; }
    else if ( [obj isKindOfClass:[NSMapTable class]] )   { return YES; }
    else if ( [obj isKindOfClass:[NSHashTable class]] )  { return YES; }
    else if ( [obj respondsToSelector:@selector(ag_toJSONStringWithExchangeKey:customTransform:)] ) { return YES; }
    else if ( [obj respondsToSelector:@selector(ag_toJSONStringWithCustomTransform:)] ) { return YES; }
    else if ( [obj respondsToSelector:@selector(ag_toJSONString)] ) { return YES; }
    return NO;
}

NSArray * ag_newNSArrayWithJSONString(NSString *json, NSError **error)
{
    json = ag_newJSONStringByWashString(json);
    if ( ! [json hasPrefix:@"["] && ! [json hasSuffix:@"]"] ) {
        *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                     code:24
                                 userInfo:@{NSLocalizedDescriptionKey: @"Cannot be converted to an NSArray."}];
        return nil;
    }
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:error];
}

NSDictionary * ag_newNSDictionaryWithJSONString(NSString *json, NSError **error)
{
    json = ag_newJSONStringByWashString(json);
    if ( ! [json hasPrefix:@"{"] && ! [json hasSuffix:@"}"] ) {
        *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                     code:24
                                 userInfo:@{NSLocalizedDescriptionKey: @"Cannot be converted to an NSDictionary."}];
        return nil;
    }
    
    NSData *jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    return [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableLeaves error:error];
}

NSString * ag_newJSONStringByWashString(NSString *json)
{
    // 去掉首尾空白
    json = [json stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // 替换制表符
    json = [json stringByReplacingOccurrencesOfString:@"\t" withString:@"\\t"];
    json = [json stringByReplacingOccurrencesOfString:@"\n" withString:@"\\n"];
    json = [json stringByReplacingOccurrencesOfString:@"\r" withString:@"\\r"];
    json = [json stringByReplacingOccurrencesOfString:@"\\" withString:@"\\\\"];
    
    return json;
}

/** 全局 vm packager */
AGVMPackager * ag_sharedVMPackager(void)
{
    return [AGVMPackager sharedInstance];
}
