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
 
 1. AGTimerManager 对象管理一组 Timer，当 AGTimerManager 对象销毁时，自动停止所有 Timer。
 
 2. 调用ag_stopAllTimers()方法停止所有 Timer。
 
 3. LLDB 打印所有 Timer信息，po timerManager。
 
 */


typedef BOOL(^AGTMCountdownBlock)(NSTimeInterval surplus);
typedef void(^AGTMCompletionBlock)(void);
typedef BOOL(^AGTMRepeatBlock)(void);


@interface AGTimerManager : NSObject

#pragma mark - 定时器⏰
/**
 开始并马上重复调用 repeatBlock，直到返回 NO  (NSRunLoopCommonModes)
 
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
 开始并马上重复调用 repeatBlock，直到返回 NO  (自定义NSRunLoopMode)
 
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
 开始倒计时，间隔为1秒 (NSRunLoopCommonModes)
 
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

@end

NS_ASSUME_NONNULL_END

