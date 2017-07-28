//
//  AnimatedImageView.h
//  demoForAnimation
//
//  Created by danlan on 2017/7/26.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import <YYImage/YYImage.h>

@interface AnimatedImageView : YYAnimatedImageView

@property (nonatomic, copy) void(^progressBlock)(NSInteger index, BOOL finish);

@end
