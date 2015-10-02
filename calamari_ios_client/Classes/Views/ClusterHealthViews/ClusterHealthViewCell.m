//
//  ClusterHealthViewCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/13.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ClusterHealthViewCell.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"

@implementation ClusterHealthViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float height;
        self.layer.cornerRadius = 10;
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            height = ((CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85) / 2;
        } else {
            height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        }
        self.backgroundColor = [UIColor oceanBackgroundThreeColor];
        self.layer.borderWidth = 2.0;
        
        self.iconImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, height * [UIView subHeadIconSize] / 255, height * [UIView subHeadIconSize] / 255)];
        [self addSubview:self.iconImage];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImage.frame) + 5, CGRectGetMidY(self.iconImage.frame) - height * 10 / 255, height * 200 / 255, height * 20 / 255)];
        self.titleLabel.font = [UIFont boldSystemFontOfSize:height * [UIView subHeadSize] / 255];
        self.titleLabel.textColor = [UIColor titleGrayColor];
        [self addSubview:self.titleLabel];
        
        self.vectorImage = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) - height * ([UIView subHeadIconSize] + CGRectGetMinX(self.iconImage.frame)) / 255, CGRectGetMidY(self.iconImage.frame) - height * ([UIView subHeadIconSize] / 2) / 255, height * [UIView subHeadIconSize] / 255, height * [UIView subHeadIconSize] / 255)];
        self.vectorImage.image = [UIImage imageNamed:@"VectorImage"];
        [self addSubview:self.vectorImage];
        
        self.lineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.iconImage.frame), CGRectGetMaxY(self.iconImage.frame) + height * 15 / 255, CGRectGetWidth(frame) - (CGRectGetMinX(self.iconImage.frame) * 2), 1)];
        self.lineView.backgroundColor = [UIColor grayColor];
        [self addSubview:self.lineView];
        
        self.bottomBar = [[ClusterHealthCellBar alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - height * 80 / 255, CGRectGetWidth(self.frame), height * 80 / 255)];
        [self addSubview:self.bottomBar];
        
        self.iopsChartView = [[IOPSChartView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.lineView.frame), CGRectGetWidth(self.frame), CGRectGetHeight(self.frame) - CGRectGetMaxY(self.lineView.frame))];
        [self addSubview:self.iopsChartView];
        
        float statusY = (CGRectGetMinY(self.bottomBar.frame) - CGRectGetMaxY(self.lineView.frame) - height * 40 / 255) / 2;
        self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, statusY, CGRectGetWidth(frame), height * 20 / 255)];
        self.statusLabel.font = [UIFont boldSystemFontOfSize:height * [UIView headerLineSize] / 255];
        self.statusLabel.textAlignment = NSTextAlignmentCenter;
        self.statusLabel.textColor = [UIColor okGreenColor];
        [self addSubview:self.statusLabel];
        
        self.detailLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(self.statusLabel.frame), CGRectGetWidth(frame), height * 20 / 255)];
        self.detailLabel.font = [UIFont systemFontOfSize:height * [UIView bodySize] / 255];
        self.detailLabel.textAlignment = NSTextAlignmentCenter;
        self.detailLabel.textColor = [UIColor defaultGrayColor];
        [self addSubview:self.detailLabel];
        
    }
    return self;
}

- (void) addProgress {
    [self.progress removeFromSuperview];
    self.progress = [[ClusterHealthProgressLayer alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.lineView.frame) / 8 + 3, 82.5 * self.frame.size.height / 340, CGRectGetWidth(self.frame) / 2, CGRectGetWidth(self.frame) / 2)];
    [self addSubview:self.progress];
}

- (void) removeProgress {
    [self.progress removeFromSuperview];
}

@end
