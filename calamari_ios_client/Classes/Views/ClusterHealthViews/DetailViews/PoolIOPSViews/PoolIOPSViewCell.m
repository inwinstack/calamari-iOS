//
//  PoolIOPSViewCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/30.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PoolIOPSViewCell.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"
#import "LocalizationManager.h"

@interface PoolIOPSViewCell()

@property (nonatomic, strong) UILabel *readLabel;
@property (nonatomic, strong) UILabel *writeLabel;
@property (nonatomic, strong) UIView *districtView;

@end

@implementation PoolIOPSViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.backgroundColor = [UIColor clearColor];
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 10 / 255, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.05, 250, 25)];
        self.titleLabel.textColor = [UIColor normalBlackColor];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:[UIView subHeadSize]];
        [self addSubview:self.titleLabel];
        
        self.readLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame) + CGRectGetWidth([UIScreen mainScreen].bounds) * 0.03, 50, 25)];
        self.readLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"pool_iops_read"];
        self.readLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.readLabel.textColor = [UIColor okGreenColor];
        [self addSubview:self.readLabel];
        
        self.writeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.readLabel.frame) + height * 10 / 255, CGRectGetMinY(self.readLabel.frame), 50, 25)];
        self.writeLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"pool_iops_write"];
        self.writeLabel.textColor = [UIColor warningColor];
        self.writeLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        [self addSubview:self.writeLabel];
    
        self.chartView = [[IOPSDetailChartView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.writeLabel.frame) + 10 * height / 255, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.writeLabel.frame))];
        [self addSubview:self.chartView];
        self.districtView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.chartView.frame) + CGRectGetWidth([UIScreen mainScreen].bounds) * 0.0375, CGRectGetWidth(self.frame), 1)];
        self.districtView.backgroundColor = [UIColor osdButtonDefaultColor];
        [self addSubview:self.districtView];
    }
    return self;
}

@end
