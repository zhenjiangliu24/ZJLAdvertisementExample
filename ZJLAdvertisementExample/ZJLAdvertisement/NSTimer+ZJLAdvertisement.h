//
//  NSTimer+ZJLAdvertisement.h
//  ZJLAdvertisementExample
//
//  Created by ZhongZhongzhong on 16/6/17.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSTimer (ZJLAdvertisement)
- (void)resume;
- (void)resumeAfterTimeInterval:(NSTimeInterval)interval;
- (void)pause;
- (void)stop;
@end
