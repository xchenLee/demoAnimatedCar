//
//  LiveNativeGift.h
//  demoForAnimation
//
//  Created by danlan on 2017/6/19.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LiveNativeGift : UIView

@property (nonatomic, assign, readonly) CGFloat scaleRate;
@property (nonatomic, assign, readonly) CGFloat widgetWidth;
@property (nonatomic, assign, readonly) CGFloat widgetHeight;


/**
 * 根据动画最大帧的图片宽高，来初始化控件， 其余小的图片帧按这个算出的比率为基准
 * 
 * 默认以竖屏的宽度对动画帧进行转化
 *
 */
- (instancetype)initWithOriginWidth:(CGFloat)originalWidth
                       originHeight:(CGFloat)originalHeight;


/**
 * 根据动画最大帧的图片宽高，来初始化控件， 其余小的图片帧按这个算出的比率为基准
 *
 * @param preferedWidth 希望最大帧的宽度，即，动画的最大宽度 <= 竖屏宽度，会矫正
 *
 */
- (instancetype)initWithOriginWidth:(CGFloat)originalWidth
                       originHeight:(CGFloat)originalHeight
                      preferedWidth:(CGFloat)preferedWidth;

/**
 * 在init方法中调用的方法，用于自己加载一些资源
 */
- (void)preload;
/**
 * 后续调用的一些初始化方法
 */
- (void)construct;


/**
 * 开始结束动画
 */
- (void)play;
- (void)stop;
- (void)reset;


/**
 * 工具方法, 根据比率算出新的数值
 */
- (CGFloat)valueCompat:(CGFloat)value;


/**
 * 工具方法，会自动拼上 BundlePath 目录
 */
- (UIImage *)loadImage:(NSString *)suffix;

- (UIImage *)loadImageFullPath:(NSString *)path;


/**
 * 工具方法，如果动画是从屏幕左右侧进出，
 *         返回计算好的相对于控件本身frame的进场位置，可参考Ferrari实现
 */
- (CGFloat)enterPositonX;
- (CGFloat)enterPositonY;

/**
 * 工具方法，如果动画是从屏幕左右侧进出，
 *         返回计算好的相对于控件本身frame的出场位置，可参考Ferrari实现
 */
- (CGFloat)quitPositionX;
- (CGFloat)quitPositionY;


/**
 * 标识符
 */
- (NSString *)uniqueIdentifier;

- (CGFloat)vScreenWidth;

@end
