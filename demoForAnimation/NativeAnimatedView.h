//
//  NativeAnimatedView.h
//  demoForAnimation
//
//  Created by dreamer on 2017/6/16.
//  Copyright © 2017年 lxc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol NativeAnimatedView <NSObject>

- (NSString *)uniqueIdentifier;

@optional

- (void)loadSources;
- (void)construct;
- (void)play;
- (void)stop;

@end
