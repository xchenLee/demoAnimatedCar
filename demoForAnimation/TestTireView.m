//
//  TestTireView.m
//  demoForAnimation
//
//  Created by danlan on 2017/6/29.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import "TestTireView.h"

@interface TestTireView()

@property (nonatomic, strong) UIImageView *tireView;

@end

@implementation TestTireView



- (void)preload {
    
    self.tireView = [UIImageView new];
    self.tireView.frame = CGRectMake((self.widgetWidth - 100) / 2, (self.widgetHeight - 100) /2 , 100, 100);
    UIImage *tireImage = [self loadImage:@"car/car_tire"];
    
    self.tireView.image = tireImage;
    
    double a = M_PI / 4;
    CGFloat x = 0;
    CGFloat y = 0;
    CGAffineTransform transform = CGAffineTransformMake(cos(a),sin(a),-sin(a),cos(a),x-x*cos(a)+y*sin(a),y-x*sin(a)-y*cos(a));
    self.tireView.transform = transform;
    
    UIView *canvas = [UIView new];
    canvas.frame = CGRectMake((self.widgetWidth - 100) / 2, (self.widgetHeight - 100) /2 , 100, 100);
    canvas.backgroundColor = [UIColor redColor];
    
    [self addSubview:canvas];
    [self addSubview:self.tireView];

    
    
}

- (void)play {
    
    

    
}

@end











