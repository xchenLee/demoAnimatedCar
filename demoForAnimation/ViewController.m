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

@property (nonatomic, strong) UIButton *stopBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.stopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.stopBtn.frame = CGRectMake(20, 80, 100, 40);
    [self.stopBtn setTitle:@"Stop" forState:UIControlStateNormal];
    [self.stopBtn addTarget:self action:@selector(clickStop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.stopBtn];
    
    self.ferrari = [[LiveGiftFerrari alloc] initWithOriginWidth:750.0 originHeight:329.0];
    [self.ferrari construct];
    self.ferrari.center = self.view.center;
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.ferrari];
    [self.ferrari play];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changed:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)clickStop {
    [self.ferrari stop];
}

- (void)changed:(NSNotification *)notification {
    self.ferrari.center = self.view.center;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
