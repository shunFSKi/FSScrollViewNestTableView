//
//  FSSegmentTitleView.m
//  FSScrollContentViewDemo
//
//  Created by huim on 2017/5/3.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSSegmentTitleView.h"

@interface FSSegmentTitleView ()



@property (nonatomic, strong) UIScrollView *scrollView;

@property (nonatomic, strong) NSMutableArray<UIButton *> *itemBtnArr;

@property (nonatomic, strong) UIView *indicatorView;

@property (nonatomic, assign) FSIndicatorType indicatorType;

@property (nonatomic, strong) NSArray *titlesArr;

@end

@implementation FSSegmentTitleView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titlesArr delegate:(id<FSSegmentTitleViewDelegate>)delegate indicatorType:(FSIndicatorType)incatorType
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initWithProperty];
        self.titlesArr = titlesArr;
        self.delegate = delegate;
        self.indicatorType = incatorType;
    }
    return self;
}
//初始化默认属性值
- (void)initWithProperty
{
    self.itemMargin = 20;
    self.selectIndex = 0;
    self.titleNormalColor = [UIColor blackColor];
    self.titleSelectColor = [UIColor redColor];
    self.titleFont = [UIFont systemFontOfSize:15];
    self.indicatorColor = self.titleSelectColor;
    self.indicatorExtension = 5.f;
    self.titleSelectFont = self.titleFont;
}
//重新布局frame
- (void)layoutSubviews
{
    [super layoutSubviews];
    self.scrollView.frame = self.bounds;
    if (self.itemBtnArr.count == 0) {
        return;
    }
    CGFloat totalBtnWidth = 0.0;
    UIFont *titleFont = _titleFont;
    
    if (_titleFont != _titleSelectFont) {
        for (int idx = 0; idx < self.titlesArr.count; idx++) {
            UIButton *btn = self.itemBtnArr[idx];
            titleFont = btn.isSelected?_titleSelectFont:_titleFont;
            CGFloat itemBtnWidth = [FSSegmentTitleView getWidthWithString:self.titlesArr[idx] font:titleFont] + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }
    }
    else
    {
        for (NSString *title in self.titlesArr) {
            CGFloat itemBtnWidth = [FSSegmentTitleView getWidthWithString:title font:titleFont] + self.itemMargin;
            totalBtnWidth += itemBtnWidth;
        }
    }
    if (totalBtnWidth <= CGRectGetWidth(self.bounds)) {//不能滑动
        CGFloat itemBtnWidth = CGRectGetWidth(self.bounds)/self.itemBtnArr.count;
        CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
        [self.itemBtnArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.frame = CGRectMake(idx * itemBtnWidth, 0, itemBtnWidth, itemBtnHeight);
        }];
        self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.scrollView.bounds));
    }else{//超出屏幕 可以滑动
        CGFloat currentX = 0;
        for (int idx = 0; idx < self.titlesArr.count; idx++) {
            UIButton *btn = self.itemBtnArr[idx];
            titleFont = btn.isSelected?_titleSelectFont:_titleFont;
            CGFloat itemBtnWidth = [FSSegmentTitleView getWidthWithString:self.titlesArr[idx] font:titleFont] + self.itemMargin;
            CGFloat itemBtnHeight = CGRectGetHeight(self.bounds);
            btn.frame = CGRectMake(currentX, 0, itemBtnWidth, itemBtnHeight);
            currentX += itemBtnWidth;
        }
        self.scrollView.contentSize = CGSizeMake(currentX, CGRectGetHeight(self.scrollView.bounds));
    }
    [self moveIndicatorView:YES];
}

- (void)moveIndicatorView:(BOOL)animated
{
    UIFont *titleFont = _titleFont;
    UIButton *selectBtn = self.itemBtnArr[self.selectIndex];
    titleFont = selectBtn.isSelected?_titleSelectFont:_titleFont;
    CGFloat indicatorWidth = [FSSegmentTitleView getWidthWithString:self.titlesArr[self.selectIndex] font:titleFont];
    [UIView animateWithDuration:(animated?0.05:0) animations:^{
        switch (_indicatorType) {
            case FSIndicatorTypeDefault:
                self.indicatorView.frame = CGRectMake(selectBtn.frame.origin.x , CGRectGetHeight(self.scrollView.bounds) - 2, CGRectGetWidth(selectBtn.bounds), 2);
                break;
            case FSIndicatorTypeEqualTitle:
                self.indicatorView.center = CGPointMake(selectBtn.center.x, CGRectGetHeight(self.scrollView.bounds) - 1);
                self.indicatorView.bounds = CGRectMake(0, 0, indicatorWidth, 2);
                break;
            case FSIndicatorTypeCustom:
                self.indicatorView.center = CGPointMake(selectBtn.center.x, CGRectGetHeight(self.scrollView.bounds) - 1);
                self.indicatorView.bounds = CGRectMake(0, 0, indicatorWidth + _indicatorExtension*2, 2);
                break;
            case FSIndicatorTypeNone:
                self.indicatorView.frame = CGRectZero;
                break;
            default:
                break;
        }
    } completion:^(BOOL finished) {
        [self scrollSelectBtnCenter:animated];
    }];
}

- (void)scrollSelectBtnCenter:(BOOL)animated
{
    UIButton *selectBtn = self.itemBtnArr[self.selectIndex];
    CGRect centerRect = CGRectMake(selectBtn.center.x - CGRectGetWidth(self.scrollView.bounds)/2, 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    [self.scrollView scrollRectToVisible:centerRect animated:animated];
}

#pragma mark --LazyLoad

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

- (NSMutableArray<UIButton *>*)itemBtnArr
{
    if (!_itemBtnArr) {
        _itemBtnArr = [[NSMutableArray alloc]init];
    }
    return _itemBtnArr;
}

- (UIView *)indicatorView
{
    if (!_indicatorView) {
        _indicatorView = [[UIView alloc]init];
        [self.scrollView addSubview:_indicatorView];
    }
    return _indicatorView;
}

#pragma mark --Setter

- (void)setTitlesArr:(NSArray *)titlesArr
{
    _titlesArr = titlesArr;
    [self.itemBtnArr makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.itemBtnArr = nil;
    for (NSString *title in titlesArr) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = self.itemBtnArr.count + 666;
        [btn setTitle:title forState:UIControlStateNormal];
        [btn setTitleColor:_titleNormalColor forState:UIControlStateNormal];
        [btn setTitleColor:_titleSelectColor forState:UIControlStateSelected];
        btn.titleLabel.font = _titleFont;
        [self.scrollView addSubview:btn];
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        if (self.itemBtnArr.count == self.selectIndex) {
            btn.selected = YES;
        }
        [self.itemBtnArr addObject:btn];
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setItemMargin:(CGFloat)itemMargin
{
    _itemMargin = itemMargin;
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setSelectIndex:(NSInteger)selectIndex
{
    if (_selectIndex == selectIndex||_selectIndex < 0||_selectIndex > self.itemBtnArr.count - 1) {
        return;
    }
    UIButton *lastBtn = [self.scrollView viewWithTag:_selectIndex + 666];
    lastBtn.selected = NO;
    lastBtn.titleLabel.font = _titleFont;
    _selectIndex = selectIndex;
    UIButton *currentBtn = [self.scrollView viewWithTag:_selectIndex + 666];
    currentBtn.selected = YES;
    currentBtn.titleLabel.font = _titleSelectFont;
//    [self moveIndicatorView:YES];
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleFont:(UIFont *)titleFont
{
    _titleFont = titleFont;
    for (UIButton *btn in self.itemBtnArr) {
        btn.titleLabel.font = titleFont;
    }
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleSelectFont:(UIFont *)titleSelectFont
{
    if (_titleFont == titleSelectFont) {
        _titleSelectFont = _titleFont;
        return;
    }
    _titleSelectFont = titleSelectFont;
    for (UIButton *btn in self.itemBtnArr) {
        btn.titleLabel.font = btn.isSelected?titleSelectFont:_titleFont;
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setTitleNormalColor:(UIColor *)titleNormalColor
{
    _titleNormalColor = titleNormalColor;
    for (UIButton *btn in self.itemBtnArr) {
        [btn setTitleColor:titleNormalColor forState:UIControlStateNormal];
    }
}

- (void)setTitleSelectColor:(UIColor *)titleSelectColor
{
    _titleSelectColor = titleSelectColor;
    for (UIButton *btn in self.itemBtnArr) {
        [btn setTitleColor:titleSelectColor forState:UIControlStateSelected];
    }
}

- (void)setIndicatorColor:(UIColor *)indicatorColor
{
    _indicatorColor = indicatorColor;
    self.indicatorView.backgroundColor = indicatorColor;
}

- (void)setIndicatorExtension:(CGFloat)indicatorExtension
{
    _indicatorExtension = indicatorExtension;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark --Btn

- (void)btnClick:(UIButton *)btn
{
    NSInteger index = btn.tag - 666;
    if (index == self.selectIndex) {
        return;
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(FSSegmentTitleView:startIndex:endIndex:)]) {
        [self.delegate FSSegmentTitleView:self startIndex:self.selectIndex endIndex:index];
    }
    self.selectIndex = index;
}

#pragma mark Private
/**
 计算字符串长度

 @param string string
 @param font font
 @return 字符串长度
 */
+ (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}

/**
 随机色

 @return 调试用
 */
+ (UIColor*) randomColor{
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}


@end
