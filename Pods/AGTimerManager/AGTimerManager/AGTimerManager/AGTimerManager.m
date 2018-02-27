//
//  AGTimerManager.m
//
//
//  Created by JohnnyB0Y on 2017/5/3.
//  Copyright © 2017年 JohnnyB0Y. All rights reserved.
//

#import "AGTimerManager.h"
#import <objc/runtime.h>

typedef BOOL(^AGTMTimerRepeatBlock)(NSTimer *timer, NSMutableDictionary *timerInfo);

//
static NSString * const kAGTMCountdownDuration  = @"kAGTMCountdownDuration";
static NSString * const kAGTMRepeatBlock      	= @"kAGTMRepeatBlock";
static NSString * const kAGTMCompletionBlock  	= @"kAGTMCompletionBlock";
static NSString * const kAGTMTimer            	= @"kAGTMTimer";

//
static NSString * const kAGTMTimerRepeatBlock 	= @"kAGTMTimerRepeatBlock";
static NSString * const kAGTMToken   			= @"kAGTMToken";

#pragma mark - timer
@interface __AGTimerManager : NSObject

@property (nonatomic, strong) NSMapTable<id, NSMutableDictionary *> *tokenMapTable;

#pragma mark - 倒计时⏳
- (NSString *) ag_startCountdownTimer:(id)token
							 duration:(NSTimeInterval)duration
							 interval:(NSTimeInterval)ti
							  forMode:(NSRunLoopMode)mode
							countdown:(AGTMCountdownBlock)countdownBlock
						   completion:(AGTMCompletionBlock)completionBlock;

#pragma mark - 定时器⏰
- (NSString *) ag_startRepeatTimer:(id)token
						  interval:(NSTimeInterval)ti
							 delay:(NSTimeInterval)delay
						   forMode:(NSRunLoopMode)mode
							repeat:(AGTMRepeatBlock)repeatBlock;

#pragma mark - 停止定时器⚠️
- (BOOL) ag_stopTimer:(id)token forKey:(NSString *)key;

- (BOOL) ag_stopAllTimers:(id)token;

@end


@implementation __AGTimerManager

#pragma mark - ----------- Life Cycle ----------
+ (instancetype)sharedInstance
{
	static __AGTimerManager *instance = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		instance = [[self alloc] init];
	});
	return instance;
}

#pragma mark - ---------- Public Methods ----------
- (NSString *) ag_startCountdownTimer:(id)token
							 duration:(NSTimeInterval)duration
							 interval:(NSTimeInterval)ti
							  forMode:(NSRunLoopMode)mode
							countdown:(AGTMCountdownBlock)countdownBlock
						   completion:(AGTMCompletionBlock)completionBlock
{
	if ( ! countdownBlock && ! completionBlock ) return nil;
	if ( duration <= 0. || ti <= 0. ) return nil;
	
	// 准备 timer
	NSTimer *timer =
	[self _timerWithToken:token interval:ti delay:0. repeatBlock:^BOOL(NSTimer *timer, NSMutableDictionary *timerInfo) {
		// 倒计时
		double surplus = [timerInfo[kAGTMCountdownDuration] doubleValue];
		surplus -= ti;
		timerInfo[kAGTMCountdownDuration] = [NSNumber numberWithDouble:surplus];
		
		// 用户计数 block
		AGTMCountdownBlock countdownBlock = timerInfo[kAGTMRepeatBlock];
		BOOL repeat = countdownBlock ? countdownBlock(surplus) : YES;
		if ( surplus <= 0 || ! repeat ) {
			// 计时为零 或 停止计时，调用完成代码块
			AGTMCompletionBlock completionBlock = timerInfo[kAGTMCompletionBlock];
			completionBlock ? completionBlock() : nil;
			
			return NO;
		}
		
		// 继续倒计时
		return YES;
	}];
	
	// 记录 timer info
	NSMutableDictionary *timerInfo = [self _timerInfoWithTimer:timer
											 countdownDuration:duration+ti
												   repeatBlock:countdownBlock
											   completionBlock:completionBlock];
	
	NSString *timerKey = [self _keyWithTimer:timer];
	[[self _timerInfoWithToken:token] setObject:timerInfo forKey:timerKey];
	
	// 开始 timer
	[self _startTimer:timer forMode:mode];
	
	return timerKey;
}

- (NSString *) ag_startRepeatTimer:(id)token
						  interval:(NSTimeInterval)ti
							 delay:(NSTimeInterval)delay
						   forMode:(NSRunLoopMode)mode
							repeat:(AGTMRepeatBlock)repeatBlock
{
	if ( ! repeatBlock || ti <= 0 ) return nil;
	
	// 准备 timer
	NSTimer *timer =
	[self _timerWithToken:token interval:ti delay:delay repeatBlock:^BOOL(NSTimer *timer, NSMutableDictionary *timerInfo) {
		// 定时任务 block
		AGTMRepeatBlock repeatBlock = timerInfo[kAGTMRepeatBlock];
		return repeatBlock ? repeatBlock() : YES;
	}];
	
	// 记录 timer info
	NSMutableDictionary *timerInfo = [self _timerInfoWithTimer:timer
											 countdownDuration:0.
												   repeatBlock:repeatBlock
											   completionBlock:nil];
	
	NSString *timerKey = [self _keyWithTimer:timer];
	[[self _timerInfoWithToken:token] setObject:timerInfo forKey:timerKey];
	
	// 开始 timer
	[self _startTimer:timer forMode:mode];
	
	return timerKey;
}

- (BOOL) ag_stopTimer:(id)token forKey:(NSString *)key
{
	if ( key && token ) {
		[[self _timerInfoWithToken:token] removeObjectForKey:key];
		return YES;
	}
	return NO;
}

- (BOOL) ag_stopAllTimers:(id)token
{
	if ( token ) {
		[self.tokenMapTable removeObjectForKey:token];
	}
	else {
		[self.tokenMapTable removeAllObjects];
	}
	return YES;
}

#pragma mark - ---------- Private Methods ----------
- (NSMutableDictionary *) _timerInfoWithTimer:(NSTimer *)timer
							countdownDuration:(NSTimeInterval)duration
								  repeatBlock:(id)repeatBlock
							  completionBlock:(id)completionBlock
{
	NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:4];
	dictM[kAGTMTimer] = timer;
	dictM[kAGTMRepeatBlock] = repeatBlock;
	dictM[kAGTMCountdownDuration] = duration > 0. ? [NSNumber numberWithDouble:duration] : nil;
	dictM[kAGTMCompletionBlock] = completionBlock;
	return dictM;
}

#pragma mark 开始 timer
- (void) _startTimer:(NSTimer *)timer forMode:(NSRunLoopMode)mode
{
	[[NSRunLoop mainRunLoop] addTimer:timer forMode:mode];
}

#pragma mark 获取 timer
- (NSTimer *) _timerWithToken:(id)token
					 interval:(NSTimeInterval)ti
						delay:(NSTimeInterval)delay
				  repeatBlock:(AGTMTimerRepeatBlock)block
{
	NSDate *fireDate = [NSDate dateWithTimeIntervalSinceNow:delay];
	NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
	userInfo[kAGTMTimerRepeatBlock] = [block copy];
	NSMapTable *tokenMapTable = [NSMapTable weakToWeakObjectsMapTable];
	[tokenMapTable setObject:token forKey:kAGTMToken];
	userInfo[kAGTMToken] = tokenMapTable;
	
	return [[NSTimer alloc] initWithFireDate:fireDate
									interval:ti
									  target:self
									selector:@selector(_repeatSelector:)
									userInfo:userInfo
									 repeats:YES];
}

#pragma mark 执行block
- (void) _repeatSelector:(NSTimer *)timer
{
	NSDictionary *userInfo = timer.userInfo;
	id token = [userInfo[kAGTMToken] objectForKey:kAGTMToken];
	NSString *key = [self _keyWithTimer:timer];
	NSMutableDictionary *timerInfo = [self _timerInfoWithToken:token][key];
	
	if ( timerInfo ) {
		AGTMTimerRepeatBlock repeatBlock = userInfo[kAGTMTimerRepeatBlock];
		BOOL repeat = repeatBlock ? repeatBlock(timer, timerInfo) : YES;
		if ( ! repeat ) {
			// remove timer
			[[self _timerInfoWithToken:token] removeObjectForKey:key];
		}
//		NSLog(@"%@ - %@", token, timer);
	}
	else {
		// stop timer
		[timer invalidate];
//		NSLog(@"stop timer");
	}
}

/** 从 timer 获取 timerInfo 的 key */
- (NSString *) _keyWithTimer:(NSTimer *)timer
{
	return [NSString stringWithFormat:@"tk_%p", timer];
}

/** 通过 token 获取 timerInfo */
- (NSMutableDictionary<NSString *,NSMutableDictionary *> *) _timerInfoWithToken:(id)token
{
	NSMutableDictionary *timerInfo = [self.tokenMapTable objectForKey:token];
	if ( ! timerInfo ) {
		timerInfo = [NSMutableDictionary dictionaryWithCapacity:6];
		[self.tokenMapTable setObject:timerInfo forKey:token];
	}
	return timerInfo;
}

#pragma mark - ----------- Getter Methods ----------
- (NSMapTable *)tokenMapTable
{
	if (_tokenMapTable == nil) {
		_tokenMapTable = [NSMapTable weakToStrongObjectsMapTable];
	}
	return _tokenMapTable;
}

@end

#pragma mark - timer manager
@interface AGTimerManager ()

@property (nonatomic, strong) id currentToken;

@end


@implementation AGTimerManager

#pragma mark - ----------- Life Cycle ----------
+ (instancetype) newWithToken:(id)token
{
	AGTimerManager *tm = [[self alloc] init];
	tm.currentToken = token;
	return tm;
}

#pragma mark - ---------- Public Methods ----------
#pragma mark - 倒计时⏳
- (NSString *) ag_startCountdownTimer:(NSTimeInterval)duration
							 interval:(NSTimeInterval)ti
							  forMode:(NSRunLoopMode)mode
							countdown:(AGTMCountdownBlock)countdownBlock
						   completion:(AGTMCompletionBlock)completionBlock
{
	return [[__AGTimerManager sharedInstance] ag_startCountdownTimer:self.currentToken
															duration:duration
															interval:ti
															 forMode:mode
														   countdown:countdownBlock
														  completion:completionBlock];
}

- (NSString *) ag_startCountdownTimer:(NSTimeInterval)duration
							countdown:(AGTMCountdownBlock)countdownBlock
						   completion:(AGTMCompletionBlock)completionBlock
{
	return [self ag_startCountdownTimer:duration
							   interval:1.
								forMode:NSRunLoopCommonModes
							  countdown:countdownBlock
							 completion:completionBlock];
}

- (NSString *) ag_startCountdownTimer:(NSTimeInterval)duration
							 interval:(NSTimeInterval)ti
							countdown:(AGTMCountdownBlock)countdownBlock
						   completion:(AGTMCompletionBlock)completionBlock
{
	return [self ag_startCountdownTimer:duration
							   interval:ti
								forMode:NSRunLoopCommonModes
							  countdown:countdownBlock
							 completion:completionBlock];
}

#pragma mark - 定时器⏰
- (NSString *) ag_startRepeatTimer:(NSTimeInterval)ti
							repeat:(AGTMRepeatBlock)repeatBlock
{
	return [self ag_startRepeatTimer:ti delay:0. forMode:NSRunLoopCommonModes repeat:repeatBlock];
}

- (NSString *) ag_startRepeatTimer:(NSTimeInterval)ti
							 delay:(NSTimeInterval)delay
							repeat:(AGTMRepeatBlock)repeatBlock
{
	return [self ag_startRepeatTimer:ti delay:delay forMode:NSRunLoopCommonModes repeat:repeatBlock];
}

- (NSString *) ag_startRepeatTimer:(NSTimeInterval)ti
						   forMode:(NSRunLoopMode)mode
							repeat:(AGTMRepeatBlock)repeatBlock
{
	return [self ag_startRepeatTimer:ti delay:0. forMode:NSRunLoopCommonModes repeat:repeatBlock];
}

- (NSString *) ag_startRepeatTimer:(NSTimeInterval)ti
							 delay:(NSTimeInterval)delay
						   forMode:(NSRunLoopMode)mode
							repeat:(AGTMRepeatBlock)repeatBlock
{
	return [[__AGTimerManager sharedInstance] ag_startRepeatTimer:self.currentToken
														 interval:ti
															delay:delay
														  forMode:mode
														   repeat:repeatBlock];
}

/**
 通过 key 停止定时器
 
 @param key 停止定时器的 key
 */
- (BOOL) ag_stopTimerForKey:(NSString *)key
{
	return [[__AGTimerManager sharedInstance] ag_stopTimer:self.currentToken forKey:key];
}

/** 停止所有 timer */
- (BOOL) ag_stopAllTimers
{
	return [[__AGTimerManager sharedInstance] ag_stopAllTimers:self.currentToken];
}

#pragma mark - ----------- Override Methods ----------
- (NSString *) debugDescription
{
	__AGTimerManager *tm = [__AGTimerManager sharedInstance];
    return [NSString stringWithFormat:@"<%@: %p> -- %@", [tm class] , tm, tm.tokenMapTable];
}

- (NSString *)description
{
	__AGTimerManager *tm = [__AGTimerManager sharedInstance];
	return [NSString stringWithFormat:@"<%@: %p> -- %@", [tm class] , tm, tm.tokenMapTable];
}

@end

/** 获取 timer manager */
AGTimerManager * ag_timerManager(id token)
{
	return [AGTimerManager newWithToken:token];
}

