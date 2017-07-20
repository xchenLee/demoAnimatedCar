//
//  ViewController.m
//  demoForAnimation
//
//  Created by danlan on 2017/6/15.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import "ViewController.h"
#import "LiveGiftFerrari.h"
#import "TestTireView.h"
#import "LiveHelicopter.h"
#import "LiveCruise.h"

@interface ViewController ()

@property (nonatomic, strong) LiveGiftFerrari *ferrari;
@property (nonatomic, strong) LiveHelicopter *helicopter;
@property (nonatomic, strong) LiveCruise *curise;


@property (nonatomic, strong) TestTireView *tireView;


@property (nonatomic, strong) UIButton *stopBtn;
@property (nonatomic, strong) UIButton *startBtn;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.stopBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.stopBtn.frame = CGRectMake(20, 80, 100, 40);
    [self.stopBtn setTitle:@"Stop" forState:UIControlStateNormal];
    [self.stopBtn addTarget:self action:@selector(clickStop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.stopBtn];
    
    self.startBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.startBtn.frame = CGRectMake(180, 80, 100, 40);
    [self.startBtn setTitle:@"Start" forState:UIControlStateNormal];
    [self.startBtn addTarget:self action:@selector(clickStart) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startBtn];

    /*self.tireView = [[TestTireView alloc] initWithOriginWidth:375 originHeight:375];
    self.tireView.center = self.view.center;
    [self.view addSubview:self.tireView];
    [self.tireView play];*/
//    
    CGFloat preferedWidth = [UIScreen mainScreen].bounds.size.width - 100;
//    self.helicopter = [[LiveHelicopter alloc] initWithOriginWidth:466 originHeight:267 preferedWidth:preferedWidth];
//    self.helicopter.center = self.view.center;
//    [self.view addSubview:self.helicopter];
//    [self.helicopter play];
    
//    self.ferrari = [[LiveGiftFerrari alloc] initWithOriginWidth:750.0 originHeight:329.0];
//    [self.ferrari construct];
//    self.ferrari.center = self.view.center;
//    self.view.backgroundColor = [UIColor blackColor];
//    [self.view addSubview:self.ferrari];
//    [self.ferrari play];
    
    self.curise = [[LiveCruise alloc] initWithOriginWidth:750 originHeight:454];
    self.curise.center = self.view.center;
    [self.view addSubview:self.curise];
    [self.curise play];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changed:) name:UIDeviceOrientationDidChangeNotification object:nil];
}

- (void)clickStop {
//    [self.ferrari stop];
}

- (void)clickStart {
//    [self.ferrari play];
//    [self.helicopter reset];
//    [self.helicopter play];
}



- (void)changed:(NSNotification *)notification {
    self.ferrari.center = self.view.center;
    self.helicopter.center = self.view.center;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
