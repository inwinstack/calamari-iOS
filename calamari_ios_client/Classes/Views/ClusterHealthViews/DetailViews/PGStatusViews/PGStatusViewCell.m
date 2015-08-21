//
//  PGStatusViewCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/27.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "PGStatusViewCell.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"

@interface PGStatusViewCell ()

@property (nonatomic, strong) UILabel *unitLabel;

@end

@implementation PGStatusViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.backgroundColor = [UIColor oceanBackgroundThreeColor];
        self.typeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, CGRectGetWidth(self.frame) - CGRectGetMaxX(self.colorView.frame) - CGRectGetWidth(self.frame) * 0.06, 20)];
        self.typeLabel.textColor = [UIColor normalBlackColor];
        self.typeLabel.font = [UIFont boldSystemFontOfSize:[UIView subHeadSize]];
        [self addSubview:self.typeLabel];
        
        self.pgsLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.typeLabel.frame), CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame) * 0.06, 20)];
        self.pgsLabel.textColor = [UIColor normalBlackColor];
        self.pgsLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        [self addSubview:self.pgsLabel];
        
        self.layer.borderColor = [UIColor osdButtonHighlightColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 10;
        self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.67, CGRectGetHeight(self.frame) / 2, CGRectGetWidth(self.frame) * 0.3, CGRectGetHeight(self.frame) / 2 - 10)];
        self.unitLabel.text = @"OSD";
        self.unitLabel.textColor = [UIColor normalBlackColor];
        self.unitLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.unitLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.unitLabel];
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.unitLabel.frame), 10, CGRectGetWidth(self.unitLabel.frame), CGRectGetHeight(self.frame) / 2 - 10)];
        self.countLabel.textColor = [UIColor normalBlackColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.font = [UIFont boldSystemFontOfSize:[UIView bodySize]];
        [self addSubview:self.countLabel];
        
        self.colorView = [CAShapeLayer layer];
        self.colorView.frame = CGRectMake(0, 0, 10, CGRectGetHeight(self.frame));
        self.colorView.path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame)) cornerRadius:10].CGPath;
        self.colorView.contentsCenter = CGRectMake(0.25, 0.25, 0.25, 0.25);
        self.colorView.masksToBounds = YES;
        [self.layer addSublayer:self.colorView];
        
    }
    return self;
}

@end
