//
//  AGTimerManager.h
//
//
//  Created by JohnnyB0Y on 2017/5/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AGTimerManager;
NS_ASSUME_NONNULL_BEGIN

/**
 // 使用须知
 1. ag_timerManager(id token)，一个 token 对应一组 Timer；
 调用 ag_stopAllTimers，会移除该 token 对应的所有 Timer；
 
 2. token 必须是 oc 对象，当对象销毁时，定时器会自动停止并移除。一般传 self 就可以了。
 如果传常量或全局变量作为 token 就要手动管理好定时器了。
 
 3. 如果用 LLDB 打印信息，token 传 nil 就好了。传 nil 后调用 ag_stopAllTimers 是移除内部全部 timer。
 
 */


typedef BOOL(^AGTMCountdownBlock)(NSUInteger surplus);
typedef void(^AGTMCompletionBlock)(void);
typedef BOOL(^AGTMRepeatBlock)(void);

/**
 获取 timerManager 实例。
 
 @param token 一个令牌对应一组 Timer；调用 ag_stopAllTimers，会移除该 token 对应的所有 Timer；token 必须是 oc 对象。
 @return timerManager
 */
AGTimerManager * ag_timerManager(id _Nullable token);
#define ag_TM(token) ag_timerManager(token)



@interface AGTimerManager : NSObject

#pragma mark - 定时器⏰
/**
 开始重复调用 repeatBlock，直到返回 NO  (NSRunLoopCommonModes)
 
 @param ti 调用间隔
 @param repeatBlock 执行的block 返回 NO 停止，返回 YES 继续。
 @return timer key
 */
- (NSString *) ag_startRepeatTimer:(NSTimeInterval)ti
                       		repeat:(AGTMRepeatBlock)repeatBlock;

/**
 开始重复调用 repeatBlock，直到返回 NO  (NSRunLoopCommonModes)
 
 @param ti 调用间隔
 @param delay 执行前的延迟时间
 @param repeatBlock 执行的block 返回 NO 停止，返回 YES 继续。
 @return timer key
 */
- (NSString *) ag_startRepeatTimer:(NSTimeInterval)ti
							 delay:(NSTimeInterval)delay
                           	repeat:(AGTMRepeatBlock)repeatBlock;

/**
 开始重复调用 repeatBlock，直到返回 NO  (自定义NSRunLoopMode)
 
 @param ti 调用间隔
 @param mode 运行循环模式
 @param repeatBlock 执行的block 返回 NO 停止，返回 YES 继续。
 @return timer key
 */
- (NSString *) ag_startRepeatTimer:(NSTimeInterval)ti
						   forMode:(NSRunLoopMode)mode
                     		repeat:(AGTMRepeatBlock)repeatBlock;

/**
 开始重复调用 repeatBlock，直到返回 NO  (自定义NSRunLoopMode)
 
 @param ti 调用间隔
 @param delay 执行前的延迟时间
 @param mode 运行循环模式
 @param repeatBlock 执行的block 返回 NO 停止，返回 YES 继续。
 @return timer key
 */
- (NSString *) ag_startRepeatTimer:(NSTimeInterval)ti
							 delay:(NSTimeInterval)delay
						   forMode:(NSRunLoopMode)mode
                       		repeat:(AGTMRepeatBlock)repeatBlock;

#pragma mark - 倒计时⏳
/**
 开始倒计时 (NSRunLoopCommonModes)
 
 @param duration 计数值
 @param countdownBlock 计数回调 block 返回 NO 停止，返回 YES 继续。
 @param completionBlock 计数完成 block
 @return timer key
 */
- (NSString *) ag_startCountdownTimer:(NSTimeInterval)duration
                   			countdown:(nullable AGTMCountdownBlock)countdownBlock
						   completion:(nullable AGTMCompletionBlock)completionBlock;


/**
 开始倒计时 (NSRunLoopCommonModes)
 
 @param duration 计数值
 @param ti 计数间隔
 @param countdownBlock 计数回调 block 返回 NO 停止，返回 YES 继续。
 @param completionBlock 计数完成 block
 @return timer key
 */
- (NSString *) ag_startCountdownTimer:(NSTimeInterval)duration
							 interval:(NSTimeInterval)ti
                            countdown:(nullable AGTMCountdownBlock)countdownBlock
                           completion:(nullable AGTMCompletionBlock)completionBlock;

/**
 开始倒计时 (自定义NSRunLoopMode)
 
 @param duration 计数值
 @param ti 计数间隔
 @param mode 运行循环模式
 @param countdownBlock 计数回调 block 返回 NO 停止，返回 YES 继续。
 @param completionBlock 计数完成 block
 @return timer key
 */
- (NSString *) ag_startCountdownTimer:(NSTimeInterval)duration
                			 interval:(NSTimeInterval)ti
							  forMode:(NSRunLoopMode)mode
                   			countdown:(nullable AGTMCountdownBlock)countdownBlock
						   completion:(nullable AGTMCompletionBlock)completionBlock;


#pragma mark - 停止定时器⚠️
/**
 停止对应 token、key 的 timer；
 
 @param key 停止定时器的 key
 @return 是否停止成功
 */
- (BOOL) ag_stopTimerForKey:(NSString *)key;

/**
 停止对应 token 的所有 timer；如果 token 为 nil 就清空所有的定时器。
 
 @return 是否停止成功
 */
- (BOOL) ag_stopAllTimers;



/** 禁止调用 */
- (instancetype) init __attribute__((unavailable("call ag_timerManager(id token)")));
+ (instancetype) new __attribute__((unavailable("call ag_timerManager(id token)")));

@end

NS_ASSUME_NONNULL_END

