//
//  ZJLAdvertisementView.h
//  ZJLAdvertisementExample
//
//  Created by ZhongZhongzhong on 16/6/17.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZJLAdvertisementDelegate <NSObject>
- (void)clickImageWithIndex:(NSUInteger)index;
@end

@interface ZJLAdvertisementView : UIView
@property (nonatomic, copy) NSArray *images;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, weak) id<ZJLAdvertisementDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images placeholder:(UIImage *)placeholder;
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images;
@end
