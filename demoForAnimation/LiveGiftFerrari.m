//
//  BDLiveGiftFerrari.m
//  Blued2015
//
//  Created by danlan on 2017/6/19.
//  Copyright © 2017年 ___CHRIS ZHAO___. All rights reserved.
//

#import "LiveGiftFerrari.h"
#include "YYImage.h"


static const CGFloat kFerrariW = 750.0;
static const CGFloat kFerrariH = 329.0;

static const CGFloat kFerrariDoorW = 171.0;
static const CGFloat kFerrariDoorH = 101.0;
static const CGFloat kFerrariRDoorW = 161.0;
static const CGFloat kFerrariRDoorH = 96.0;
static const CGFloat kFerrariFrontLW = 296.0;
static const CGFloat kFerrariFrontLH = 81.0;


@interface LiveGiftFerrari()

@property(nonatomic, strong) UIView      *carBox;
@property(nonatomic, strong) UIImageView *mainFrame;
@property(nonatomic, strong) UIImageView *mainFrameCover;

@property(nonatomic, strong) UIImageView *rDoorFrame;
@property(nonatomic, strong) UIImageView *lDoorFrame;

@property(nonatomic, strong) UIImageView *fTireFrame;
@property(nonatomic, strong) UIImageView *bTireFrame;

@property(nonatomic, strong) UIImageView *lFrontLightFrame;
@property(nonatomic, strong) UIImageView *rFrontLightFrame;

@property(nonatomic, strong) YYAnimatedImageView *lightView;
@property(nonatomic, strong) YYFrameImage *lightImage;

@property(nonatomic, strong) NSMutableArray *fileNames;
@property(nonatomic, strong) NSMutableArray *durations;

@end


@implementation LiveGiftFerrari

#pragma mark - 动画标识符
- (NSString *)uniqueIdentifier {
    return @"LiveNativeFerrari";
}

#pragma mark - 开始动画
- (void)play {
    [self startKeyframeAnimation];
}

- (void)stop {
    //TODO
    [self.layer removeAllAnimations];
}

#pragma mark - 构造车身控件
- (void)preload {
    
    CGRect frame = self.bounds;
    
    //car盒子
    self.carBox = [UIView new];
    frame.origin.x = [self enterPositonX];
    self.carBox.frame = frame;
    [self addSubview:self.carBox];
    
    //右侧车门
    CGRect rDoorRect = CGRectMake(0, 0, [self valueCompat:kFerrariRDoorW], [self valueCompat:kFerrariRDoorH]);
    rDoorRect.origin.x = [self valueCompat:224];
    rDoorRect.origin.y = [self valueCompat:126];
    _rDoorFrame = [UIImageView new];
    _rDoorFrame.image = [self loadImage:@"car/car_door_r"];
    _rDoorFrame.layer.anchorPoint = CGPointMake(0.0, 45.0 / kFerrariRDoorH);
    _rDoorFrame.frame = rDoorRect;
    [self.carBox addSubview:_rDoorFrame];
    
    //右侧车灯
    CGRect frontLightFrame = CGRectMake([self valueCompat:22], [self valueCompat:142], [self valueCompat:kFerrariFrontLW], [self valueCompat:kFerrariFrontLH]);
    self.rFrontLightFrame = [UIImageView new];
    self.rFrontLightFrame.frame = frontLightFrame;
    self.rFrontLightFrame.alpha = 0.0;
    self.rFrontLightFrame.image = [self loadImage:@"car/car_front_light"];
    [self.carBox addSubview:self.rFrontLightFrame];
    
    //车身光晕
    frame.origin.x = 0;
    _mainFrameCover = [UIImageView new];
    _mainFrameCover.frame = frame;
    _mainFrameCover.alpha = 0.0;
    _mainFrameCover.image = [self loadImage:@"car/car_body_light"];
    [self.carBox addSubview:_mainFrameCover];
    
    //车身
    _mainFrame = [UIImageView new];
    frame.origin.x = 0;
    _mainFrame.frame = frame;
    _mainFrame.image = [self loadImage:@"car/car_body"];
    [self.carBox addSubview:_mainFrame];
    
    
    CGRect tireFrame = CGRectMake(0, 0, [self valueCompat:70], [self valueCompat:70]);
    tireFrame.origin.x = [self valueCompat:246.0];
    tireFrame.origin.y = self.frame.size.height - tireFrame.size.height - [self valueCompat:78];
    
    CGRect btireFrame = CGRectMake(0, 0, [self valueCompat:76], [self valueCompat:76]);
    btireFrame.origin.x = [self valueCompat:583.0];
    btireFrame.origin.y = self.frame.size.height - tireFrame.size.height - [self valueCompat:92];
    
    //前轮
    UIImage *tireImage = [self loadImage:@"car/car_tire"];
    _fTireFrame = [UIImageView new];
    _fTireFrame.image = tireImage;
    _fTireFrame.frame = tireFrame;
    CATransform3D rotate = CATransform3DMakeRotation(-M_PI / 8, 0, 1, 0);
    rotate = CATransform3DTranslate(rotate, 0, 0, 8);
    self.fTireFrame.layer.transform = rotate;
    [self.carBox addSubview:_fTireFrame];
    
    //后轮
    _bTireFrame = [UIImageView new];
    _bTireFrame.image = tireImage;
    _bTireFrame.frame = btireFrame;
    CATransform3D bRotate = CATransform3DMakeRotation(-M_PI / 5, 0, 1, 0);
    bRotate = CATransform3DTranslate(bRotate, 0, 0, 15);
    self.bTireFrame.layer.transform = bRotate;
    [self.carBox addSubview:_bTireFrame];
    
    //左侧车门
    CGRect lDoorRect = CGRectMake(0, 0, [self valueCompat:kFerrariDoorW], [self valueCompat:kFerrariDoorH]);
    lDoorRect.origin.x = [self valueCompat:316];
    lDoorRect.origin.y = [self valueCompat:130];
    
    _lDoorFrame = [UIImageView new];
    _lDoorFrame.image = [self loadImage:@"car/car_door_l"];
    _lDoorFrame.layer.anchorPoint = CGPointMake(0.1, 45.0 / kFerrariDoorH);
    _lDoorFrame.frame = lDoorRect;
    [self.mainFrame addSubview:_lDoorFrame];
    
    
    //左侧车灯
    CGRect lfrontLightFrame = CGRectMake([self valueCompat:22], [self valueCompat:140], [self valueCompat:kFerrariFrontLW], [self valueCompat:kFerrariFrontLH]);
    self.lFrontLightFrame = [UIImageView new];
    self.lFrontLightFrame.frame = lfrontLightFrame;
    self.lFrontLightFrame.alpha = 0.0;
    self.lFrontLightFrame.image = [self loadImage:@"car/car_front_light"];
    [self.mainFrame addSubview:self.lFrontLightFrame];
    
    //车身闪电, 不走关键帧动画，独立的动画控件，在合适的时候插播
    if (self.durations == nil) {
        self.fileNames = [NSMutableArray array];
        self.durations = [NSMutableArray array];
        
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        
        for (NSInteger index = 12; index <= 48; index ++) {
            NSString *fileName = [NSString stringWithFormat:@"%@/car/car_light/lighten_000%ld.png",bundlePath, (long)index];
            [self.fileNames addObject:fileName];
            [self.durations addObject:@(0.05)];
        }
    }
    _lightImage = [[YYFrameImage alloc] initWithImagePaths:self.fileNames frameDurations:self.durations loopCount:1];
    _lightView = [[YYAnimatedImageView alloc] init];
    _lightView.autoPlayAnimatedImage = NO;
    _lightView.image = _lightImage;
    [_lightView stopAnimating];
    self.lightView.frame = frame;
    [self.mainFrame addSubview:self.lightView];
}

#pragma mark - 私有方法，开始关键帧动画
- (void)startKeyframeAnimation {
    
    CGRect frame = self.mainFrameCover.frame;
    CGRect endFrame = frame;
    endFrame.origin.x = [self quitPositionX];
    
    [UIView animateKeyframesWithDuration:3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear| UIViewKeyframeAnimationOptionAllowUserInteraction animations:^{
        
        //Frame 1 ,车进场
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.25 animations:^{
            self.carBox.frame = frame;
        }];
        
        //Frame 2
        [UIView addKeyframeWithRelativeStartTime:0.05 relativeDuration:0.15 animations:^{
            [self.fTireFrame.layer setTransform:CATransform3DRotate(self.fTireFrame.layer.transform, 3.14, 0, 0, -1)];
            [self.bTireFrame.layer setTransform:CATransform3DRotate(self.bTireFrame.layer.transform, 3.14, 0, 0, -1)];
        }];
        
        //Frame 3 ,车门打开，光晕开始显现
        [UIView addKeyframeWithRelativeStartTime:0.25 relativeDuration:0.15 animations:^{
            self.mainFrameCover.alpha = 0.8;
            self.lDoorFrame.transform = CGAffineTransformMakeRotation(-M_PI / 4.0);
            self.rDoorFrame.transform = CGAffineTransformMakeRotation(-M_PI / 4.0);
        }];
        
        //Frame 4 ,光晕跳动0
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.05 animations:^{
            self.mainFrameCover.alpha = 0.3;
            self.lFrontLightFrame.alpha = 0.5;
            self.rFrontLightFrame.alpha = 0.5;
        }];
        
        //Frame 4 ,光晕跳动1
        [UIView addKeyframeWithRelativeStartTime:0.45 relativeDuration:0.03 animations:^{
            self.mainFrameCover.alpha = 0.5;
            self.lFrontLightFrame.alpha = 1.0;
            self.rFrontLightFrame.alpha = 1.0;
        }];
        
        //Frame 4 ,光晕跳动2
        [UIView addKeyframeWithRelativeStartTime:0.45 relativeDuration:0.05 animations:^{
            self.mainFrameCover.alpha = 1.0;
        }];
        
        //Frame 4 ,光晕跳动3
        [UIView addKeyframeWithRelativeStartTime:0.48 relativeDuration:0.03 animations:^{
            self.lFrontLightFrame.alpha = 0;
            self.rFrontLightFrame.alpha = 0;
        }];
        
        //Frame 4 ,光晕跳动4
        [UIView addKeyframeWithRelativeStartTime:0.50 relativeDuration:0.05 animations:^{
            self.mainFrameCover.alpha = 0.7;
        }];
        
        //Frame 5 ,前车灯闪烁0
        [UIView addKeyframeWithRelativeStartTime:0.51 relativeDuration:0.05 animations:^{
            self.lFrontLightFrame.alpha = 1.0;
            self.rFrontLightFrame.alpha = 1.0;
        }];
        
        //Frame 5 ,前车灯闪烁1
        [UIView addKeyframeWithRelativeStartTime:0.56 relativeDuration:0.05 animations:^{
            self.lFrontLightFrame.alpha = 0.3;
            self.rFrontLightFrame.alpha = 0.3;
        }];
        
        //Frame 6 ,光晕消失，关门，前车灯灭
        [UIView addKeyframeWithRelativeStartTime:0.6 relativeDuration:0.15 animations:^{
            self.mainFrameCover.alpha = 0.0;
            self.lFrontLightFrame.alpha = 0.0;
            self.rFrontLightFrame.alpha = 0.0;
            self.lDoorFrame.transform = CGAffineTransformRotate(self.lDoorFrame.transform, M_PI / 4.0);
            self.rDoorFrame.transform = CGAffineTransformRotate(self.rDoorFrame.transform, M_PI / 4.0);
        }];
        
        //Frame 7 ,车身开走, 车轮转动
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.25 animations:^{
            [self.fTireFrame.layer setTransform:CATransform3DRotate(self.fTireFrame.layer.transform, 3.14, 0, 0, -1)];
            [self.bTireFrame.layer setTransform:CATransform3DRotate(self.bTireFrame.layer.transform, 3.14, 0, 0, -1)];
            self.carBox.frame = endFrame;
        }];
        
    } completion:^(BOOL finished) {
        [self reset];
    }];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (!self.lightView.superview) {
            return;
        }
        [self.lightView startAnimating];
    });
}

#pragma mark - 重置
- (void)reset {
    [self.lightView stopAnimating];
    CGRect carFrame = self.carBox.frame;
    carFrame.origin.x = [self enterPositonX];
    self.carBox.frame = carFrame;
    self.mainFrameCover.alpha = 0;
    self.lightView.currentAnimatedImageIndex = 0;
    //[self removeFromSuperview];
}

@end
