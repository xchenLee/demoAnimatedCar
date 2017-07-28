//
//  LiveHelicopter.m
//  demoForAnimation
//
//  Created by danlan on 2017/6/29.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import "LiveHelicopter.h"

static const CGFloat kLiveHelicopterW = 466.0 * 1.1;
static const CGFloat kLiveHelicopterH = 267.0 * 1.1;
static const CGFloat kLiveHPropellerPW = 124.0;
static const CGFloat kLiveHPropellerPH = 277.0;


//原图太大，再基础上再缩小一些
static const CGFloat kLiveHClound01W = 232.0 * 0.8;
static const CGFloat kLiveHClound01H = 119.0 * 0.8;
static const CGFloat kLiveHClound02W = 412.0 * 0.8;
static const CGFloat kLiveHClound02H = 241.0 * 0.8;
static const CGFloat kLiveHClound03W = 188.0 * 0.8;
static const CGFloat kLiveHClound03H = 111.0 * 0.8;


@interface LiveHelicopter()

@property (nonatomic, strong) UIView *propellerView;
@property (nonatomic, strong) UIView *boxView;
@property (nonatomic, strong) UIImageView *bodyView;
@property (nonatomic, strong) UIImageView *bPropellerView;
@property (nonatomic, strong) UIImageView *bPropellerMaskView;

@property (nonatomic, strong) UIImageView *clound01;
@property (nonatomic, strong) UIImageView *clound02;
@property (nonatomic, strong) UIImageView *clound03;

@property (nonatomic, assign) CGRect cloud01OriginFrame;
@property (nonatomic, assign) CGRect cloud02OriginFrame;
@property (nonatomic, assign) CGRect cloud03OriginFrame;

@property (nonatomic, assign) CGRect cloud01FinalFrame;
@property (nonatomic, assign) CGRect cloud02FinalFrame;
@property (nonatomic, assign) CGRect cloud03FinalFrame;

@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) CAEmitterLayer *emitter;


@end


@implementation LiveHelicopter

- (void)preload {
    
    CGRect boxFrame = self.bounds;
    
    //云朵
    [self makeClounds];
    
    //盒子
    self.boxView = [UIView new];
    boxFrame.origin.x = [self enterPositonX];
    boxFrame.origin.y = [self enterPositonY];
    self.boxView.frame = boxFrame;
    [self addSubview:self.boxView];
    
    //后面的小桨叶
    CGFloat bPropellerSize = [self valueCompat:56];
    self.bPropellerView = [UIImageView new];
    self.bPropellerView.bounds = CGRectMake(0, 0, bPropellerSize, bPropellerSize);
    self.bPropellerView.image = [UIImage imageNamed:@"helicopter/bpropeller"];
    
    CGRect bPFrame = self.bPropellerView.frame;
    bPFrame.origin.x = [self valueCompat:560];
    bPFrame.origin.y = [self valueCompat:66]; // 134
    self.bPropellerView.frame = bPFrame;
    CATransform3D btransform = CATransform3DMakeRotation(M_PI * 2 / 3, 0, 1, 0);
    self.bPropellerView.layer.transform = btransform;
    
    [self.boxView addSubview:self.bPropellerView];
    
    //机身
    boxFrame.origin.x = 0;
    self.bodyView = [UIImageView new];
    CGFloat bodyW = [self valueCompat:kLiveHelicopterW];
    CGFloat bodyH = [self valueCompat:kLiveHelicopterH];

    self.bodyView.frame = CGRectMake((self.widgetWidth - bodyW)/2, (self.widgetHeight - bodyH)/2, bodyW, bodyH);
    self.bodyView.image = [self loadImage:@"helicopter/helicopter"];
    [self.boxView addSubview:self.bodyView];
    
    //大螺旋桨
    [self makeFrontPropeller];
    
    self.coverView = [UIView new];
    CGRect coverFrame = self.bounds;
    coverFrame.size = CGSizeMake(coverFrame.size.width, coverFrame.size.height * 1.5);
    coverFrame.origin.y = coverFrame.size.height * (-0.4);
    self.coverView.frame = coverFrame;
    self.coverView.clipsToBounds = YES;
    [self addSubview:self.coverView];
    
}

#pragma mark - 云朵
- (void)makeClounds {
    
    self.clound01 = [UIImageView new];
    self.clound01.bounds = CGRectMake(0, 0, [self valueCompat:kLiveHClound01W], [self valueCompat:kLiveHClound01H]);
    self.clound01.image = [self loadImage:@"helicopter/clound01"];
    [self addSubview:self.clound01];
    
    
    self.clound03 = [UIImageView new];
    self.clound03.bounds = CGRectMake(0, 0, [self valueCompat:kLiveHClound03W], [self valueCompat:kLiveHClound03H]);
    self.clound03.alpha = 0;
    self.clound03.contentMode = UIViewContentModeScaleToFill;
    self.clound03.image = [self loadImage:@"helicopter/clound03"];
    [self addSubview:self.clound03];
    
    self.clound02 = [UIImageView new];
    self.clound02.bounds = CGRectMake(0, 0, [self valueCompat:kLiveHClound02W], [self valueCompat:kLiveHClound02H]);
    self.clound02.alpha = 0;
    self.clound02.image = [self loadImage:@"helicopter/clound02"];
    [self addSubview:self.clound02];
    
    
    //构造初始位置
    CGRect cloudFrame01 = self.clound01.frame;
    cloudFrame01.origin.x = -cloudFrame01.size.width * 0.6 + (-(self.vScreenWidth - self.widgetWidth) / 2);
    cloudFrame01.origin.y = cloudFrame01.size.height * 0.9 + self.widgetHeight;
    self.clound01.frame = cloudFrame01;
    self.cloud01OriginFrame = cloudFrame01;
    
    
    CGRect cloud01inaleF = cloudFrame01;
    cloud01inaleF.origin.x = cloudFrame01.size.width * 0.6;
    cloud01inaleF.origin.y = self.widgetHeight - self.clound01.frame.size.height * 0.5;
    self.cloud01FinalFrame = cloud01inaleF;
    
    
    //云朵2
    CGRect cloudFrame02 = self.clound02.frame;
    cloudFrame02.origin.x = -cloudFrame02.size.width * 0.7 + (-(self.vScreenWidth - self.widgetWidth) / 2);
    cloudFrame02.origin.y = self.widgetHeight - self.clound02.frame.size.height * 0.2;
    self.clound02.frame = cloudFrame02;
    self.cloud02OriginFrame = cloudFrame02;
    
    CGRect cloud02inaleF = cloudFrame02;
    cloud02inaleF.origin.x = -cloudFrame02.size.width * 0.2 + (self.vScreenWidth + self.widgetWidth) / 2;
    cloud02inaleF.origin.y = - self.clound02.frame.size.height * 0.2;
    
    self.cloud02FinalFrame = cloud02inaleF;
    
    
    //云朵3
    CGRect cloudFrame03 = self.clound03.frame;
    cloudFrame03.origin.x = cloudFrame03.size.width * 0.35;
    cloudFrame03.origin.y = self.widgetHeight - self.clound03.frame.size.height;
    self.clound03.frame = cloudFrame03;
    self.cloud03OriginFrame = cloudFrame03;
    
    
    CGRect cloud03inaleF = cloudFrame03;
    cloud03inaleF.origin.x = -cloudFrame03.size.width + (self.vScreenWidth + self.widgetWidth) / 2;
    cloud03inaleF.origin.y = self.widgetHeight - self.clound03.frame.size.height * 2;
    
    self.cloud03FinalFrame = cloud03inaleF;

}


#pragma mark - 大螺旋桨
- (void)makeFrontPropeller {
    
    CGFloat paddleW = [self valueCompat:kLiveHPropellerPW];
    CGFloat paddleH = [self valueCompat:kLiveHPropellerPH];
    
    CGFloat anchorY = 262.0 / kLiveHPropellerPH;

    CGFloat propellerHalf = paddleH * anchorY;
    CGFloat propellerSize = propellerHalf * 2;
    
    self.propellerView = [UIView new];
    self.propellerView.frame = CGRectMake([self valueCompat:-64], [self valueCompat:-196], propellerSize, propellerSize);
    [self.bodyView addSubview:self.propellerView];
    
    UIImage *paddleImage = [self loadImage:@"helicopter/fpropeller_singular"];
    
    CGRect paddleFrame = CGRectMake((propellerSize - paddleW) / 2, 0, paddleW, paddleH);
    
    CGPoint anchorPoint = CGPointMake(60.0 / 124, anchorY);
    CGPoint position = CGPointMake(propellerHalf, propellerHalf);
    
    
    UIImageView *paddle01 = [UIImageView new];
    paddle01.frame = paddleFrame;
    paddle01.image = paddleImage;
    [self.propellerView addSubview:paddle01];
    
    CGRect paddleBounds = paddleFrame;
    paddleBounds.origin.x = 0;
    paddleBounds.origin.y = 0;
    UIImageView *paddle02 = [UIImageView new];
    paddle02.bounds = paddleBounds;
    paddle02.image = paddleImage;
    paddle02.layer.anchorPoint = anchorPoint;
    paddle02.layer.position = position;
    [self.propellerView addSubview:paddle02];
    
    UIImageView *paddle03 = [UIImageView new];
    paddle03.bounds = paddleBounds;
    paddle03.image = paddleImage;
    paddle03.layer.anchorPoint = anchorPoint;
    paddle03.layer.position = position;
    [self.propellerView addSubview:paddle03];
    
    //开始转动桨叶
    paddle02.transform = CGAffineTransformMakeRotation(M_PI * 2 / 3);
    paddle03.transform = CGAffineTransformMakeRotation(-M_PI * 2 / 3);

    //开始偏移螺旋桨
    CATransform3D transform = CATransform3DMakeRotation(M_PI * 2 / 3, 1, 0, 0);
    CGFloat translateZ = paddleH * sin(M_PI / 3);
    self.propellerView.layer.transform = CATransform3DTranslate(transform, 0, 0, translateZ);
    self.propellerView.layer.transform = transform;
}

- (void)play {
    [self rotatePropellerWithDuration:0.05];
    [self startKeyFrameAnimation];
}

- (void)startKeyFrameAnimation {
    [UIView animateKeyframesWithDuration:4 delay:0 options:UIViewKeyframeAnimationOptionCalculationModeLinear animations:^{
        
        //机身进场
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.18 animations:^{
            CGFloat top = self.widgetHeight * 0.11;
            CGFloat left = self.widgetWidth * 0.05;
            self.boxView.frame =  CGRectMake(left, top, self.widgetWidth, self.widgetHeight);
        }];
        
        //云朵开始
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:1 animations:^{
            self.clound01.frame = self.cloud01FinalFrame;
            self.clound02.frame = self.cloud02FinalFrame;
            self.clound03.frame = self.cloud03FinalFrame;
        }];
        [UIView addKeyframeWithRelativeStartTime:0.0 relativeDuration:0.22 animations:^{
            self.clound02.alpha = 0.9;
            self.clound01.alpha = 0.9;
            self.clound03.alpha = 0.9;
        }];
        
        //机身浮动
        [UIView addKeyframeWithRelativeStartTime:0.18 relativeDuration:0.22 animations:^{
            CGFloat top = self.widgetHeight * 0.13;
            CGFloat left = self.widgetWidth * 0.09;
            self.boxView.frame =  CGRectMake(left, top, self.widgetWidth, self.widgetHeight);
        }];
        
        //机身浮动
        [UIView addKeyframeWithRelativeStartTime:0.40 relativeDuration:0.22 animations:^{
            CGFloat top = self.widgetHeight * 0.10;
            CGFloat left = self.widgetWidth * 0.11;
            self.boxView.frame =  CGRectMake(left, top, self.widgetWidth, self.widgetHeight);
        }];
        
        //机身浮动
        [UIView addKeyframeWithRelativeStartTime:0.62 relativeDuration:0.25 animations:^{
            CGFloat top = self.widgetHeight * 0.08;
            CGFloat left = self.widgetWidth * 0.22;
            self.boxView.frame =  CGRectMake(left, top, self.widgetWidth, self.widgetHeight);
        }];
        
        //云朵结束
        [UIView addKeyframeWithRelativeStartTime:0.8 relativeDuration:0.2 animations:^{
            self.clound01.alpha = 0.0;
            self.clound02.alpha = 0.0;
            self.clound03.alpha = 0.0;
        }];
        
        [UIView addKeyframeWithRelativeStartTime:0.87 relativeDuration:0.13 animations:^{
            CGFloat top = [self quitPositionY];
            CGFloat left = [self quitPositionX] + self.widgetWidth * (-0.1);
            self.boxView.frame =  CGRectMake(left, top, self.widgetWidth, self.widgetHeight);
        }];
        
    } completion:^(BOOL finished) {
        [self reset];
    }];
    
}

- (void)rotatePropellerWithDuration:(NSTimeInterval)duration{
    
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveLinear animations:^{
        [self.propellerView.layer setTransform:CATransform3DRotate(self.propellerView.layer.transform, M_PI / 2, 0, 0, -1)];
        
        [self.bPropellerView.layer setTransform:CATransform3DRotate(self.bPropellerView.layer.transform, M_PI / 2, 0, 0, -1)];
    } completion:^(BOOL finished) {
        [self rotatePropellerWithDuration:duration];
    }];
}

- (CGFloat)enterPositonY {
    return  -0.3 * self.widgetHeight;
}

- (CGFloat)quitPositionY {
    return 0.6 * self.widgetHeight;
}

- (void)reset {
    CGRect boxFrame = self.bounds;
    boxFrame.origin.x = [self enterPositonX];
    boxFrame.origin.y = [self enterPositonY];
    
    self.clound01.frame = self.cloud01OriginFrame;
    self.clound01.alpha = 0.0;
    
    self.clound02.frame = self.cloud02OriginFrame;
    self.clound02.alpha = 0.0;
    
    self.clound03.frame = self.cloud03OriginFrame;
    self.clound03.alpha = 0.0;
    
    self.boxView.frame = boxFrame;
    [self.emitter removeAllAnimations];
    [self.emitter removeFromSuperlayer];
    [self startKeyFrameAnimation];
}

@end

