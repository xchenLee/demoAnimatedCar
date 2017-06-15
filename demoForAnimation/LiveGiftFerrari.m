//
//  LiveGiftFerrari.m
//  demoForAnimation
//
//  Created by dreamer on 2017/6/16.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import "LiveGiftFerrari.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


static const CGFloat kFerrariW = 750.0;
static const CGFloat kFerrarih = 329.0;

@interface LiveGiftFerrari()

@property(nonatomic, strong) UIImageView *mainFrame;
@property(nonatomic, strong) UIImageView *doorFrame;

@property(nonatomic, strong) UIImageView *fTireFrame;
@property(nonatomic, strong) UIImageView *bTireFrame;



@property(nonatomic, assign) CGFloat scale;

@end

@implementation LiveGiftFerrari



- (void)loadSources {
    
}

- (void)play {
    [self doEnterAnimation];
}

- (void)doEnterAnimation {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.duration = 0.8;
    
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @(kScreenWidth + kScreenWidth * 0.5);
    animation.toValue =  @(kScreenWidth * 0.5);
    [self.mainFrame.layer addAnimation:animation forKey:@"position"];
}

- (void)construct {
    
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kFerrarih / self.scaleRate);
    self.frame = frame;
    
    _mainFrame = [UIImageView new];
    frame.origin.x = kScreenWidth;
    _mainFrame.frame = frame;
    _mainFrame.image = [self loadImage:@"car/body"];
    [self addSubview:_mainFrame];
    
    CGRect tireFrame = CGRectMake(0, 0, [self valueCompat:80], [self valueCompat:80]);
    tireFrame.origin.x = [self valueCompat:243.0];
    tireFrame.origin.y = self.frame.size.height - tireFrame.size.height - [self valueCompat:76];
    
    _fTireFrame = [UIImageView new];
    _fTireFrame.image = [self loadImage:@"car/tire"];
    _fTireFrame.frame = tireFrame;
    [_mainFrame addSubview:_fTireFrame];
}

- (CGFloat)scaleRate {
    if (_scale == 0) {
        _scale = kFerrariW / kScreenWidth;
    }
    return _scale;
}

- (UIImage *)loadImage:(NSString *)suffix {
    NSString *imageFile = [NSString stringWithFormat:@"%@/%@.png", [[NSBundle mainBundle] resourcePath], suffix];
    UIImage *image = [UIImage imageWithContentsOfFile:imageFile];
    return image;
}

- (CGFloat)valueCompat:(CGFloat)value {
    return value / self.scaleRate;
}

@end





















