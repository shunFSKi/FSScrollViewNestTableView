//
//  FSLoopScrollView.h
//  SFLoopScrollview
//
//  Created by huim on 2017/3/6.
//  Copyright © 2017年 shunFSKi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FSLoopScrollView : UIView
/**
 提供给外部的动态属性
 */
@property (nonatomic, copy) NSArray *imgResourceArr;//图片资源数组（网络，本地，图片）
@property (nonatomic, assign) NSTimeInterval timeinterval;//滚动间隔时间，默认2s
@property (nonatomic, assign, readonly) NSInteger currentIndex;//当前的index
@property (nonatomic, copy) void (^tapClickBlock)(FSLoopScrollView *loopView);//触摸事件


/**
 仅文本轮播调用
 */
@property (nonatomic, strong) UIColor *textColor;//默认黑色
@property (nonatomic, strong) UIFont *textFont;//默认15
@property (nonatomic, copy) NSArray *titlesArr;//文本数组
@property (nonatomic, copy) NSArray *titleImgArr;//文本图片数组


/**
 纯图片轮播图

 @param frame 初始化frame
 @param isHorizontal 是否横向
 @return 图片轮播
 */
+ (instancetype)loopImageViewWithFrame:(CGRect)frame isHorizontal:(BOOL)isHorizontal;


/**
 带图片头文本轮播图

 @param frame 初始化frame
 @param isTitleView 是否为文本视图
 @param titleImgArr 头图片数组（可以置空）
 @return 文本轮播
 */
+ (instancetype)loopTitleViewWithFrame:(CGRect)frame isTitleView:(BOOL)isTitleView titleImgArr:(NSArray *)titleImgArr;
@end
