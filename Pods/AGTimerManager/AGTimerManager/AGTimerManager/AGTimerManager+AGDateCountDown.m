//
//  AGTimerManager+AGDateCountDown.m
//  AGTimerManager
//
//  Created by JohnnyB0Y on 2018/12/25.
//  Copyright © 2018 JohnnyB0Y. All rights reserved.
//

#import "AGTimerManager+AGDateCountDown.h"

@implementation AGTimerManager (AGDateCountDown)

- (NSString *)ag_startCountdownDate:(NSDate *)date
                           interval:(NSTimeInterval)ti
                          countdown:(AGTMDateCountdownBlock)countdownBlock
                         completion:(AGTMCompletionBlock)completionBlock
{
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:[NSDate date]];
    if ( timeInterval <= 0 ) {
        completionBlock ? completionBlock() : nil;
        return nil;
    }
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSCalendarUnit unitFlags
    = NSCalendarUnitYear| NSCalendarUnitMonth| NSCalendarUnitDay| NSCalendarUnitHour| NSCalendarUnitMinute| NSCalendarUnitSecond;
    
    return [self ag_startCountdownTimer:timeInterval interval:ti countdown:^BOOL(NSTimeInterval surplus) {
        
        if ( countdownBlock ) {
            NSDateComponents *comp = [calendar components:unitFlags fromDate:[NSDate date] toDate:date options:0];
            countdownBlock(calendar, comp);
        }
        
        return YES;
        
    } completion:^{
        
        if ( completionBlock ) {
            completionBlock();
        }
        
    }];
    
}

- (NSString *)ag_startCountdownDate:(NSDate *)date
                          countdown:(AGTMDateCountdownBlock)countdownBlock
                         completion:(AGTMCompletionBlock)completionBlock
{
    return [self ag_startCountdownDate:date interval:1. countdown:countdownBlock completion:completionBlock];
}

- (NSString *)ag_startCountdownDateInterval:(NSTimeInterval)timeIntervalSinceNow
                                  countdown:(AGTMDateCountdownBlock)countdownBlock
                                 completion:(AGTMCompletionBlock)completionBlock
{
    if ( timeIntervalSinceNow <= 0 ) {
        completionBlock ? completionBlock() : nil;
        return nil;
    }
    NSDate *date = [NSDate dateWithTimeIntervalSinceNow:timeIntervalSinceNow];
    return [self ag_startCountdownDate:date interval:1. countdown:countdownBlock completion:completionBlock];
}

@end
