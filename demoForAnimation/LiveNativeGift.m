//
//  LiveNativeGift.m
//  demoForAnimation
//
//  Created by danlan on 2017/6/19.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import "LiveNativeGift.h"

@interface LiveNativeGift()

@property (nonatomic, assign, readwrite) CGFloat scaleRate;
@property (nonatomic, assign, readwrite) CGFloat originalW;
@property (nonatomic, assign, readwrite) CGFloat originalH;

@property (nonatomic, assign) CGFloat preferedWidth;
@property (nonatomic, assign) CGFloat preferedHeight;


@end

@implementation LiveNativeGift


#pragma mark - 构造器
- (instancetype)initWithOriginWidth:(CGFloat)originalWidth
                       originHeight:(CGFloat)originalHeight {
    
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.originalW = originalWidth;
        self.originalH = originalHeight;
        self.preferedWidth = self.widgetWidth;
        [self customInit];
    }
    return self;
}

- (instancetype)initWithOriginWidth:(CGFloat)originalWidth
                       originHeight:(CGFloat)originalHeight
                      preferedWidth:(CGFloat)preferedWidth {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.originalW = originalWidth;
        self.originalH = originalHeight;
        self.preferedWidth = preferedWidth;
        [self customInit];
    }
    return self;
}

- (void)customInit {
    self.scaleRate = _preferedWidth / _originalW;
    self.frame = CGRectMake(0, 0, self.widgetWidth, self.widgetHeight);
    [self preload];
}

- (void)preload {};
- (void)construct {};

#pragma mark - 播放，停止
- (void)play {}
- (void)stop {}
- (void)reset {}

#pragma mark - 控件宽度，高度
- (CGFloat)vScreenWidth {
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    return MIN(w, h);
}

- (CGFloat)widgetWidth {
    if (_preferedWidth > 0) {
        return _preferedWidth;
    }
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    CGFloat h = [UIScreen mainScreen].bounds.size.height;
    _preferedWidth = MIN(w, h);
    return _preferedWidth;
}

- (CGFloat)widgetHeight {
    if (_preferedHeight > 0) {
        return _preferedHeight;
    }
    _preferedHeight = _originalH * _scaleRate;
    return _preferedHeight;
}

#pragma mark - 长宽值变换
- (CGFloat)valueCompat:(CGFloat)value {
    return value * self.scaleRate;
}

#pragma mark - 加载图片
- (UIImage *)loadImage:(NSString *)suffix {
    NSString *imageFile = [NSString stringWithFormat:@"%@/%@.png", [[NSBundle mainBundle] resourcePath], suffix];
    NSData *imageData = [NSData dataWithContentsOfFile:imageFile];
    UIImage *image = [UIImage imageWithData:imageData scale:[[UIScreen mainScreen] scale]];
    return image;
}

- (UIImage *)loadImageFullPath:(NSString *)path {
    NSData *imageData = [NSData dataWithContentsOfFile:path];
    UIImage *image = [UIImage imageWithData:imageData scale:[[UIScreen mainScreen] scale]];
    return image;
}

#pragma mark 进场相对位置
- (CGFloat)enterPositonX {
    CGFloat widgetWidth = [self widgetWidth];
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    return widgetWidth + (w - widgetWidth) / 2.0;
}

- (CGFloat)enterPositonY {
    return 0.0;
}

#pragma mark 进场相对位置
- (CGFloat)quitPositionX {
    return -[self enterPositonX];
}

- (CGFloat)quitPositionY {
    return 0.0;
}

#pragma mark - 动画标识符
- (NSString *)uniqueIdentifier {
    return @"LiveGift";
}

@end
