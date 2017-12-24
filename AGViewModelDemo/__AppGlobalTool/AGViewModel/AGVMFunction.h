//
//  AGVMFunction.h
//  
//
//  Created by JohnnyB0Y on 2017/12/24.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AGVMPackager, AGViewModel, AGVMSection, AGVMManager;

#ifndef AGVMFunction_h
#define AGVMFunction_h

NS_ASSUME_NONNULL_BEGIN

#pragma mark - Fast Funtion

/** fast create AGVMManager instance */
AGVMManager * ag_VMManager(NSUInteger capacity);
/** fast create AGVMSection instance */
AGVMSection * ag_VMSection(NSUInteger capacity);
/** fast create AGViewModel instance */
AGViewModel * ag_viewModel(NSDictionary * _Nullable bindingModel);
/** 全局 vm packager */
AGVMPackager * ag_sharedVMPackager(void);


/** fast create mutableDictionary */
NSMutableDictionary * ag_mutableDict(NSUInteger capacity);
/** fast create mutableArray */
NSMutableArray * ag_mutableArray(NSUInteger capacity);
/** fast create 可变数组函数, 包含 Null 对象 */
NSMutableArray * ag_mutableNullArray(NSUInteger capacity);


#pragma mark - Safe Convert
/**
 验证传入对象是否莫类型
 
 @param obj 传入对象
 @param objClass 对象类型
 @return 是：返回原对象；否：返回 nil；
 */
id ag_safeObj(id obj, Class objClass);

#pragma mark 字典、数组
/** 验证是否为 NSDictionary 对象； */
NSDictionary * ag_safeDictionary(id obj);

/** 验证是否为 NSMutableDictionary 对象；是：返回原对象；否：返回 nil */
NSMutableDictionary * ag_safeMutableDictionary(id obj);

/** 验证是否为 NSArray 对象；是：返回原对象；否：返回 nil */
NSArray * ag_safeArray(id obj);

/** 验证是否为 NSMutableArray 对象；是：返回原对象；否：返回 nil */
NSMutableArray * ag_safeMutableArray(id obj);

#pragma mark 字符串、数字
/** 验证是否为 NSString 对象；是：返回原对象；否：返回 nil */
NSString * ag_safeString(id obj);

/** 转换为 NSString 对象；能转为：返回 NSString 对象；不能：返回 nil */
NSString * ag_safeStringConvert(id obj);

/** 验证是否为 NSNumber 对象；是：返回原对象；否：返回 nil */
NSNumber * ag_safeNumber(id obj);

NS_ASSUME_NONNULL_END

#endif /* AGVMFunction_h */
