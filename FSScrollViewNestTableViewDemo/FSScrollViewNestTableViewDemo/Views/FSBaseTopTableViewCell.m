//
//  FSBaseTopTableViewCell.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSBaseTopTableViewCell.h"
#import "FSLoopScrollView.h"

@interface FSBaseTopTableViewCell ()

@end
@implementation FSBaseTopTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        FSLoopScrollView *loopView = [FSLoopScrollView loopImageViewWithFrame:CGRectMake(0, 0, KSCREEN_WIDTH, 200) isHorizontal:YES];
        loopView.imgResourceArr = @[@"http://img05.tooopen.com/images/20150202/sy_80219211654.jpg",
                                    @"http://img06.tooopen.com/images/20161123/tooopen_sy_187628854311.jpg",
                                    @"http://img07.tooopen.com/images/20170306/tooopen_sy_200775896618.jpg",
                                    @"http://img06.tooopen.com/images/20170224/tooopen_sy_199503612842.jpg",
                                    @"http://img02.tooopen.com/images/20160316/tooopen_sy_156105468631.jpg"];
        loopView.tapClickBlock = ^(FSLoopScrollView *loopView){
            NSString *message = [NSString stringWithFormat:@"老%ld被点啦",(long)loopView.currentIndex+1];
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"大顺啊" message:message delegate:self cancelButtonTitle:@"love you" otherButtonTitles:nil, nil];
            [alert show];
        };
        [self addSubview:loopView];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
}

@end
