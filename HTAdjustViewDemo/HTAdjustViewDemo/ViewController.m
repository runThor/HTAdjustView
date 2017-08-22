//
//  ViewController.m
//  HTAdjustViewDemo
//
//  Created by chenghong on 2017/8/18.
//  Copyright © 2017年 HT. All rights reserved.
//

#import "ViewController.h"
#import "HTAdjustView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor grayColor];

    HTAdjustView *adjustView = [[HTAdjustView alloc] initWithFrame:CGRectMake(0, 0, 50, 200)];
    [adjustView setCenter:CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2)];
    [adjustView setName:@"水泵" value:80 unit:@"L" maxValue:150 minValue:30];
    [self.view addSubview:adjustView];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
