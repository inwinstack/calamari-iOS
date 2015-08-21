//
//  UIColor+Reader.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/17.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "UIColor+Reader.h"

@implementation UIColor (Reader)

+ (UIColor*) normalBlueColor {
    return [UIColor colorWithRed:(57.0 / 255.0) green:(192.0 / 255.0) blue:(237.0 / 255.0) alpha:1];
}

+ (UIColor*) defaultGrayColor {
    return [UIColor colorWithRed:(153.0 / 255.0) green:(153.0 / 255.0) blue:(153.0 / 255.0) alpha:1];
}

+ (UIColor*) titleGrayColor {
    return [UIColor colorWithRed:(102.0 / 255.0) green:(102.0 / 255.0) blue:(102.0 / 255.0) alpha:1];
}

+ (UIColor*) okGreenColor {
    return [UIColor colorWithRed:(141.0 / 255.0) green:(196.0 / 255.0) blue:(31.0 / 255.0) alpha:1];
}

+ (UIColor*) okGreenShapelayerColor {
    return [UIColor colorWithRed:(141.0 / 255.0) green:(196.0 / 255.0) blue:(31.0 / 255.0) alpha:0.3];
}

+ (UIColor*) warningColor {
    return [UIColor colorWithRed:(247.0 / 255.0) green:(181.0 / 255.0) blue:0 alpha:1];
}

+ (UIColor*) warningShapelayerColor {
    return [UIColor colorWithRed:(247.0 / 255.0) green:(181.0 / 255.0) blue:0 alpha:0.3];
}

+ (UIColor*) errorColor {
    return [UIColor colorWithRed:(230.0 / 255.0) green:(52.0 / 255.0) blue:(39.0 / 255.0) alpha:1];
}

+ (UIColor*) healthBarColor {
    return [UIColor colorWithRed:(205.0 / 255.0) green:(38.0 / 255.0) blue:(38.0 / 255.0) alpha:1];
}

+ (UIColor*) osdOKColor {
    return [UIColor colorWithRed:(141.0 / 255.0) green:(196.0 / 255.0) blue:(31.0 / 255.0) alpha:1];
}

+ (UIColor*) osdWarnColor {
    return [UIColor colorWithRed:(247.0 / 255.0) green:(181.0 / 255.0) blue:(0.0 / 255.0) alpha:1];
}

+ (UIColor*) osdErrorColor {
    return [UIColor colorWithRed:(230.0 / 255.0) green:(52.0 / 255.0) blue:(39.0 / 255.0) alpha:1];
}

+ (UIColor*) osdButtonHighlightColor {
    return [UIColor colorWithRed:(217.0 / 255.0) green:(217.0 / 255.0) blue:(217.0 / 255.0) alpha:1];
}

+ (UIColor*) osdButtonDefaultColor {
    return [UIColor colorWithRed:(240.0 / 255.0) green:(240.0 / 255.0) blue:(240.0 / 255.0) alpha:1];
}

+ (UIColor*) normalBlackColor {
    return [UIColor colorWithRed:(6.0 / 255.0) green:(6.0 / 255.0) blue:(6.0 / 255.0) alpha:1];
}

+ (UIColor*) normalBolderColor {
    return [UIColor colorWithRed:(199.0 / 255.0) green:(199.0 / 255.0) blue:(199.0 / 255.0) alpha:1];
}

+ (UIColor*) osdDetailButtonBackgroundColor {
    return [UIColor colorWithRed:(57.0 / 255.0) green:(192.0 / 255.0) blue:(237.0 / 255.0) alpha:1];
}

+ (UIColor*) unitTextDefalutGrayColor {
    return [UIColor colorWithRed:(9.0 / 255.0) green:(9.0 / 255.0) blue:(9.0 / 255.0) alpha:1];
}

+ (UIColor*) HostHealthCardBackgroundColor {
    return [UIColor colorWithRed:(249.0 / 255.0) green:(249.0 / 255.0) blue:(249.0 / 255.0) alpha:1];
}

+ (UIColor*) AreaGraphBackgroundColor {
    return [UIColor colorWithRed:(229.0 / 255.0) green:(229.0 / 255.0) blue:(229.0 / 255.0) alpha:1];
}

+ (UIColor*) TagLineColor {
    return [UIColor colorWithRed:(184.0 / 255.0) green:(184.0 / 255.0) blue:(184.0 / 255.0) alpha:1];
}

+ (UIColor*) UserLinePurpleColor {
    return [UIColor colorWithRed:(193.0 / 255.0) green:(180.0 / 255.0) blue:(217.0 / 255.0) alpha:1];
}

+ (UIColor*) IdleLineBlueColor {
    return [UIColor colorWithRed:(68.0 / 255.0) green:(115.0 / 255.0) blue:(185.0 / 255.0) alpha:1];
}

+ (UIColor*) IOWaitLinePinkColor {
    return [UIColor colorWithRed:(233.0 / 255.0) green:(14.0 / 255.0) blue:(134.0 / 255.0) alpha:1];
}

+ (UIColor*) IRQLineBrownColor {
    return [UIColor colorWithRed:(188.0 / 255.0) green:(92.0 / 255.0) blue:(0 / 255.0) alpha:1];
}

+ (UIColor*) SoftIRQLineGrayColor {
    return [UIColor colorWithRed:(102.0 / 255.0) green:(102.0 / 255.0) blue:(102.0 / 255.0) alpha:1];
}

+ (UIColor*) UserLinePurpleFillColor {
    return [UIColor colorWithRed:(193.0 / 255.0) green:(180.0 / 255.0) blue:(217.0 / 255.0) alpha:0.3];
}

+ (UIColor*) IdleLineBlueFillColor {
    return [UIColor colorWithRed:(68.0 / 255.0) green:(115.0 / 255.0) blue:(185.0 / 255.0) alpha:0.5];
}

+ (UIColor*) IOWaitLinePinkFillColor {
    return [UIColor colorWithRed:(233.0 / 255.0) green:(14.0 / 255.0) blue:(134.0 / 255.0) alpha:0.3];
}

+ (UIColor*) IRQLineBrownFillColor {
    return [UIColor colorWithRed:(188.0 / 255.0) green:(92.0 / 255.0) blue:(0 / 255.0) alpha:0.3];
}

+ (UIColor*) SoftIRQLineGrayFillColor {
    return [UIColor colorWithRed:(102.0 / 255.0) green:(102.0 / 255.0) blue:(102.0 / 255.0) alpha:0.3];
}

+ (UIColor*) oceanNavigationBarColor {
    return [UIColor colorWithRed:(41.0 / 255.0) green:(128.0 / 255.0) blue:(185.0 / 255.0) alpha:1];
}

+ (UIColor*) oceanHealthBarColor {
    return [UIColor colorWithRed:(38.0 / 255.0) green:(118.0 / 255.0) blue:(171.0 / 255.0) alpha:1];
}

+ (UIColor*) oceanBackgroundOneColor {
    return [UIColor colorWithRed:(249.0 / 255.0) green:(249.0 / 255.0) blue:(249.0 / 255.0) alpha:1];
}

+ (UIColor*) oceanBackgroundTwoColor {
    return [UIColor colorWithRed:(243.0 / 255.0) green:(243.0 / 255.0) blue:(243.0 / 255.0) alpha:1];
}

+ (UIColor*) oceanBackgroundThreeColor {
    return [UIColor colorWithRed:(255.0 / 255.0) green:(255.0 / 255.0) blue:(255.0 / 255.0) alpha:1];
}

+ (UIColor*) oceanHorizonRuleOneColor {
    return [UIColor colorWithRed:(239.0 / 255.0) green:(239.0 / 255.0) blue:(239.0 / 255.0) alpha:1];
}

+ (UIColor*) oceanHorizonRuleTwoColor {
    return [UIColor colorWithRed:(217.0 / 255.0) green:(217.0 / 255.0) blue:(217.0 / 255.0) alpha:1];
}

+ (UIColor*) navigationSelectedColor {
    return [UIColor colorWithRed:(213.0 / 255.0) green:(213.0 / 255.0) blue:(213.0 / 255.0) alpha:1];
}


@end
