//
//  AGVerifyManager.h
//  Architecture
//
//  Created by JohnnyB0Y on 2017/6/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//  GitHub: https://github.com/JohnnyB0Y/AGVerifyManager
//  简书:    http://www.jianshu.com/p/c1e49fcd4a15

#import <Foundation/Foundation.h>
@class AGVerifyError, AGVerifyManager;
@protocol AGVerifyManagerVerifiable, AGVerifyManagerVerifying;

NS_ASSUME_NONNULL_BEGIN

typedef void(^AGVerifyManagerVerifyingBlock)(id<AGVerifyManagerVerifying> start);

typedef void(^AGVerifyManagerCompletionBlock)(AGVerifyError * _Nullable firstError,
                                              NSArray<AGVerifyError *> * _Nullable errors);

typedef id<AGVerifyManagerVerifying> _Nonnull (^AGVerifyManagerVerifyObjBlock)(id<AGVerifyManagerVerifiable> verifier,
                                                                               id obj);

typedef id<AGVerifyManagerVerifying> _Nonnull (^AGVerifyManagerVerifyObjMsgBlock)(id<AGVerifyManagerVerifiable> verifier,
                                                                                  id obj,
                                                                                  NSString * _Nullable msg);


#pragma mark - AGVerifyManager
@interface AGVerifyManager : NSObject

/**
 马上执行验证数据
 （1，单独使用执行验证。）
 （2，此处Block 不会被保存。）
 （3，数据验证完成后，不保留结果。）

 @param verifyBlock 执行验证器的 Block
 @param completionBlock 对验证结果进行处理的 Block
 */
- (void) ag_executeVerify:(NS_NOESCAPE AGVerifyManagerVerifyingBlock)verifyBlock
               completion:(NS_NOESCAPE AGVerifyManagerCompletionBlock)completionBlock;


/**
 准备验证数据 Block
 （1，与 ag_executeVerify 配合使用。）
 （2，此处Block 会被保存。）
 
 @param verifyBlock 执行验证器的 Block
 @param completionBlock 对验证结果进行处理的 Block
 */
- (void) ag_prepareVerify:(AGVerifyManagerVerifyingBlock)verifyBlock
               completion:(AGVerifyManagerCompletionBlock)completionBlock;

/**
 执行验证数据 Block
 （1，与 ag_executeVerify:completion: 配合使用。）
 （2，可多次执行验证。）
 （3，数据验证完成后，不保留结果。）
 */
- (void) ag_executeVerify;

@end


#pragma mark - AGVerifyManagerVerifying
@protocol AGVerifyManagerVerifying <NSObject>

/** 验证数据，直接传入验证器、数据 */
@property (nonatomic, copy, readonly) AGVerifyManagerVerifyObjBlock verifyObj;

/** 验证数据，直接传入验证器、数据、错误提示信息 */
@property (nonatomic, copy, readonly) AGVerifyManagerVerifyObjMsgBlock verifyObjMsg;

@end


#pragma mark - AGVerifyManagerVerifiable
@protocol AGVerifyManagerVerifiable <NSObject>

/** 验证数据，数据直接参数传入 */
- (nullable AGVerifyError *) ag_verifyObj:(id)obj;

@end


#pragma mark - AGVerifyError
@interface AGVerifyError : NSObject

/** 错误信息 */
@property (nonatomic, copy, nullable) NSString *msg;

/** 打包的错误信息 */
@property (nonatomic, copy, nullable) NSDictionary *userInfo;

/** 错误代码 */
@property (nonatomic, assign) NSInteger code;

/** 被验证的对象 （传递出去，可以做特殊业务） */
@property (nonatomic, strong, nullable) id verifyObj;

@end


// 快捷构建方法
AGVerifyManager * ag_verifyManager(void);

NS_ASSUME_NONNULL_END

