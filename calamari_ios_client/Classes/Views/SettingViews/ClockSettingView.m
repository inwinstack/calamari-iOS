//
//  ClockSettingView.m
//  calamari_ios_client
//
//  Created by Francis on 2015/10/13.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "ClockSettingView.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"

@interface ClockSettingView ()

@property (nonatomic, strong) UIView *blackBackgroundView;
@property (nonatomic, strong) UIView *districtTopView;
@property (nonatomic, strong) UIView *bottomDistrictView;
@property (nonatomic, strong) UIView *buttonDistrictView;
@property (nonatomic, strong) UILabel *symbolhmLabel;
@property (nonatomic, strong) UILabel *symbolmsLabel;
@property (nonatomic, strong) CAShapeLayer *titleBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *allViewLayer;
@property (nonatomic, strong) CAShapeLayer *clockTrackBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *clockFillBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *clockOutSideRoundLayer;
@property (nonatomic, strong) CAShapeLayer *clockDistrictRoundLayer;
@property (nonatomic, strong) CAShapeLayer *clockLineLayer;
@property (nonatomic, strong) UIView *clockBackgroundView;


@end

@implementation ClockSettingView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.blackBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.blackBackgroundView.backgroundColor = [UIColor blackColor];
        self.blackBackgroundView.alpha = 0.5;
        [self addSubview:self.blackBackgroundView];
        
        self.clockBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 145, CGRectGetMidY(self.frame) - 225, 290, 450)];
        self.clockBackgroundView.layer.cornerRadius = 5.0;
        [self addSubview:self.clockBackgroundView];
        
        self.titleBackgroundLayer = [CAShapeLayer layer];
        
        self.titleBackgroundLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(self.clockBackgroundView.frame), CGRectGetHeight(self.clockBackgroundView.frame)) cornerRadius:9].CGPath;
        
        self.allViewLayer = [CAShapeLayer layer];
        self.allViewLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.clockBackgroundView.frame), 450);
        self.allViewLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.clockBackgroundView.frame), 450)].CGPath;
        
        self.allViewLayer.fillColor = [UIColor oceanBackgroundThreeColor].CGColor;
        self.allViewLayer.mask = self.titleBackgroundLayer;
        self.allViewLayer.masksToBounds = YES;
        [self.clockBackgroundView.layer addSublayer:self.allViewLayer];
        
        self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, 400, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, 50)];
        [self.saveButton setTitleColor:[UIColor oceanNavigationBarColor] forState:UIControlStateNormal];
        [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
        self.saveButton.backgroundColor = [UIColor oceanBackgroundThreeColor];
        self.saveButton.layer.cornerRadius = 5.0;
        [self.clockBackgroundView addSubview:self.saveButton];
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, 50)];
        self.cancelButton.layer.cornerRadius = 5.0;
        [self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
        self.cancelButton.backgroundColor = [UIColor oceanBackgroundThreeColor];
        [self.cancelButton setTitleColor:[UIColor normalBlackColor] forState:UIControlStateNormal];
        [self.clockBackgroundView addSubview:self.cancelButton];
        
        self.districtTopView = [[UIView alloc] initWithFrame:CGRectMake(0, 49, CGRectGetWidth(self.clockBackgroundView.frame), 2)];
        self.districtTopView.backgroundColor = [UIColor osdButtonDefaultColor];
        [self.clockBackgroundView addSubview:self.districtTopView];
        
        self.clockTrackBackgroundLayer = [CAShapeLayer layer];
        self.clockTrackBackgroundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0) radius:90 startAngle:0 endAngle:M_PI * 2 clockwise:0].CGPath;
        self.clockTrackBackgroundLayer.lineWidth = 25;
        self.clockTrackBackgroundLayer.fillColor = [UIColor clearColor].CGColor;
        self.clockTrackBackgroundLayer.strokeColor = [UIColor TagLineColor].CGColor;
        [self.clockBackgroundView.layer addSublayer:self.clockTrackBackgroundLayer];
        
        self.clockFillBackgroundLayer = [CAShapeLayer layer];
        self.clockFillBackgroundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0) radius:75 startAngle:0 endAngle:M_PI * 2 clockwise:0].CGPath;
        self.clockFillBackgroundLayer.strokeColor = [UIColor clearColor].CGColor;
        self.clockFillBackgroundLayer.fillColor = [UIColor osdButtonHighlightColor].CGColor;
        [self.clockBackgroundView.layer addSublayer:self.clockFillBackgroundLayer];
        
        self.clockOutSideRoundLayer = [CAShapeLayer layer];
        self.clockOutSideRoundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0) radius:107 startAngle:0 endAngle:M_PI * 2 clockwise:0].CGPath;
        self.clockOutSideRoundLayer.strokeColor = [UIColor osdButtonDefaultColor].CGColor;
        self.clockOutSideRoundLayer.fillColor = [UIColor clearColor].CGColor;
        self.clockOutSideRoundLayer.lineWidth = 10.0;
        [self.clockBackgroundView.layer addSublayer:self.clockOutSideRoundLayer];
        
        CGMutablePathRef clockLinePath = CGPathCreateMutable();
        CGPathMoveToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, 113);
        CGPathAddLineToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, 124);
        
        CGPathMoveToPoint(clockLinePath, nil, 247, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0);
        CGPathAddLineToPoint(clockLinePath, nil, 258, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0);
        
        CGPathMoveToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, 327);
        CGPathAddLineToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, 338);
        
        CGPathMoveToPoint(clockLinePath, nil, 33, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0);
        CGPathAddLineToPoint(clockLinePath, nil, 44, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0);
        
        CGPathMoveToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 51, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0 + 88);
        CGPathAddLineToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 57, 322);
        
        CGPathMoveToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 88, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0 + 51);
        CGPathAddLineToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 97, 282);
        
        CGPathMoveToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 51, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0 + 88);
        CGPathAddLineToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 57, 322);
        
        CGPathMoveToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 88, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0 + 51);
        CGPathAddLineToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 97, 282);
        
        CGPathMoveToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 51, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0 - 88);
        CGPathAddLineToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 57, 128);
        
        CGPathMoveToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 88, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0 - 51);
        CGPathAddLineToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 97, 168);
        
        CGPathMoveToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 51, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0 - 88);
        CGPathAddLineToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 57, 128);
        
        CGPathMoveToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 88, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0 - 51);
        CGPathAddLineToPoint(clockLinePath, nil, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 97, 168);
        
        self.clockLineLayer = [CAShapeLayer layer];
        self.clockLineLayer.strokeColor = [UIColor TagLineColor].CGColor;
        self.clockLineLayer.fillColor = [UIColor clearColor].CGColor;
        self.clockLineLayer.lineWidth = 2.0;
        self.clockLineLayer.path = clockLinePath;
        [self.clockBackgroundView.layer addSublayer:self.clockLineLayer];
        CGPathRelease(clockLinePath);
        
        self.clockDistrictRoundLayer = [CAShapeLayer layer];
        self.clockDistrictRoundLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0) radius:102 startAngle:0 endAngle:M_PI * 2 clockwise:0].CGPath;
        self.clockDistrictRoundLayer.strokeColor = [UIColor titleGrayColor].CGColor;
        self.clockDistrictRoundLayer.fillColor = [UIColor clearColor].CGColor;
        self.clockDistrictRoundLayer.opacity = 0.5;
        self.clockDistrictRoundLayer.lineWidth = 1.5;
        [self.clockBackgroundView.layer addSublayer:self.clockDistrictRoundLayer];
        
        self.hourLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 60, CGRectGetHeight(self.clockBackgroundView.frame) / 2.0 - 10, 30, 20)];
        self.hourLabel.textAlignment = NSTextAlignmentCenter;
        self.hourLabel.text = @"00";
        [self.clockBackgroundView addSubview:self.hourLabel];
        
        self.symbolhmLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.hourLabel.frame), CGRectGetMinY(self.hourLabel.frame), 15, 20)];
        self.symbolhmLabel.textAlignment = NSTextAlignmentCenter;
        self.symbolhmLabel.text = @":";
        [self.clockBackgroundView addSubview:self.symbolhmLabel];
        
        self.minuteLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.symbolhmLabel.frame), CGRectGetMinY(self.symbolhmLabel.frame), 30, 20)];
        self.minuteLabel.textAlignment = NSTextAlignmentCenter;
        self.minuteLabel.text = @"00";
        self.minuteLabel.textColor = [UIColor oceanNavigationBarColor];
        [self.clockBackgroundView addSubview:self.minuteLabel];
        
        self.symbolmsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.minuteLabel.frame), CGRectGetMinY(self.minuteLabel.frame), 15, 20)];
        self.symbolmsLabel.textAlignment = NSTextAlignmentCenter;
        self.symbolmsLabel.text = @":";
        [self.clockBackgroundView addSubview:self.symbolmsLabel];
        
        self.secondLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.symbolmsLabel.frame), CGRectGetMinY(self.symbolmsLabel.frame), 30, 20)];
        self.secondLabel.textAlignment = NSTextAlignmentCenter;
        self.secondLabel.text = @"30";
        [self.clockBackgroundView addSubview:self.secondLabel];
        
        self.zeroButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 20, 93, 40, 20)];
        self.zeroButton.tag = 0;
        [self.zeroButton setTitle:@"00" forState:UIControlStateNormal];
        self.zeroButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.zeroButton setTitleColor:[UIColor TagLineColor] forState:UIControlStateNormal];
        [self.clockBackgroundView addSubview:self.zeroButton];
        
        self.tenButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 90, 150, 40, 20)];
        self.tenButton.tag = 1;

        [self.tenButton setTitle:@"10" forState:UIControlStateNormal];
        self.tenButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.tenButton setTitleColor:[UIColor TagLineColor] forState:UIControlStateNormal];
        [self.clockBackgroundView addSubview:self.tenButton];
        
        self.twentyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 90, 275, 40, 20)];
        self.twentyButton.tag = 2;

        [self.twentyButton setTitle:@"20" forState:UIControlStateNormal];
        self.twentyButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.twentyButton setTitleColor:[UIColor TagLineColor] forState:UIControlStateNormal];
        [self.clockBackgroundView addSubview:self.twentyButton];
        
        self.thirtyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 20, 340, 40, 20)];
        self.thirtyButton.tag = 3;

        [self.thirtyButton setTitle:@"30" forState:UIControlStateNormal];
        self.thirtyButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.thirtyButton setTitleColor:[UIColor TagLineColor] forState:UIControlStateNormal];
        [self.clockBackgroundView addSubview:self.thirtyButton];
        
        self.fortyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 130, 275, 40, 20)];
        self.fortyButton.tag = 4;

        [self.fortyButton setTitle:@"40" forState:UIControlStateNormal];
        self.fortyButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.fortyButton setTitleColor:[UIColor TagLineColor] forState:UIControlStateNormal];
        [self.clockBackgroundView addSubview:self.fortyButton];
        
        self.fiftyButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 130, 150, 40, 20)];
        self.fiftyButton.tag = 5;

        [self.fiftyButton setTitle:@"50" forState:UIControlStateNormal];
        self.fiftyButton.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self.fiftyButton setTitleColor:[UIColor TagLineColor] forState:UIControlStateNormal];
        [self.clockBackgroundView addSubview:self.fiftyButton];
        
        self.bottomDistrictView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.saveButton.frame) - 1, CGRectGetWidth(self.clockBackgroundView.frame), 2)];
        self.bottomDistrictView.backgroundColor = [UIColor osdButtonDefaultColor];
        [self.clockBackgroundView addSubview:self.bottomDistrictView];
        
        self.buttonDistrictView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.cancelButton.frame) - 1, CGRectGetMinY(self.saveButton.frame), 2, CGRectGetHeight(self.saveButton.frame))];
        self.buttonDistrictView.backgroundColor = [UIColor osdButtonDefaultColor];
        [self.clockBackgroundView addSubview:self.buttonDistrictView];
        
        self.circleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 11.5, 124, 23, 23)];
        self.circleView.backgroundColor = [UIColor osdButtonHighlightColor];
        self.circleView.layer.borderWidth = 2.0;
        self.circleView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.circleView.layer.cornerRadius = 11.5;
        [self.clockBackgroundView addSubview:self.circleView];
        
        self.selectedCircleView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.minuteLabel.frame) - 15, CGRectGetMidY(self.minuteLabel.frame) - 15, 30, 30)];
        self.selectedCircleView.layer.cornerRadius = 15;
        self.selectedCircleView.backgroundColor = [UIColor grayColor];
        self.selectedCircleView.layer.borderWidth = 2.0;
        self.selectedCircleView.layer.borderColor = [UIColor blackColor].CGColor;
        self.selectedCircleView.alpha = 0.3;
        [self.clockBackgroundView addSubview:self.selectedCircleView];
        
        CGMutablePathRef trianglePath = CGPathCreateMutable();
        CGPathMoveToPoint(trianglePath, nil, CGRectGetMidX(self.minuteLabel.frame), CGRectGetMaxY(self.minuteLabel.frame) + 8);
        CGPathAddLineToPoint(trianglePath, nil, CGRectGetMaxX(self.minuteLabel.frame) - 10, CGRectGetMaxY(self.minuteLabel.frame) + 13);
        CGPathAddLineToPoint(trianglePath, nil, CGRectGetMinX(self.minuteLabel.frame) + 10, CGRectGetMaxY(self.minuteLabel.frame) + 13);
        CGPathCloseSubpath(trianglePath);
        self.selectedTriangleLayer = [CAShapeLayer layer];
        self.selectedTriangleLayer.fillColor = [UIColor oceanNavigationBarColor].CGColor;
        self.selectedTriangleLayer.strokeColor = [UIColor clearColor].CGColor;
        self.selectedTriangleLayer.path = trianglePath;
        [self.clockBackgroundView.layer addSublayer:self.selectedTriangleLayer];
        CGPathRelease(trianglePath);
        
        self.hourButton = [[UIButton alloc] initWithFrame:self.hourLabel.frame];
        [self.clockBackgroundView addSubview:self.hourButton];
        
        self.minuteButton = [[UIButton alloc] initWithFrame:self.minuteLabel.frame];
        [self.clockBackgroundView addSubview:self.minuteButton];
        
        self.secondButton = [[UIButton alloc] initWithFrame:self.secondLabel.frame];
        [self.clockBackgroundView addSubview:self.secondButton];
        
        self.clockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, CGRectGetWidth(self.clockBackgroundView.frame), 30)];
        self.clockNameLabel.text = @"沒有彩蛋";
        self.clockNameLabel.textAlignment = NSTextAlignmentCenter;
        self.clockNameLabel.font = [UIFont boldSystemFontOfSize:[UIView subHeadSize]];
        [self.clockBackgroundView addSubview:self.clockNameLabel];
    }
    return self;
}

@end
