//
//  QuotasProgress.m
//  inWinStackMonitor
//
//  Created by Francis on 2015/4/24.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ClusterHealthProgressLayer.h"
#import "AnimationMaker.h"
#import "UIColor+Reader.h"

@interface ClusterHealthProgressLayer ()

@property (nonatomic, strong) CAShapeLayer *backgroundLayer;

@end

@implementation ClusterHealthProgressLayer

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.backgroundLayer = [CAShapeLayer layer];
        self.backgroundLayer.frame = self.frame;
        self.backgroundLayer.fillColor = [UIColor clearColor].CGColor;
        self.backgroundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.backgroundLayer.frame) / 2, 0) radius:(self.backgroundLayer.frame.size.width - 5) / 2 startAngle:0 endAngle:M_PI * 2 clockwise:YES].CGPath;
        self.backgroundLayer.lineWidth = 15;
        self.backgroundLayer.strokeColor = [UIColor okGreenColor].CGColor;
        [self.layer addSublayer:self.backgroundLayer];
        
        self.progressLayer = [CAShapeLayer layer];
        self.progressLayer.frame = self.frame;
        [self.layer addSublayer:self.progressLayer];
    }
    return self;
}

- (void) setProgressValue:(int)value {
    [self.progressLayer removeFromSuperlayer];
    self.progressLayer.lineWidth = 15;
    self.progressLayer.fillColor = [UIColor clearColor].CGColor;
    self.progressLayer.strokeColor = (value >= 85) ? [UIColor errorColor].CGColor : [UIColor warningColor].CGColor;
    self.progressLayer.strokeStart = 0;
    self.progressLayer.strokeEnd = 0;
    self.progressLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.backgroundLayer.frame) / 2, 0) radius:(self.backgroundLayer.frame.size.width - 5) / 2 startAngle:M_PI * 3 / 2 endAngle:M_PI * 2 * ((float)value / 100.0) + M_PI * 3 / 2 clockwise:YES].CGPath;
    [self.layer addSublayer:self.progressLayer];
    [[AnimationMaker shareInstance] animationByShapeLayer:self.progressLayer duration:1.0f];
}

@end
