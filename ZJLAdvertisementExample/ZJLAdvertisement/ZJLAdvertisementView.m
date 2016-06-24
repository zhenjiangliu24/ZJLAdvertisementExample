//
//  ZJLAdvertisementView.m
//  ZJLAdvertisementExample
//
//  Created by ZhongZhongzhong on 16/6/17.
//  Copyright © 2016年 ZhongZhongzhong. All rights reserved.
//

#import "ZJLAdvertisementView.h"
#import "NSTimer+ZJLAdvertisement.h"

@interface ZJLAdvertisementView()<UIScrollViewDelegate>
@property (nonatomic, strong) UIImageView *frontImageView;
@property (nonatomic, strong) UIImageView *currentImageView;
@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, strong) UIImage *placeholder;
@property (nonatomic, strong) UIPageControl *pageControl;
@end

@implementation ZJLAdvertisementView
- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images placeholder:(UIImage *)placeholder
{
    self = [super initWithFrame:frame];
    if (self) {
        _imageWidth = frame.size.width;
        _imageHeight = frame.size.height;
        _images = images;
        _placeholder = placeholder?placeholder:[UIImage imageNamed:@"loading.png"];
        _interval = 2.0;
        [self loadAllSubviews];

        [self startTimer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame images:(NSArray *)images
{
    return [self initWithFrame:frame images:images placeholder:nil];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (void)loadAllSubviews
{
    _mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _imageWidth, _imageHeight)];
    _mainScrollView.delegate = self;
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.showsVerticalScrollIndicator = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.scrollsToTop = NO;
    if (_images.count<=1) {
        _mainScrollView.contentSize = CGSizeMake(_imageWidth, _imageHeight);
        _mainScrollView.contentOffset = CGPointMake(0, 0);
    }else{
        _mainScrollView.contentSize = CGSizeMake(3*_imageWidth, _imageHeight);
        _mainScrollView.contentOffset = CGPointMake(_imageWidth, 0);
    }
    
    [self addSubview:_mainScrollView];
    
    _frontImageView = [[UIImageView alloc] init];
    _frontImageView.frame = CGRectMake(0, 0, _imageWidth, _imageHeight);
    [_mainScrollView addSubview:_frontImageView];
    
    _currentImageView = [[UIImageView alloc] init];
    _currentImageView.frame = CGRectOffset(_frontImageView.frame, _imageWidth, 0);
    [_mainScrollView addSubview:_currentImageView];
    
    _backImageView = [[UIImageView alloc] init];
    _backImageView.frame = CGRectOffset(_currentImageView.frame, _imageWidth, 0);
    [_mainScrollView addSubview:_backImageView];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:_interval target:self selector:@selector(animateChange) userInfo:nil repeats:YES];
    [_timer pause];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _imageHeight-50, _imageWidth, 30)];
    _pageControl.numberOfPages = _images.count;
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
    [self addSubview:_pageControl];
}

- (void)startTimer
{
    if (_images.count>1) {
        [_timer resumeAfterTimeInterval:_interval];
        [self updateViews];
    }
}

- (void)animateChange
{
    [_mainScrollView setContentOffset:CGPointMake(2*_imageWidth, 0) animated:YES];
    
}

- (void)updateViews
{
    NSInteger index = _currentPage;
    [self setImageView:_currentImageView withData:_images[index]];
    if (_images.count>1) {
        index = _currentPage<1?_images.count-1:_currentPage-1;
        [self setImageView:_frontImageView withData:_images[index]];
        index = _currentPage>=_images.count-1?0:_currentPage+1;
        [self setImageView:_backImageView withData:_images[index]];
    }
    _mainScrollView.contentOffset = CGPointMake(_imageWidth, 0);
}

- (void)setImageView:(UIImageView *)imageView withData:(id)data
{
    if ([data isKindOfClass:[UIImage class]]) {
        imageView.image = (UIImage *)data;
    }else if ([data isKindOfClass:[NSString class]]){
        NSString *imageName = (NSString *)data;
        if ([imageName hasPrefix:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:_placeholder completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
            }];
        }else{
            imageView.image = [UIImage imageNamed:imageName];
        }
    }
}

- (void)updateCurrentPage
{
    if (_mainScrollView.contentOffset.x>=_imageWidth*1.5) {
        _currentPage++;
        if (_currentPage>=_images.count) {
            _currentPage = 0;
        }
    }else if (_mainScrollView.contentOffset.x<=_imageWidth*0.5){
        _currentPage--;
        if (_currentPage<0) {
            _currentPage = _images.count-1;
        }
    }
}

#pragma mark - scroll view delegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer pause];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateCurrentPage];
    if (_pageControl.currentPage!=_currentPage) {
        _pageControl.currentPage = _currentPage;
        [self updateViews];
    }
    [_timer resumeAfterTimeInterval:_interval];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateCurrentPage];
    if (_pageControl.currentPage!=_currentPage) {
        _pageControl.currentPage = _currentPage;
        [self updateViews];
    }
}


@end
