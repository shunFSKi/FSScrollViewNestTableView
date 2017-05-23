//
//  FSScrollContentViewController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "FSScrollContentViewController.h"

@interface FSScrollContentViewController ()

@end

@implementation FSScrollContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [FSScrollContentViewController randomColor];
}


+ (UIColor*) randomColor{
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1];
}

@end
