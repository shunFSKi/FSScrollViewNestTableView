//
//  FSLoopScrollView.m
//  SFLoopScrollview
//
//  Created by huim on 2017/3/6.
//  Copyright © 2017年 shunFSKi. All rights reserved.
//

#import "FSLoopScrollView.h"
#import "NSTimer+FSLoop.h"
#import <UIImageView+WebCache.h>
#import <YYText.h>

@interface FSLoopScrollView ()<UIScrollViewDelegate>

@property (nonatomic, strong)UIPageControl *pageControl;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *lastImgView;
@property (nonatomic, strong) UIImageView *nextImgView;
@property (nonatomic, strong) UIImageView *currentImgView;
@property (nonatomic, strong) YYLabel *currentLabel;
@property (nonatomic, strong) YYLabel *nextLabel;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) BOOL isHorizontal;
@property (nonatomic, assign) BOOL isTitleView;
@end

@implementation FSLoopScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    _lastImgView.frame = CGRectMake(0, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
        
    _currentImgView.frame = _isHorizontal?CGRectOffset(_lastImgView.frame, CGRectGetWidth(_lastImgView.bounds), 0):CGRectOffset(_lastImgView.frame, 0, CGRectGetHeight(_lastImgView.bounds));
        
    _nextImgView.frame = _isHorizontal?CGRectOffset(_currentImgView.frame, CGRectGetWidth(_currentImgView.bounds), 0):CGRectOffset(_currentImgView.frame, 0, CGRectGetHeight(_currentImgView.bounds));
    
    _currentLabel.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    
    _nextLabel.frame = CGRectOffset(_currentLabel.frame, 0, CGRectGetHeight(_currentLabel.bounds));
}
    
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _timeinterval = 2.0f;
        _textColor = [UIColor blackColor];
        _textFont = [UIFont systemFontOfSize:15.0f];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
        [self.scrollView addGestureRecognizer:tap];
    }
    return self;
}

+ (instancetype)loopImageViewWithFrame:(CGRect)frame isHorizontal:(BOOL)isHorizontal
{
    FSLoopScrollView *loopView = [[self alloc] initWithFrame:frame];
    loopView.lastImgView = [[UIImageView alloc]init];
    [loopView.scrollView addSubview:loopView.lastImgView];
    
    loopView.nextImgView = [[UIImageView alloc]init];
    [loopView.scrollView addSubview:loopView.nextImgView];
    
    loopView.currentImgView = [[UIImageView alloc]init];
    [loopView.scrollView addSubview:loopView.currentImgView];
    
    loopView.isHorizontal = isHorizontal;
    
    return loopView;
}

+ (instancetype)loopTitleViewWithFrame:(CGRect)frame isTitleView:(BOOL)isTitleView titleImgArr:(NSArray *)titleImgArr
{
    FSLoopScrollView *loopView = [[self alloc] initWithFrame:frame];
    loopView.currentLabel = [[YYLabel alloc]init];
    [loopView.scrollView addSubview:loopView.currentLabel];
    
    loopView.nextLabel = [[YYLabel alloc]init];
    [loopView.scrollView addSubview:loopView.nextLabel];
    
    loopView.isTitleView = isTitleView;
    loopView.titleImgArr = titleImgArr;
    return loopView;
}

#pragma mark Action
- (void)onTimer:(NSTimer *)timer
{
    CGPoint pointMake = _isHorizontal?CGPointMake(CGRectGetWidth(self.bounds)*2, 0):CGPointMake(0, CGRectGetHeight(self.bounds)*2);
    if (_isTitleView) {
        pointMake = CGPointMake(0, CGRectGetHeight(self.bounds));
    }
    [self.scrollView setContentOffset:pointMake animated:YES];
}
//scrollview的触摸手势
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    if (self.tapClickBlock) {
        self.tapClickBlock(self);
    }
}

//根据index动态更新图片，通过偏移量控制currentImg一直显示在当前位置
- (void)refreshCurrentImageView
{
    NSInteger index = _currentIndex;
    
    [self dynamicLoadImageView:_currentImgView imageData:self.imgResourceArr[index]];
    
    index = _currentIndex-1<0?self.imgResourceArr.count-1:_currentIndex-1;
    [self dynamicLoadImageView:_lastImgView imageData:self.imgResourceArr[index]];
    
    index = _currentIndex+1>=self.imgResourceArr.count?0:_currentIndex+1;
    [self dynamicLoadImageView:_nextImgView imageData:self.imgResourceArr[index]];
    
    CGPoint pointMake = _isHorizontal?CGPointMake(CGRectGetWidth(self.bounds), 0):CGPointMake(0, CGRectGetHeight(self.bounds));
    [self.scrollView setContentOffset:pointMake];
}

//更新index
- (void)refreshCurrentIndex
{
    if (_isHorizontal) {
        if (self.scrollView.contentOffset.x >= CGRectGetWidth(self.bounds)*1.5) {
            _currentIndex ++;
            if (_currentIndex > self.imgResourceArr.count-1) {
                _currentIndex = 0;
            }
        }else if (self.scrollView.contentOffset.x < CGRectGetWidth(self.bounds)*0.5){
            _currentIndex --;
            if (_currentIndex < 0) {
                _currentIndex = self.imgResourceArr.count-1;
            }
        }
    }else{
        if (self.scrollView.contentOffset.y >= CGRectGetHeight(self.bounds)*1.5) {
            _currentIndex ++;
            if (_currentIndex > self.imgResourceArr.count-1) {
                _currentIndex = 0;
            }
        }else if (self.scrollView.contentOffset.y < CGRectGetHeight(self.bounds)*0.5){
            _currentIndex --;
            if (_currentIndex < 0) {
                _currentIndex = self.imgResourceArr.count-1;
            }
        }
    }
    
}
//加载图片，网络或本地图片
- (void)dynamicLoadImageView:(UIImageView *)imageView imageData:(id)data
{
    if ([data isKindOfClass:[UIImage class]]) {
        imageView.image = (UIImage *)data;
    }
    else if ([data isKindOfClass:[NSString class]]){
        NSString *imageName = (NSString *)data;
        if ([imageName hasPrefix:@"http"]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:imageName] placeholderImage:nil];
        }else{
            imageView.image = [UIImage imageNamed:imageName];
        }
    }
}

- (void)refreshCurrentTitleView
{
    NSInteger index = _currentIndex;
    self.currentLabel.attributedText = [self getAttachmentTextWithStr:self.titlesArr[index] image:self.titleImgArr[index]];
    
    index = _currentIndex+1>=self.titlesArr.count?0:_currentIndex+1;
    self.nextLabel.attributedText = [self getAttachmentTextWithStr:self.titlesArr[index] image:self.titleImgArr[index]];
    
    self.scrollView.contentOffset = CGPointMake(0, 0);
}

- (void)refreshTitleIndex
{
    if (self.scrollView.contentOffset.y >= CGRectGetHeight(self.bounds)*0.5) {
        _currentIndex ++;
        if (_currentIndex > self.titlesArr.count-1) {
            _currentIndex = 0;
        }
    }
}

#pragma mark ----Lazy load

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds)-20, CGRectGetWidth(self.bounds), 10)];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
        _pageControl.hidesForSinglePage = YES;
        [self addSubview:_pageControl];
    }
    return _pageControl;
}

#pragma mark setter

-(void)setImgResourceArr:(NSArray *)imgResourceArr
{
    _imgResourceArr = imgResourceArr;
    _currentIndex = 0;
    self.pageControl.numberOfPages = self.imgResourceArr.count;
    self.pageControl.currentPage = 0;
    
    if (![_timer isValid]) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeinterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        [_timer pauseTimer];
    }
    
    if (imgResourceArr.count<=1) {
        self.scrollView.contentSize = _isHorizontal?CGSizeMake(CGRectGetWidth(self.bounds), 0):CGSizeMake(0, CGRectGetHeight(self.bounds));
    }else{
        self.scrollView.contentSize = _isHorizontal?CGSizeMake(CGRectGetWidth(self.bounds)*3, 0):CGSizeMake(0, CGRectGetHeight(self.bounds)*3);
        [self.timer resumeTimerAfterTimeInterval:_timeinterval];
    }
    
    [self refreshCurrentImageView];
}

- (void)setTitlesArr:(NSArray *)titlesArr
{
    _titlesArr = titlesArr;
    _currentIndex = 0;
    self.scrollView.scrollEnabled = NO;
    
    if (![_timer isValid]) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:_timeinterval target:self selector:@selector(onTimer:) userInfo:nil repeats:YES];
        [_timer pauseTimer];
    }
    if (titlesArr.count<=1) {
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.bounds));
    }else{
        self.scrollView.contentSize = CGSizeMake(0, CGRectGetHeight(self.bounds)*2);
        [self.timer resumeTimerAfterTimeInterval:_timeinterval];
    }
    
    [self refreshCurrentTitleView];
}

- (void)setTitleImgArr:(NSArray *)titleImgArr
{
    _titleImgArr = titleImgArr;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
}

#pragma mark UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //触摸滑动时暂停定时器
    [self.timer pauseTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _isTitleView?[self refreshTitleIndex]:[self refreshCurrentIndex];
    
    if (self.pageControl.currentPage != _currentIndex) {
        self.pageControl.currentPage = _currentIndex;
        [self refreshCurrentImageView];
    }
    //触摸滚动结束重启定时器
    [self.timer resumeTimerAfterTimeInterval:_timeinterval];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    _isTitleView?[self refreshTitleIndex]:[self refreshCurrentIndex];
    
    if (_isTitleView) {
        [self refreshCurrentTitleView];
    }else{
        if (self.pageControl.currentPage != _currentIndex) {
            self.pageControl.currentPage = _currentIndex;
            [self refreshCurrentImageView];
        }
    }
}

#pragma mark private

/**
 带图片头的文字循环

 @param labelText label赋值
 @param data 本地图片资源（可置空）
 @return 拼接好的富文本
 */
- (NSMutableAttributedString *)getAttachmentTextWithStr:(NSString *)labelText image:(id)data
{
    UIImage *image;
    if ([data isKindOfClass:[UIImage class]]) {
        image = (UIImage *)data;
    }else if ([data isKindOfClass:[NSString class]]){
        NSString *imageName = (NSString *)data;
        image = [UIImage imageNamed:imageName];
    }
    
    NSMutableAttributedString *text = [NSMutableAttributedString new];
    NSMutableAttributedString *attachText = [NSMutableAttributedString yy_attachmentStringWithContent:image contentMode:UIViewContentModeCenter attachmentSize:image.size alignToFont:self.textFont alignment:YYTextVerticalAlignmentCenter];
    [text appendAttributedString:attachText];
    [text appendAttributedString:[[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@" %@",labelText] attributes:nil]];
    text.yy_font = self.textFont;
    text.yy_color = self.textColor;
    return text;
}


@end
