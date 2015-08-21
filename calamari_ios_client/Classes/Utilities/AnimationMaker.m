//
//  AnimationMaker.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/12.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "AnimationMaker.h"

@implementation AnimationMaker

+ (AnimationMaker*) shareInstance {
    static AnimationMaker *animationMaker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        animationMaker = [[AnimationMaker alloc] init];
    });
    return animationMaker;
}

- (void) animationByShapeLayer:(CAShapeLayer*)shapeLayer duration:(float)value {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animation.duration = value;
    animation.fromValue = @0;
    animation.toValue = @1;
    [shapeLayer addAnimation:animation forKey:@"customStroke"];
    shapeLayer.strokeEnd = 1;
}

@end
