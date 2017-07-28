//
//  LiveCruise.m
//  demoForAnimation
//
//  Created by danlan on 2017/7/19.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import "LiveCruise.h"
#include "YYImage.h"


static const CGFloat kCruiseW = 718.0;
static const CGFloat kCruiseH = 310.0;

static const CGFloat kSmokeW = 80;
static const CGFloat kSmokeH = 80;

static const CGFloat kSurfaceW = 750.0;
static const CGFloat kSurfaceH = 454.0;
static const CGFloat kWave1W = 191.0;
static const CGFloat kWave1H = 68;

static const CGFloat kWave2W = 89;
static const CGFloat kWave2H = 80;


@interface LiveCruise()

@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *bodyView;

@property (nonatomic, strong) YYAnimatedImageView *wave1;
@property (nonatomic, strong) YYFrameImage *wave1Image;

@property (nonatomic, strong) YYAnimatedImageView *wave1Copy;


@property (nonatomic, strong) YYAnimatedImageView *wave2;
@property (nonatomic, strong) YYFrameImage *wave2Image;

@property (nonatomic, strong) YYAnimatedImageView *wave2Copy;


@property (nonatomic, strong) YYAnimatedImageView *surface;
@property (nonatomic, strong) YYFrameImage *surfaceImage;

@property (nonatomic, strong) YYAnimatedImageView *smoke;
@property (nonatomic, strong) YYFrameImage *smokeImage;

@property (nonatomic, strong) NSMutableArray *wave1Frames;
@property (nonatomic, strong) NSMutableArray *wave1Durati;

@property (nonatomic, strong) NSMutableArray *wave2Frames;
@property (nonatomic, strong) NSMutableArray *wave2Durati;

@property (nonatomic, strong) NSMutableArray *smokeFrames;
@property (nonatomic, strong) NSMutableArray *smokeDurati;

@property (nonatomic, strong) NSMutableArray *surFrames;
@property (nonatomic, strong) NSMutableArray *surDurati;

@end

@implementation LiveCruise


- (void)preload {
    
    [self loadCruiseResources];
    CGRect frame = self.bounds;
    
    self.boxView = [UIView new];
    self.boxView.frame = frame;
    [self addSubview:self.boxView];
    
    
    //海面
    CGFloat surW = [self valueCompat:kSurfaceW];
    CGFloat surH = [self valueCompat:kSurfaceH];
    
    self.surface = [[YYAnimatedImageView alloc] init];
    self.surface.frame = CGRectMake(0, 0, surW, surH);
    self.surface.image = self.surfaceImage;
    self.surface.autoPlayAnimatedImage = NO;
    [self.boxView addSubview:self.surface];
    
    
    CGFloat bodyW = [self valueCompat:kCruiseW];
    CGFloat bodyH = [self valueCompat:kCruiseH];
    CGRect bodyFrame = CGRectMake([self enterPositonX], [self enterPositonY], bodyW, bodyH);
    self.bodyView = [UIImageView new];
    self.bodyView.frame = bodyFrame;
    self.bodyView.contentMode = UIViewContentModeScaleAspectFill;
    self.bodyView.image = [self loadImage:@"cruise/body"];
    [self.boxView addSubview:self.bodyView];
    
    
    CGAffineTransform rotate = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI / 16);

    //wave1
    CGFloat wave1W = [self valueCompat:kWave1W];
    CGFloat wave1H = [self valueCompat:kWave1H];
    
    self.wave1 = [[YYAnimatedImageView alloc] init];
    self.wave1.frame = CGRectMake([self valueCompat:102], [self valueCompat:226], wave1W, wave1H);
    self.wave1.image = self.wave1Image;
    self.wave1.autoPlayAnimatedImage = NO;
    
    self.wave1.transform = rotate;
    
    
    CGFloat wave1CW = [self valueCompat:kWave1W * 0.8];
    CGFloat wave1CH = [self valueCompat:kWave1H * 0.8];
    self.wave1Copy = [[YYAnimatedImageView alloc] init];
    self.wave1Copy.frame = CGRectMake([self valueCompat:250], [self valueCompat:210], wave1CW, wave1CH);
    self.wave1Copy.image = self.wave1Image;
    self.wave1Copy.autoPlayAnimatedImage = NO;
    self.wave1Copy.transform = CGAffineTransformRotate(CGAffineTransformIdentity, -M_PI / 14);
    
    //wave2
    CGFloat wave2W = [self valueCompat:kWave2W];
    CGFloat wave2H = [self valueCompat:kWave2H];
    
    self.wave2 = [[YYAnimatedImageView alloc] init];
    self.wave2.frame = CGRectMake([self valueCompat:250], [self valueCompat:190], wave2W, wave2H);
    self.wave2.image = self.wave2Image;
    self.wave2.autoPlayAnimatedImage = NO;
    
    self.wave2.transform = rotate;
    
    
    //wave2Copy
    CGFloat wave2CW = [self valueCompat:kWave2W * 0.7];
    CGFloat wave2CH = [self valueCompat:kWave2H * 0.7];
    self.wave2Copy = [[YYAnimatedImageView alloc] init];
    self.wave2Copy.frame = CGRectMake([self valueCompat:360], [self valueCompat:192], wave2CW, wave2CH);
    self.wave2Copy.image = self.wave2Image;
    self.wave2Copy.autoPlayAnimatedImage = NO;
    self.wave2Copy.transform = rotate;

    
    [self.bodyView addSubview:self.wave1Copy];
    [self.bodyView addSubview:self.wave1];
    [self.bodyView addSubview:self.wave2];
    [self.bodyView addSubview:self.wave2Copy];
    
    //烟
    CGFloat smokeW = [self valueCompat:kSmokeW];
    CGFloat smokeH = [self valueCompat:kSmokeH];
    
    self.smoke = [[YYAnimatedImageView alloc] init];
    self.smoke.frame = CGRectMake([self valueCompat:490], [self valueCompat:-76], smokeW, smokeH);
    self.smoke.image = self.smokeImage;
    self.smoke.autoPlayAnimatedImage = NO;
    
    self.smoke.transform = rotate;
    [self.bodyView addSubview:self.smoke];

    [self resetAlpha:0];
}

- (void)loadCruiseResources {
    
    // 海面
    self.surFrames = [NSMutableArray array];
    self.surDurati = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i ++) {
        
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *fileName = [NSString stringWithFormat:@"%@/cruise/surface/sur_%ld.png",bundlePath, (long)i];
        [self.surFrames addObject:fileName];
        [self.surDurati addObject:@(0.2)];
    }
    
    self.surfaceImage = [[YYFrameImage alloc] initWithImagePaths:self.surFrames frameDurations:self.surDurati loopCount:0];
    
    
    // 海浪1
    self.wave1Frames = [NSMutableArray array];
    self.wave1Durati = [NSMutableArray array];
    for (NSInteger i = 0; i < 13; i ++) {
        
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *fileName = [NSString stringWithFormat:@"%@/cruise/wave1/wave1_%ld.png",bundlePath, (long)i];
        [self.wave1Frames addObject:fileName];
        [self.wave1Durati addObject:@(0.08)];
    }
    
    self.wave1Image = [[YYFrameImage alloc] initWithImagePaths:self.wave1Frames frameDurations:self.wave1Durati loopCount:0];
    
    // 海浪2
    self.wave2Frames = [NSMutableArray array];
    self.wave2Durati = [NSMutableArray array];
    for (NSInteger i = 0; i < 9; i ++) {
        
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *fileName = [NSString stringWithFormat:@"%@/cruise/wave2/wave2_%ld.png",bundlePath, (long)i];
        [self.wave2Frames addObject:fileName];
        [self.wave2Durati addObject:@(0.12)];
    }
    
    self.wave2Image = [[YYFrameImage alloc] initWithImagePaths:self.wave2Frames frameDurations:self.wave2Durati loopCount:0];
    
    
    // smoke
    self.smokeFrames = [NSMutableArray array];
    self.smokeDurati = [NSMutableArray array];
    for (NSInteger i = 0; i < 15; i ++) {
        
        NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
        NSString *fileName = [NSString stringWithFormat:@"%@/cruise/smoke/smoke_%ld.png",bundlePath, (long)i];
        [self.smokeFrames addObject:fileName];
        [self.smokeDurati addObject:@(0.12)];
    }
    
    self.smokeImage = [[YYFrameImage alloc] initWithImagePaths:self.smokeFrames frameDurations:self.smokeDurati loopCount:0];
}

- (void)play {
    
    [self.surface startAnimating];
    [self.wave1 startAnimating];
    [self.wave1Copy startAnimating];
    [self.wave2 startAnimating];
    [self.smoke startAnimating];
    [self.wave2Copy startAnimating];
    
    CGRect bodyFrame = self.bodyView.frame;

    [UIView animateKeyframesWithDuration:3 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:0.3 animations:^{
            [self resetAlpha:1];
        }];
        
        
        [UIView addKeyframeWithRelativeStartTime:0 relativeDuration:1.0 animations:^{
            self.bodyView.frame = CGRectMake([self quitPositionX], [self quitPositionY], bodyFrame.size.width, bodyFrame.size.height);
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            [self resetAlpha:0];
        }];
        
    } completion:^(BOOL finished) {
        [self reset];
        [self play];
    }];
}

- (void)resetAlpha:(CGFloat)alpha {
    self.bodyView.alpha = alpha;
    self.surface.alpha = alpha;
    self.wave1.alpha = alpha;
    self.wave1Copy.alpha = alpha;
    self.wave2.alpha = alpha;
    self.smoke.alpha = alpha;
    self.wave2Copy.alpha = alpha;
}

- (void)reset {
    CGRect bodyFrame = self.bodyView.frame;
    [self.wave2Copy stopAnimating];
    [self.wave2 stopAnimating];
    [self.wave1Copy stopAnimating];
    [self.wave1 stopAnimating];
    [self.wave1Copy stopAnimating];
    [self.surface stopAnimating];

    self.bodyView.frame = CGRectMake([self enterPositonX], [self enterPositonY], bodyFrame.size.width, bodyFrame.size.height);
}

- (CGFloat)enterPositonX {
    return self.frame.size.width / 6.0;
}

- (CGFloat)quitPositionX {
    return - self.frame.size.width * 0.1;
}

- (CGFloat)quitPositionY {
    return tan(M_PI / 16) * ([self enterPositonX] - [self quitPositionX]);
}

@end

