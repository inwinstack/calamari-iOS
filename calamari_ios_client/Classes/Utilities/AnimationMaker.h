//
//  AnimationMaker.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/12.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimationMaker : UIView

+ (AnimationMaker*) shareInstance;

- (void) animationByShapeLayer:(CAShapeLayer*)shapeLayer duration:(float)value;

@end
