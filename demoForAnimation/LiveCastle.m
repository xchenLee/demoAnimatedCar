//
//  LiveCastle.m
//  demoForAnimation
//
//  Created by danlan on 2017/7/24.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import "LiveCastle.h"
#include "YYImage.h"
#import "AnimatedImageView.h"

const CGFloat kCastleW = 658;
const CGFloat kCastleH = 548;
const CGFloat kCastleBoxH = 624;


const CGFloat kFlagW = 108;
const CGFloat kFlagH = 76;

const CGFloat kFireworksW = 298 * 0.9;
const CGFloat kFireworksH = 312 * 0.9;

//southeast
static const CGFloat kCastleClound01W = 232.0 * 0.7;
static const CGFloat kCastleClound01H = 119.0 * 0.7;

//west
static const CGFloat kCastleClound02W = 412.0 * 0.5;
static const CGFloat kCastleClound02H = 241.0 * 0.5;

//northeast
static const CGFloat kCastleClound03W = 188.0 * 0.5;
static const CGFloat kCastleClound03H = 111.0 * 0.5;


const CGFloat kFireFrameDuration = 0.05f;
//间隔稍微少5帧
const CGFloat kFireFrameIntervalCount = 15;

const CGFloat kFireOneAnimeDurat = kFireFrameDuration * kFireFrameIntervalCount;

/**
 
 注意云朵图片和直升机公用同一个云朵图
 
 */

@interface LiveCastle()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *castle;

@property (nonatomic, assign) CGRect castleOrigFrame;
@property (nonatomic, assign) CGRect castleFinaFrame;

@property (nonatomic, strong) YYAnimatedImageView *flagView;
@property (nonatomic, strong) YYFrameImage *flagImage;
@property (nonatomic, strong) NSMutableArray *flagFrame;
@property (nonatomic, strong) NSMutableArray *flagDurat;

@property (nonatomic, strong) YYFrameImage *fireworksImage;
@property (nonatomic, strong) NSMutableArray *fireworkFrame;
@property (nonatomic, strong) NSMutableArray *fireworkDurat;

//按说是只要三个就可以了
@property (nonatomic, strong) AnimatedImageView *fireworks1;
@property (nonatomic, strong) AnimatedImageView *fireworks2;
@property (nonatomic, strong) AnimatedImageView *fireworks3;
@property (nonatomic, strong) AnimatedImageView *fireworks4;
@property (nonatomic, strong) AnimatedImageView *fireworks5;


@property (nonatomic, assign) CGRect fireFrame1Orin;
@property (nonatomic, assign) CGRect fireFrame1Reuse;

@property (nonatomic, assign) CGRect fireFrame2Orin;
@property (nonatomic, assign) CGRect fireFrame2Reuse;

@property (nonatomic, strong) UIImageView *cloundWest;
@property (nonatomic, assign) CGRect cloundWestOrigiF;
@property (nonatomic, assign) CGRect cloundWestFinalF;

@property (nonatomic, strong) UIImageView *cloundNortheast;
@property (nonatomic, assign) CGRect cloundNorthOrigiF;
@property (nonatomic, assign) CGRect cloundNorthFinalF;

@property (nonatomic, strong) UIImageView *cloundSoutheast;
@property (nonatomic, assign) CGRect cloundSouthOrigiF;
@property (nonatomic, assign) CGRect cloundSouthFinalF;

@property (nonatomic, assign) BOOL fire1Repeated;
@property (nonatomic, assign) BOOL fire2Repeated;



@end

@implementation LiveCastle


- (void)preload {
    
    CGRect frame = self.bounds;
    
    self.boxView = [UIView new];
    self.boxView.frame = frame;
    [self addSubview:self.boxView];
    
    //firework1
    self.fireworks1 = [self generateAFireworks];
    CGRect fireFrame = self.fireworks1.frame;
    
    //firework3
    CGFloat fTop3 = -[self valueCompat:20];
    CGFloat fLeft3 = (self.widgetWidth - fireFrame.size.width) / 2 + [self valueCompat:10];
    self.fireworks3 = [self generateAFireworks];
    
    fireFrame.origin.x = fLeft3;
    fireFrame.origin.y = fTop3;
    self.fireworks3.frame = fireFrame;
    [self.boxView addSubview:self.fireworks3];
    
    [self.boxView addSubview:self.castle];
    [self.castle addSubview:self.flagView];
    
    //修改castleZ 位置
    // 2D scale
    //CGAffineTransform transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8, 0.8);
    //self.castle.transform = transform;
    // 3D translate
    //CATransform3D transform = CATransform3DTranslate(CATransform3DIdentity, 0, 0, -20);
    // 3D scale
    CATransform3D transform = CATransform3DMakeScale(0.92, 0.92, 0);
    self.castle.layer.transform = transform;
    
    [self.boxView addSubview:self.cloundWest];
    [self.boxView addSubview:self.cloundSoutheast];
    [self.boxView addSubview:self.cloundNortheast];

    CGFloat fTop1 = [self valueCompat:40];
    CGFloat fLeft1 = self.widgetWidth - fireFrame.size.width - [self valueCompat:70];
    
    fireFrame.origin.x = fLeft1;
    fireFrame.origin.y = fTop1;
    self.fireworks1.frame = fireFrame;
    self.fireFrame1Orin = fireFrame;
    fireFrame.origin.x += [self valueCompat:15];
    fireFrame.origin.y -= [self valueCompat:8];
    
    self.fireFrame1Reuse = fireFrame;
    
    self.fireworks4 = [self generateAFireworks];
    self.fireworks4.frame = self.fireFrame1Reuse;
    
    [self.boxView addSubview:self.fireworks1];
    [self.boxView addSubview:self.fireworks4];

    
    //firework2
    self.fireworks2 = [self generateAFireworks];

    CGFloat fTop2 = [self valueCompat:80];
    CGFloat fLeft2 = [self valueCompat:90];
    
    fireFrame.origin.x = fLeft2;
    fireFrame.origin.y = fTop2;
    self.fireworks2.frame = fireFrame;
    fireFrame.origin.x += [self valueCompat:10];
    fireFrame.origin.y += [self valueCompat:6];
    
    self.fireworks5 = [self generateAFireworks];
    self.fireworks5.frame = fireFrame;
    self.fireFrame2Reuse = fireFrame;

    
    [self widgetAlpha:0];
    [self.boxView addSubview:self.fireworks2];
    [self.boxView addSubview:self.fireworks5];

    [self hideTheFireworks];
}


/*- (void)play {
    
    self.fire1Repeated = NO;
    self.fire2Repeated = NO;
    __weak typeof(self) wSelf = self;
    
    self.fireworks1.progressBlock = ^(NSInteger index, BOOL finish) {
        
        if (finish) {
            NSLog(@"fire1 finished");
            wSelf.fireworks1.hidden = YES;
            [wSelf.fireworks1 stopAnimating];
            wSelf.fireworks1.currentAnimatedImageIndex = 0;
            if (!wSelf.fire1Repeated) {
                wSelf.fireworks1.frame = wSelf.fireFrame1Reuse;
                wSelf.fire1Repeated = YES;
            }
        }
        //烟花1,重复过了
        if (wSelf.fire1Repeated) {
            wSelf.fireworks1.frame = wSelf.fireFrame1Orin;
        } else {
            //没重复过
            if (index == kFireFrameIntervalCount) {
                NSLog(@"fire2 stated");
                dispatch_async(dispatch_get_main_queue(), ^{
                    wSelf.fireworks2.hidden = NO;
                    [wSelf.fireworks2 startAnimating];
                });
            }
        }
    };
    
    self.fireworks2.progressBlock = ^(NSInteger index, BOOL finish) {
        
        if (finish) {
            NSLog(@"fire2 finished");

            wSelf.fireworks2.hidden = YES;
            [wSelf.fireworks2 stopAnimating];
            wSelf.fireworks2.currentAnimatedImageIndex = 0;
            if (!wSelf.fire2Repeated) {
                wSelf.fireworks2.frame = wSelf.fireFrame2Reuse;
                wSelf.fire2Repeated = YES;
            }
        }
        //烟花2,重复过了
        if (wSelf.fire2Repeated) {
            wSelf.fireworks2.frame = wSelf.fireFrame2Orin;
        } else {
            //没重复过
            if (index == kFireFrameIntervalCount) {
                NSLog(@"fire3 stated");

                wSelf.fireworks3.hidden = NO;
                [wSelf.fireworks3 startAnimating];
            }
        }
    };

    self.fireworks3.progressBlock = ^(NSInteger index, BOOL finish) {
        
        if (finish) {
            wSelf.fireworks3.hidden = YES;
            [wSelf.fireworks3 stopAnimating];
            wSelf.fireworks3.currentAnimatedImageIndex = 0;

        }
        if (index == kFireFrameIntervalCount) {
            wSelf.fireworks1.hidden = NO;
            [wSelf.fireworks1 startAnimating];
        }
    };
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFireOneAnimeDurat * 0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wSelf.flagView startAnimating];
        wSelf.fireworks1.hidden = NO;
        [wSelf.fireworks1 startAnimating];
    });
    
    
    [UIView animateKeyframesWithDuration:kFireOneAnimeDurat * 5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.1 animations:^{
            [self widgetAlpha:1];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
            CATransform3D transform = CATransform3DIdentity;
            self.castle.layer.transform = transform;
            self.cloundWest.frame = self.cloundWestFinalF;
            self.cloundNortheast.frame = self.cloundNorthFinalF;
            self.cloundSoutheast.frame = self.cloundSouthFinalF;
            
        }];
        
    } completion:^(BOOL finished) {
        [self reset];
    }];
}*/

- (void)play {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFireOneAnimeDurat * 0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.flagView startAnimating];
        self.fireworks1.hidden = NO;
        if (!self.fireworks1.superview) {
            [self.boxView addSubview:self.fireworks1];
        }
        [self.fireworks1 startAnimating];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFireOneAnimeDurat * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fireworks2.hidden = NO;
        if (!self.fireworks2.superview) {
            [self.boxView addSubview:self.fireworks2];
        }
        [self.fireworks2 startAnimating];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFireOneAnimeDurat * 2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fireworks3.hidden = NO;
        if (!self.fireworks3.superview) {
            [self.boxView addSubview:self.fireworks3];
        }
        [self.fireworks3 startAnimating];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFireOneAnimeDurat * 3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fireworks4.hidden = NO;
        if (!self.fireworks4.superview) {
            [self.boxView addSubview:self.fireworks4];
        }
        [self.fireworks4 startAnimating];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kFireOneAnimeDurat * 4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.fireworks5.hidden = NO;

        if (!self.fireworks5.superview) {
            [self.boxView addSubview:self.fireworks5];
        }
        [self.fireworks5 startAnimating];
    });


    [UIView animateKeyframesWithDuration:kFireOneAnimeDurat * 5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.1 animations:^{
            [self widgetAlpha:1];
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
            CATransform3D transform = CATransform3DIdentity;
            self.castle.layer.transform = transform;
            self.cloundWest.frame = self.cloundWestFinalF;
            self.cloundNortheast.frame = self.cloundNorthFinalF;
            self.cloundSoutheast.frame = self.cloundSouthFinalF;
            
        }];
        
    } completion:^(BOOL finished) {
        [self reset];
    }];
}

- (void)stop {
    [self.flagView stopAnimating];
    [self.fireworks1 stopAnimating];
}

- (void)hideTheFireworks {
    self.fireworks1.hidden = YES;
    self.fireworks2.hidden = YES;
    self.fireworks3.hidden = YES;
    self.fireworks4.hidden = YES;
    self.fireworks5.hidden = YES;
}

- (void)widgetAlpha:(CGFloat)alpha {
    self.castle.alpha = alpha;
    self.cloundWest.alpha = alpha;
    self.cloundNortheast.alpha = alpha;
    self.cloundSoutheast.alpha = alpha;
}

- (void)reset {
    [self widgetAlpha:0];
    self.fireworks1.frame = self.fireFrame1Orin;
    self.fireworks2.frame = self.fireFrame2Orin;
    
    [self.fireworks1 stopAnimating];
    [self.fireworks2 stopAnimating];
    [self.fireworks3 stopAnimating];
    [self.fireworks4 stopAnimating];
    [self.fireworks5 stopAnimating];
    
    self.fireworks1.currentAnimatedImageIndex = 0;
    self.fireworks2.currentAnimatedImageIndex = 0;
    self.fireworks3.currentAnimatedImageIndex = 0;
    self.fireworks4.currentAnimatedImageIndex = 0;
    self.fireworks5.currentAnimatedImageIndex = 0;
    
    self.cloundWest.frame = self.cloundWestOrigiF;
    self.cloundNortheast.frame = self.cloundNorthOrigiF;
    self.cloundSoutheast.frame = self.cloundSouthOrigiF;
    
    [self hideTheFireworks];
    
    [self play];
}

#pragma mark - Castle
- (UIImageView *)castle {
    if (_castle == nil) {
        
        CGFloat cW = [self valueCompat:kCastleW];
        CGFloat cH = [self valueCompat:kCastleH];
        
        CGRect frame = CGRectMake((self.widgetWidth - cW) / 2, (self.widgetHeight - cH), cW, cH);
        
        _castle = [UIImageView new];
        _castle.frame = frame;
        _castle.image = [self loadImage:@"castle/castle"];
        
    }
    return _castle;
}

#pragma mark - flagView
- (YYAnimatedImageView *)flagView {
    if (_flagView == nil) {
        
        CGFloat cW = [self valueCompat:kFlagW];
        CGFloat cH = [self valueCompat:kFlagH];
        
        self.flagFrame = [NSMutableArray array];
        self.flagDurat = [NSMutableArray array];
        for (NSInteger i = 0; i < 24; i ++) {
            
            NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
            NSString *fileName = [NSString stringWithFormat:@"%@/castle/flag/flag_%ld.png",bundlePath, (long)i];
            [self.flagFrame addObject:fileName];
            [self.flagDurat addObject:@(0.15)];
        }
        
        CGFloat castleW = [self valueCompat:kCastleW];
        CGFloat left = (castleW - cW) / 2 + [self valueCompat:10];
        CGFloat top = -[self valueCompat:kFlagH - 6];
        
        self.flagImage = [[YYFrameImage alloc] initWithImagePaths:self.flagFrame frameDurations:self.flagDurat loopCount:0];
        
        _flagView = [[YYAnimatedImageView alloc] init];
        _flagView.frame = CGRectMake(left, top, cW, cH);
        _flagView.image = self.flagImage;
        _flagView.autoPlayAnimatedImage = NO;
    }
    return _flagView;
}

- (UIImageView *)cloundWest {
    if (_cloundWest == nil) {
        
        CGFloat cW = [self valueCompat:kCastleClound02W];
        CGFloat cH = [self valueCompat:kCastleClound02H];
        _cloundWest = [UIImageView new];
        
        CGFloat left = 0;
        CGFloat top = [self valueCompat:100];
        _cloundWest.contentMode = UIViewContentModeScaleAspectFill;
        _cloundWest.frame = CGRectMake(left, top, cW, cH);
        
        self.cloundWestOrigiF = _cloundWest.frame;
        self.cloundWestFinalF = CGRectMake(left + [self valueCompat:30], top, cW, cH);

        _cloundWest.image = [self loadImage:@"helicopter/clound02"];
        
    }
    return _cloundWest;
}

- (UIImageView *)cloundSoutheast {
    if (_cloundSoutheast == nil) {
        
        CGFloat cW = [self valueCompat:kCastleClound01W];
        CGFloat cH = [self valueCompat:kCastleClound01H];
        _cloundSoutheast = [UIImageView new];
        
        CGFloat left = self.widgetWidth - cW * 1.6;
        CGFloat top = cH * 2.3;
        _cloundSoutheast.contentMode = UIViewContentModeScaleAspectFill;
        _cloundSoutheast.frame = CGRectMake(left, top, cW, cH);
        _cloundSoutheast.image = [self loadImage:@"helicopter/clound01"];
        
        self.cloundSouthOrigiF = _cloundSoutheast.frame;
        self.cloundSouthFinalF = CGRectMake(left - [self valueCompat:30], top, cW, cH);
        
    }
    return _cloundSoutheast;
}

- (UIImageView *)cloundNortheast {
    if (_cloundNortheast == nil) {
        
        CGFloat cW = [self valueCompat:kCastleClound03W];
        CGFloat cH = [self valueCompat:kCastleClound03H];
        _cloundNortheast = [UIImageView new];
        
        CGFloat left = self.widgetWidth - cW * 2.6;
        CGFloat top = cH * 2;
        _cloundNortheast.contentMode = UIViewContentModeScaleAspectFill;
        _cloundNortheast.frame = CGRectMake(left, top, cW, cH);
        _cloundNortheast.image = [self loadImage:@"helicopter/clound03"];
        
        self.cloundNorthOrigiF = _cloundNortheast.frame;
        self.cloundNorthFinalF = CGRectMake(left + [self valueCompat:20], top, cW, cH);
    }
    return _cloundNortheast;
}


// 烟火图片
- (YYFrameImage *)fireworksImage {
    if (_fireworksImage == nil) {
        
        self.fireworkFrame = [NSMutableArray array];
        self.fireworkDurat = [NSMutableArray array];
        for (NSInteger i = 0; i < 21; i ++) {
            
            NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
            NSString *fileName = [NSString stringWithFormat:@"%@/castle/fireworks/fire_%ld.png",bundlePath, (long)i];
            [self.fireworkFrame addObject:fileName];
            [self.fireworkDurat addObject:@(kFireFrameDuration)];
        }
        
        _fireworksImage = [[YYFrameImage alloc] initWithImagePaths:self.fireworkFrame frameDurations:self.fireworkDurat loopCount:1];

    }
    return _fireworksImage;
}

- (AnimatedImageView *)generateAFireworks {
    
    CGFloat cW = [self valueCompat:kFireworksW];
    CGFloat cH = [self valueCompat:kFireworksH];
    
    AnimatedImageView *fire = [[AnimatedImageView alloc] init];
    fire.frame = CGRectMake(0, 0, cW, cH);
    fire.image = self.fireworksImage;
    fire.autoPlayAnimatedImage = NO;
    return fire;
}

@end

