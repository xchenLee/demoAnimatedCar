//
//  SingleSequelChecker.m
//  demoForAnimation
//
//  Created by danlan on 2017/7/25.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import "SingleSequelChecker.h"
#import "YYImage.h"

@interface SingleSequelChecker ()

@property (nonatomic, strong) YYFrameImage *fireworksImage;
@property (nonatomic, strong) NSMutableArray *fireworkFrame;
@property (nonatomic, strong) NSMutableArray *fireworkDurat;

@end

@implementation SingleSequelChecker

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat cW = 298 * 0.6;
    CGFloat cH = 312 * 0.6;
    
    YYAnimatedImageView *fire = [[YYAnimatedImageView alloc] init];
    fire.frame = CGRectMake(0, 0, cW, cH);
    fire.image = self.fireworksImage;
    fire.autoPlayAnimatedImage = NO;
    [fire startAnimating];
    [self.view addSubview:fire];
    fire.center = self.view.center;
}



// 烟火图片
- (YYFrameImage *)fireworksImage {
    if (_fireworksImage == nil) {
        
        self.fireworkFrame = [NSMutableArray array];
        self.fireworkDurat = [NSMutableArray array];
        for (NSInteger i = 0; i < 21; i ++) {
            
            NSString *bundlePath = [[NSBundle mainBundle] resourcePath];
            NSString *fileName = [NSString stringWithFormat:@"%@/castle/fireworks/fire_%ld.png",bundlePath, (long)i];
            if (i == 1 || i == 2 || i == 6 || i == 8 || i == 9 || i == 12) {
                continue;
            } else {
                [self.fireworkFrame addObject:fileName];
                [self.fireworkDurat addObject:@(0.15)];
            }
            /*[self.fireworkFrame addObject:fileName];
            [self.fireworkDurat addObject:@(0.1)];*/
        }
        
        _fireworksImage = [[YYFrameImage alloc] initWithImagePaths:self.fireworkFrame frameDurations:self.fireworkDurat loopCount:0];
        
    }
    return _fireworksImage;
}


@end

















