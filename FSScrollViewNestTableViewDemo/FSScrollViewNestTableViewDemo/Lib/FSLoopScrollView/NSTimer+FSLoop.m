//
//  NSTimer+FSLoop.m
//  SFLoopScrollview
//
//  Created by huim on 2017/3/6.
//  Copyright © 2017年 shunFSKi. All rights reserved.
//

#import "NSTimer+FSLoop.h"

@implementation NSTimer (FSLoop)

-(void)pauseTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}


-(void)resumeTimer
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}

- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval
{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

- (void)stopTimer
{
    if ([self isValid]) {
        [self invalidate];
    }
}

@end
