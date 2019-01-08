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

/** Quickly create AGVMManager instance */
AGVMManager * ag_newAGVMManager(NSInteger capacity);
/** Quickly create AGVMSection instance */
AGVMSection * ag_newAGVMSection(NSInteger capacity);
/** Quickly create AGViewModel instance */
AGViewModel * ag_newAGViewModel(NSDictionary * _Nullable bindingModel);
/** 全局 vm packager */
AGVMPackager * ag_sharedVMPackager(void);


/** Quickly create mutableDictionary */
NSMutableDictionary * ag_newNSMutableDictionary(NSInteger capacity);
/** Quickly create mutableArray */
NSMutableArray * ag_newNSMutableArray(NSInteger capacity);
/** Quickly create mutableArray, include NSNull obj */
NSMutableArray * ag_newNSMutableArrayWithNull(NSInteger capacity);


/** Quickly create block */
AGVMTargetVCBlock ag_viewModelCopyTargetVCBlock(AGVMTargetVCBlock block);


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

/** 验证是否为 NSNumber 对象；是：返回原对象；否：返回 nil */
NSNumber * ag_safeNumber(id obj);

/** 验证是否能转换为 NSString 对象；能转：返回 NSString 对象；不能：返回 nil */
NSString * ag_newNSStringWithObj(id obj);

#pragma mark - JSON Transform
/**
 数组转成字符串 - 可替换自定义key - 可自行处理特殊类型（NSString、NSNumber、NSURL、实现NSFastEnumeration或AGVMJSONTransformable协议对象、{其他类型自行处理}）
 
 @param array 待转换的数组
 @param exchangeKeyVM 需要替换key的VM，格式 {原Key:新Key}
 @param block 自行处理Block（通过写入 useDefault 来控制采用 返回处理结果 还是 默认处理结果）
 @return JSON字符串
 */
NSString * _Nullable ag_newJSONStringWithArray(NSArray *array,
                                               AGViewModel * _Nullable exchangeKeyVM,
                                               AGVMJSONTransformBlock _Nullable NS_NOESCAPE block);

/**
 字典转成字符串 - 可替换自定义key - 可自行处理特殊类型（NSString、NSNumber、NSURL、实现NSFastEnumeration或AGVMJSONTransformable协议对象、{其他类型自行处理}）
 
 @param dict 待转换的字典
 @param exchangeKeyVM 需要替换key的VM，格式 {原Key:新Key}
 @param block 自行处理Block（通过写入 useDefault 来控制采用 返回处理结果 还是 默认处理结果）
 @return JSON字符串
 */
NSString * _Nullable ag_newJSONStringWithDictionary(NSDictionary *dict,
                                                    AGViewModel * _Nullable exchangeKeyVM,
                                                    AGVMJSONTransformBlock _Nullable NS_NOESCAPE block);

/** 字符串转成数组对象 */
NSArray * _Nullable ag_newNSArrayWithJSONString(NSString *json, NSError **error);

/** 字符串转成字典对象 */
NSDictionary * _Nullable ag_newNSDictionaryWithJSONString(NSString *json, NSError **error);

/** 清洗字符串，去除首尾空白字符串，并替换制表符字符串。 */
NSString * _Nullable ag_newJSONStringByWashString(NSString *json);

NS_ASSUME_NONNULL_END

#endif /* AGVMFunction_h */
