//
//  AGTimerManager+AGDateCountDown.h
//  AGTimerManager
//
//  Created by JohnnyB0Y on 2018/12/25.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGTimerManager.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL(^AGTMDateCountdownBlock)(NSCalendar *calendar, NSDateComponents *comp);

@interface AGTimerManager (AGDateCountDown)

/**
 开始日期倒计时 (NSRunLoopCommonModes)

 @param date 未来日期
 @param ti 计数间隔
 @param countdownBlock 日期倒计时回调 block 返回 NO 停止，返回 YES 继续。
 @param completionBlock 日期倒计时完成 block
 @return timer key
 */
- (NSString *) ag_startCountdownDate:(NSDate *)date
                            interval:(NSTimeInterval)ti
                           countdown:(AGTMDateCountdownBlock)countdownBlock
                          completion:(nullable AGTMCompletionBlock)completionBlock;

/**
 开始日期倒计时 (NSRunLoopCommonModes，计数间隔为1秒)
 
 @param date 未来日期
 @param countdownBlock 日期倒计时回调 block 返回 NO 停止，返回 YES 继续。
 @param completionBlock 日期倒计时完成 block
 @return timer key
 */
- (NSString *) ag_startCountdownDate:(NSDate *)date
                           countdown:(AGTMDateCountdownBlock)countdownBlock
                          completion:(nullable AGTMCompletionBlock)completionBlock;

/**
 开始日期倒计时 (NSRunLoopCommonModes，计数间隔为1秒)
 
 @param timeIntervalSinceNow 与[NSDate date]的间隔秒数
 @param countdownBlock 日期倒计时回调 block 返回 NO 停止，返回 YES 继续。
 @param completionBlock 日期倒计时完成 block
 @return timer key
 */
- (NSString *) ag_startCountdownDateInterval:(NSTimeInterval)timeIntervalSinceNow
                                   countdown:(AGTMDateCountdownBlock)countdownBlock
                                  completion:(nullable AGTMCompletionBlock)completionBlock;

@end

NS_ASSUME_NONNULL_END
