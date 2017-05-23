//
//  ViewController.m
//  FSScrollViewNestTableViewDemo
//
//  Created by huim on 2017/5/23.
//  Copyright © 2017年 fengshun. All rights reserved.
//

#import "ViewController.h"
#import "FSBaseViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"ClickMe" forState:UIControlStateNormal];
    btn.center = self.view.center;
    [btn sizeToFit];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)btnClick
{
    [self.navigationController pushViewController:[[FSBaseViewController alloc]init] animated:YES];
}

@end
