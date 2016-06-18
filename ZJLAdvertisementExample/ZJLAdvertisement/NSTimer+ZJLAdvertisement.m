//
//  NSTimer+ZJLAdvertisement.m
//  ZJLAdvertisementExample
//
//  Created by ZhongZhongzhong on 16/6/17.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "NSTimer+ZJLAdvertisement.h"

@implementation NSTimer (ZJLAdvertisement)
- (void)resume
{
    if ([self isValid]) {
        [self setFireDate:[NSDate date]];
    }
}

- (void)resumeAfterTimeInterval:(NSTimeInterval)interval
{
    if ([self isValid]) {
        [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
    }
}

- (void)pause
{
    if ([self isValid]) {
        [self setFireDate:[NSDate distantFuture]];
    }
}

- (void)stop
{
    if ([self isValid]) {
        [self invalidate];
    }
}
@end
