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
@property (nonatomic, strong) UIView *clockBackgroundView;
@property (nonatomic, strong) UIView *districtTopView;
@property (nonatomic, strong) UIView *bottomDistrictView;
@property (nonatomic, strong) UIView *buttonDistrictView;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;
@property (nonatomic, strong) UILabel *symbolhmLabel;
@property (nonatomic, strong) UILabel *symbolmsLabel;
@property (nonatomic, strong) UILabel *zeroLabel;
@property (nonatomic, strong) UILabel *tenLabel;
@property (nonatomic, strong) UILabel *twentyLabel;
@property (nonatomic, strong) UILabel *thirtyLabel;
@property (nonatomic, strong) UILabel *fortyLabel;
@property (nonatomic, strong) UILabel *fiftyLabel;
@property (nonatomic, strong) CAShapeLayer *titleBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *allViewLayer;
@property (nonatomic, strong) CAShapeLayer *clockTrackBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *clockFillBackgroundLayer;
@property (nonatomic, strong) CAShapeLayer *clockOutSideRoundLayer;
@property (nonatomic, strong) CAShapeLayer *clockDistrictRoundLayer;
@property (nonatomic, strong) CAShapeLayer *clockLineLayer;

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
        [self addSubview:self.clockBackgroundView];
        
        self.clockNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.clockBackgroundView.frame), 30)];
        self.clockNameLabel.textAlignment = NSTextAlignmentCenter;
        self.clockNameLabel.font = [UIFont boldSystemFontOfSize:[UIView subHeadSize]];
        [self addSubview:self.clockNameLabel];
        
        self.titleBackgroundLayer = [CAShapeLayer layer];
        
        self.titleBackgroundLayer.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(self.clockBackgroundView.frame), CGRectGetHeight(self.clockBackgroundView.frame)) cornerRadius:9].CGPath;
        
        self.allViewLayer = [CAShapeLayer layer];
        self.allViewLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.clockBackgroundView.frame), 450);
        self.allViewLayer.path = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.clockBackgroundView.frame), 400)].CGPath;
        
        self.allViewLayer.fillColor = [UIColor oceanBackgroundThreeColor].CGColor;
        self.allViewLayer.mask = self.titleBackgroundLayer;
        self.allViewLayer.masksToBounds = YES;
        [self.clockBackgroundView.layer addSublayer:self.allViewLayer];
        
        self.saveButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, 400, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, 50)];
        [self.saveButton setTitleColor:[UIColor oceanNavigationBarColor] forState:UIControlStateNormal];
        [self.saveButton setTitle:@"SAVE" forState:UIControlStateNormal];
        self.saveButton.backgroundColor = [UIColor oceanBackgroundThreeColor];
        [self.clockBackgroundView addSubview:self.saveButton];
        
        self.cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 400, CGRectGetWidth(self.clockBackgroundView.frame) / 2.0, 50)];
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
        self.clockDistrictRoundLayer.lineWidth = 2.0;
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
        self.secondLabel.text = @"00";
        [self.clockBackgroundView addSubview:self.secondLabel];
        
        self.zeroLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 20, 93, 40, 20)];
        self.zeroLabel.textAlignment = NSTextAlignmentCenter;
        self.zeroLabel.text = @"00";
        self.zeroLabel.font = [UIFont boldSystemFontOfSize:14];
        self.zeroLabel.textColor = [UIColor TagLineColor];
        [self.clockBackgroundView addSubview:self.zeroLabel];
        
        self.tenLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 100, 150, 40, 20)];
        self.tenLabel.text = @"10";
        self.tenLabel.font = [UIFont boldSystemFontOfSize:14];
        self.tenLabel.textColor = [UIColor TagLineColor];
        [self.clockBackgroundView addSubview:self.tenLabel];
        
        self.twentyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 + 100, 275, 40, 20)];
        self.twentyLabel.text = @"20";
        self.twentyLabel.font = [UIFont boldSystemFontOfSize:14];
        self.twentyLabel.textColor = [UIColor TagLineColor];
        [self.clockBackgroundView addSubview:self.twentyLabel];
        
        self.thirtyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 20, 340, 40, 20)];
        self.thirtyLabel.textAlignment = NSTextAlignmentCenter;
        self.thirtyLabel.text = @"30";
        self.thirtyLabel.font = [UIFont boldSystemFontOfSize:14];
        self.thirtyLabel.textColor = [UIColor TagLineColor];
        [self.clockBackgroundView addSubview:self.thirtyLabel];
        
        self.fortyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 140, 275, 40, 20)];
        self.fortyLabel.textAlignment = NSTextAlignmentRight;
        self.fortyLabel.text = @"40";
        self.fortyLabel.font = [UIFont boldSystemFontOfSize:14];
        self.fortyLabel.textColor = [UIColor TagLineColor];
        [self.clockBackgroundView addSubview:self.fortyLabel];
        
        self.fiftyLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.clockBackgroundView.frame) / 2.0 - 140, 150, 40, 20)];
        self.fiftyLabel.textAlignment = NSTextAlignmentRight;
        self.fiftyLabel.text = @"50";
        self.fiftyLabel.font = [UIFont boldSystemFontOfSize:14];
        self.fiftyLabel.textColor = [UIColor TagLineColor];
        [self.clockBackgroundView addSubview:self.fiftyLabel];
        
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
        
    }
    return self;
}

@end
