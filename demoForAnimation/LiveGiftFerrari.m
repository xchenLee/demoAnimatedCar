//
//  LiveGiftFerrari.m
//  demoForAnimation
//
//  Created by dreamer on 2017/6/16.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import "LiveGiftFerrari.h"
#import <YYImage.h>

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height


static const CGFloat kFerrariW = 750.0;
static const CGFloat kFerrarih = 329.0;

static const CGFloat kFerrariDoorW = 171.0;
static const CGFloat kFerrariDoorH = 101.0;

static const CGFloat kFerrariRDoorW = 161.0;
static const CGFloat kFerrariRDoorH = 96.0;


@interface LiveGiftFerrari()

@property(nonatomic, assign) CGFloat scale;

@property(nonatomic, strong) UIView      *carBox;
@property(nonatomic, strong) UIImageView *mainFrame;
@property(nonatomic, strong) UIImageView *mainFrameCover;

@property(nonatomic, strong) UIImageView *rDoorFrame;
@property(nonatomic, strong) UIImageView *lDoorFrame;

@property(nonatomic, strong) UIImageView *fTireFrame;
@property(nonatomic, strong) UIImageView *bTireFrame;

@property(nonatomic, strong) YYAnimatedImageView *lightView;
@property(nonatomic, strong) YYFrameImage *lightImage;

@property(nonatomic, strong) NSMutableArray *fileNames;
@property(nonatomic, strong) NSMutableArray *durations;


@end

@implementation LiveGiftFerrari



- (void)loadSources {
    
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
}

- (void)play {
    [self doEnterAnimation];
    [self doFTireRotateAnimation];
    [self doBTireRotateAnimation];
}

#pragma mark - 构造车身控件
- (void)construct {
    
    CGRect frame = CGRectMake(0, 0, kScreenWidth, kFerrarih / self.scaleRate);
    self.frame = frame;
    
    //car盒子
    self.carBox = [UIView new];
    frame.origin.x = kScreenWidth;
    self.carBox.frame = frame;
    [self addSubview:self.carBox];
    
    //右门在车身后边显示
    CGRect rDoorRect = CGRectMake(0, 0, [self valueCompat:kFerrariRDoorW], [self valueCompat:kFerrariRDoorH]);
    rDoorRect.origin.x = [self valueCompat:224];
    rDoorRect.origin.y = [self valueCompat:126];
    _rDoorFrame = [UIImageView new];
    _rDoorFrame.image = [self loadImage:@"car/car_door_r"];
    _rDoorFrame.layer.anchorPoint = CGPointMake(0.0, 45.0 / kFerrariRDoorH);
    _rDoorFrame.frame = rDoorRect;
    [self.carBox addSubview:_rDoorFrame];
    
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
    btireFrame.origin.x = [self valueCompat:582.0];
    btireFrame.origin.y = self.frame.size.height - tireFrame.size.height - [self valueCompat:92];
    
    //车身cover
    frame.origin.x = 0;
    _mainFrameCover = [UIImageView new];
    _mainFrameCover.frame = frame;
    _mainFrameCover.alpha = 0.0;
    _mainFrameCover.image = [self loadImage:@"car/car_body_light"];
    [self.carBox addSubview:_mainFrameCover];
    
    UIImage *tireImage = [self loadImage:@"car/car_tire"];
    //前轮
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
    
    //左门
    CGRect lDoorRect = CGRectMake(0, 0, [self valueCompat:kFerrariDoorW], [self valueCompat:kFerrariDoorH]);
    lDoorRect.origin.x = [self valueCompat:316];
    lDoorRect.origin.y = [self valueCompat:130];
    
    _lDoorFrame = [UIImageView new];
    _lDoorFrame.image = [self loadImage:@"car/car_door_l"];
    _lDoorFrame.layer.anchorPoint = CGPointMake(0.1, 45.0 / kFerrariDoorH);
    _lDoorFrame.frame = lDoorRect;
    [self.mainFrame addSubview:_lDoorFrame];
    
    self.lightView.frame = frame;
    [self addSubview:self.lightView];
}

#pragma mark - 动画
- (void)doEnterAnimation {
    
    /*CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.x"];
    animation.duration = 0.8;
    animation.removedOnCompletion = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = @(kScreenWidth + kScreenWidth * 0.5);
    animation.toValue =  @(kScreenWidth * 0.5);
    [self.mainFrame.layer addAnimation:animation forKey:@"position"];
    */
    
    CGRect frame = self.mainFrameCover.frame;
    CGRect endFrame = frame;
    endFrame.origin.x = - kScreenWidth;
    
    
    [UIView animateKeyframesWithDuration:5 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        
        //Section 1
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.2 animations:^{
            self.carBox.frame = frame;
            [self.fTireFrame.layer setTransform:CATransform3DRotate(self.fTireFrame.layer.transform, M_PI, 0, 0, -1)];
            [self.bTireFrame.layer setTransform:CATransform3DRotate(self.bTireFrame.layer.transform, M_PI, 0, 0, -1)];
        }];
        
        //Section 2
        [UIView addKeyframeWithRelativeStartTime:0.2 relativeDuration:0.2 animations:^{
            self.mainFrameCover.alpha = 0.5;
            self.lDoorFrame.transform = CGAffineTransformMakeRotation(-M_PI / 4.0);
            self.rDoorFrame.transform = CGAffineTransformMakeRotation(-M_PI / 4.0);
        }];
        
        //Section 3
        [UIView addKeyframeWithRelativeStartTime:0.4 relativeDuration:0.05 animations:^{
            self.mainFrameCover.alpha = 0.3;
        }];
        
        //Section 4
        [UIView addKeyframeWithRelativeStartTime:0.45 relativeDuration:0.05 animations:^{
            self.mainFrameCover.alpha = 0.5;
        }];
        
        //Section 4
        [UIView addKeyframeWithRelativeStartTime:0.50 relativeDuration:0.05 animations:^{
            self.mainFrameCover.alpha = 0.3;
        }];
        
        
        //Section 6
        [UIView addKeyframeWithRelativeStartTime:0.75 relativeDuration:0.15 animations:^{
            self.mainFrameCover.alpha = 0;
            self.lDoorFrame.transform = CGAffineTransformRotate(self.lDoorFrame.transform, M_PI / 4.0);
            self.rDoorFrame.transform = CGAffineTransformRotate(self.rDoorFrame.transform, M_PI / 4.0);
        }];
        
        //Section 7
        [UIView addKeyframeWithRelativeStartTime:0.85 relativeDuration:0.15 animations:^{
            [self.fTireFrame.layer setTransform:CATransform3DRotate(self.fTireFrame.layer.transform, M_PI, 0, 0, -1)];
            [self.bTireFrame.layer setTransform:CATransform3DRotate(self.bTireFrame.layer.transform, M_PI, 0, 0, -1)];
        }];
        
        //Section 8
        [UIView addKeyframeWithRelativeStartTime:0.9 relativeDuration:0.1 animations:^{
            self.carBox.frame = endFrame;
        }];
        
    } completion:^(BOOL finished) {
        [self reset];
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.lightView startAnimating];
    });
    
}

- (void)doFTireRotateAnimation {
    
    /*
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    animation.toValue = @(-M_PI / 8);
    animation.removedOnCompletion = NO;
    animation.autoreverses = NO;
    animation.fillMode = kCAFillModeForwards;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.fTireFrame.layer addAnimation:animation forKey:@"transform.rotation.y"];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 0.6;
    animation.toValue = @(M_PI * 2);
    animation.repeatCount = MAXFLOAT;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    [self.fTireFrame.layer addAnimation:animation forKey:@"transform.rotation.z"];*/
    
//    [UIView animateWithDuration:0.15 delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
//        [self.fTireFrame.layer setTransform:CATransform3DRotate(self.fTireFrame.layer.transform, M_PI * 0.5f, 0, 0, -1)];
//    } completion:^(BOOL finished) {
//        [self doFTireRotateAnimation];
//    }];
}

- (void)doBTireRotateAnimation {
    
//    [UIView animateWithDuration:0.15 delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
//        [self.bTireFrame.layer setTransform:CATransform3DRotate(self.bTireFrame.layer.transform, M_PI * 0.5f, 0, 0, -1)];
//    } completion:^(BOOL finished) {
//        [self doBTireRotateAnimation];
//    }];
}

#pragma mark - 加载图片
- (UIImage *)loadImage:(NSString *)suffix {
    NSString *imageFile = [NSString stringWithFormat:@"%@/%@.png", [[NSBundle mainBundle] resourcePath], suffix];
    NSData *imageData = [NSData dataWithContentsOfFile:imageFile];
    UIImage *image = [UIImage imageWithData:imageData scale:[[UIScreen mainScreen] scale]];
    return image;
}

#pragma mark - 长宽值变换
- (CGFloat)valueCompat:(CGFloat)value {
    return value / self.scaleRate;
}

- (CGFloat)scaleRate {
    if (_scale == 0) {
        _scale = kFerrariW / kScreenWidth;
    }
    return _scale;
}

- (void)reset {
    [self.lightView stopAnimating];
    CGRect carFrame = self.carBox.frame;
    carFrame.origin.x = kScreenWidth;
    self.carBox.frame = carFrame;
    self.mainFrameCover.alpha = 0;
    self.lightView.currentAnimatedImageIndex = 0;
    [self doEnterAnimation];
}

@end
