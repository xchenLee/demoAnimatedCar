//
//  ViewController.m
//  demoForAnimation
//
//  Created by danlan on 2017/6/15.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import "ViewController.h"
#import "LiveGiftFerrari.h"

@interface ViewController ()

@property (nonatomic, strong) LiveGiftFerrari *ferrari;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.ferrari = [[LiveGiftFerrari alloc] init];
    [self.ferrari construct];
    self.ferrari.center = self.view.center;
    [self.view addSubview:self.ferrari];
    [self.ferrari play];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
