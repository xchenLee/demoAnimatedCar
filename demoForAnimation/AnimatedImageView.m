//
//  AnimatedImageView.m
//  demoForAnimation
//
//  Created by danlan on 2017/7/26.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import "AnimatedImageView.h"

@implementation AnimatedImageView

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addObserver:self forKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addObserver:self forKeyPath:@"currentAnimatedImageIndex" options:NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"currentAnimatedImageIndex"] && object == self) {
        
        AnimatedImageView *imageView = (AnimatedImageView *)object;
        BOOL finish = imageView.currentAnimatedImageIndex == 20;
        if (finish) {
            [self removeFromSuperview];
            [self removeObserver:self forKeyPath:@"currentAnimatedImageIndex"];
        }
    }
}

@end






































