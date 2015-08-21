//
//  UIView+SizeMaker.m
//  inWinStackCeph
//
//  Created by Francis on 2015/7/10.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "UIView+SizeMaker.h"

@implementation UIView (SizeMaker)

+ (float) displayOneSize {
    return 34.0;
}

+ (float) titleSize {
    return 20.0;
}

+ (float) headerLineSize {
    return 24.0;
}

+ (float) subHeadSize {
    return 16.0;
}

+ (float) subHeadIconSize {
    return 14.08;
}

+ (float) bodySize {
    return 14.0;
}

+ (float) iconBodySize {
    return CGRectGetWidth([UIScreen mainScreen].bounds) * 0.03;
}

+ (float) noteSize {
    return 12.0;
}

+ (float) defaultButtonSize {
    return 14.0;
}

+ (float) largeButtonSize {
    return 16.0;
}

+ (float) titleIconSize {
    return 19.2;
}

+ (float) lrMarginOne {
    return CGRectGetWidth([UIScreen mainScreen].bounds) * 0.03;
}

+ (float) lrMarginTwo {
    return CGRectGetWidth([UIScreen mainScreen].bounds) * 0.06;
}

+ (float) lrMarginThree {
    return CGRectGetWidth([UIScreen mainScreen].bounds) * 0.09;
}

+ (float) lrMarginFour {
    return CGRectGetWidth([UIScreen mainScreen].bounds) * 0.12;
}

+ (float) tbMarginOne {
    return CGRectGetWidth([UIScreen mainScreen].bounds) * 0.03;
}

+ (float) tbMarginTwo {
    return CGRectGetWidth([UIScreen mainScreen].bounds) * 0.06;
}

+ (float) tbMarginThree {
    return CGRectGetWidth([UIScreen mainScreen].bounds) * 0.09;
}

+ (float) tbMarginFour {
    return CGRectGetWidth([UIScreen mainScreen].bounds) * 0.12;
}

+ (float) navigationSize {
    return ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? 250.0 : CGRectGetWidth([UIScreen mainScreen].bounds) * 0.8;
}

@end
