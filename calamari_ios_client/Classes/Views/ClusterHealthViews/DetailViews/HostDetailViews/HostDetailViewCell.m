//
//  HostDetailViewCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HostDetailViewCell.h"
#import "UIColor+Reader.h"
#import "CPUSquareView.h"
#import "CPULineBrokenView.h"
#import "CPUIOPSView.h"
#import "UIView+SizeMaker.h"

@interface HostDetailViewCell()

@property (nonatomic, strong) UIView *districtView;
@property (nonatomic, strong) CPUSquareView *cpuSquareView;
@property (nonatomic, strong) CPULineBrokenView *cpuLineBrokenView;
@property (nonatomic, strong) CPUIOPSView *cpuIOPSView;

@end

@implementation HostDetailViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 10 / 255, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05, height * 250 / 255, 25)];
        self.titleLabel.textColor = [UIColor normalBlackColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIView subHeadSize]];
        [self addSubview:self.titleLabel];
        
        self.districtView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1)];
        self.districtView.backgroundColor = [UIColor osdButtonDefaultColor];
        [self addSubview:self.districtView];
    }
    return self;
}

- (void) setCurrentType:(CPUChartType)currentType maxValue:(NSString*)maxValue midValue:(NSString*)midValue dataArray:(NSMutableArray*)dataArray calcalate:(BOOL)calculate {
    [self.cpuSquareView removeFromSuperview];
    [self.cpuIOPSView removeFromSuperview];
    [self.cpuLineBrokenView removeFromSuperview];
    
    switch (currentType) {
        case CPUSquareType: {
            self.cpuSquareView = [[CPUSquareView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.titleLabel.frame))];
            self.cpuSquareView.maxLabel.text = maxValue;
            self.cpuSquareView.midYLabel.text = midValue;
            self.cpuSquareView.tempMidString = midValue;
            [self addSubview:self.cpuSquareView];
            [self.cpuSquareView setDataWithDataArray:dataArray];
            break;
        } case CPUBrokenLineType: {
            self.cpuLineBrokenView = [[CPULineBrokenView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.titleLabel.frame)) isFilled:NO];
            self.cpuLineBrokenView.maxLabel.text = maxValue;
            self.cpuLineBrokenView.midYLabel.text = midValue;
            self.cpuLineBrokenView.tempMidString = midValue;
            [self addSubview:self.cpuLineBrokenView];
            [self.cpuLineBrokenView setDataWithDataArray:dataArray];
            break;
        } case CPUBrokenLineFillType: {
            self.cpuLineBrokenView = [[CPULineBrokenView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.titleLabel.frame)) isFilled:YES];
            self.cpuLineBrokenView.maxLabel.text = (calculate) ? [self caculateByte:[maxValue doubleValue]] : maxValue;
            self.cpuLineBrokenView.midYLabel.text = (calculate) ? [self caculateByte:[midValue doubleValue]] : midValue;
            self.cpuLineBrokenView.tempMidString = midValue;
            [self addSubview:self.cpuLineBrokenView];
            [self.cpuLineBrokenView setDataWithDataArray:dataArray];
            break;
        } case CPUBrokenLineIOPSType: {
            self.cpuIOPSView = [[CPUIOPSView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.titleLabel.frame))];
            self.cpuIOPSView.maxLabel.text = maxValue;
            self.cpuIOPSView.midYLabel.text = midValue;
            self.cpuIOPSView.tempMidString = midValue;
            [self addSubview:self.cpuIOPSView];
            [self.cpuIOPSView setDataWithDataArray:dataArray];
            break;
        }
            
    }
}

- (NSString*) caculateByte:(double)value {
    int count = 0;
    while (value > 1024.0) {
        value = value / 1024.0;
        count++;
        if (count == 4) {
            break;
        }
    }
    NSString *unit;
    switch (count) {
        case 0: {
            return @"1K";
            break;
        } case 1: {
            unit = @"K";
            break;
        } case 2: {
            unit = @"M";
            break;
        } case 3: {
            unit = @"G";
            break;
        } case 4: {
            unit = @"T";
            break;
        }
            
    }
    if (value >= 100) {
        return [NSString stringWithFormat:@"%d%@", (int)value, unit];
    } else if (value >= 10) {
        return [NSString stringWithFormat:@"%.1f%@", value, unit];
    } else {
        return [NSString stringWithFormat:@"%.2f%@", value, unit];
    }
}

@end
