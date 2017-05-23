//
//  NSTimer+FSLoop.h
//  SFLoopScrollview
//
//  Created by huim on 2017/3/6.
//  Copyright © 2017年 shunFSKi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (FSLoop)

- (void)pauseTimer;
- (void)resumeTimer;
- (void)resumeTimerAfterTimeInterval:(NSTimeInterval)interval;
@end
