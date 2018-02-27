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
@protocol AGVerifyManagerVerifiable, AGVerifyManagerInjectVerifiable;

NS_ASSUME_NONNULL_BEGIN

typedef void(^AGVerifyManagerVerifiedBlock)(AGVerifyError * _Nullable firstError,
                                            NSArray<AGVerifyError *> * _Nullable errors);

#pragma mark - AGVerifyManager
@interface AGVerifyManager : NSObject

/** 验证数据，数据由验证器携带 */
- (AGVerifyManager * (^)(id<AGVerifyManagerVerifiable> verifier)) verify;


/** 验证数据，数据直接参数传入 */
- (AGVerifyManager * (^)(id<AGVerifyManagerInjectVerifiable> verifier,
						 id obj)) verify_Obj;


/** 验证数据，直接传入验证器、数据、错误提示信息 */
- (AGVerifyManager * (^)(id<AGVerifyManagerInjectVerifiable> verifier,
						 id obj,
						 NSString * _Nullable msg)) verify_Obj_Msg;


/** 验证完调用 (无循环引用问题) */
- (AGVerifyManager *) verified:(NS_NOESCAPE AGVerifyManagerVerifiedBlock)verifiedBlock;

@end


#pragma mark - AGVerifyManagerVerifiable
@protocol AGVerifyManagerVerifiable <NSObject>

/** 验证数据，数据由验证器携带 */
- (nullable AGVerifyError *) verify;

@end


#pragma mark - AGVerifyManagerInjectVerifiable
@protocol AGVerifyManagerInjectVerifiable <NSObject>

/** 验证数据，数据直接参数传入 */
- (nullable AGVerifyError *) verifyObj:(id)obj;

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
AGVerifyManager * ag_verifyManager();

NS_ASSUME_NONNULL_END

