//
//  MONHealthCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "MONHealthCell.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"

@interface MONHealthCell ()

@property (nonatomic, strong) UIView *districtLineView;
@property (nonatomic, strong) UIView *tempWhiteView;

@end

@implementation MONHealthCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.tempWhiteView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, CGRectGetWidth(self.frame), 45)];
        self.tempWhiteView.backgroundColor = [UIColor oceanBackgroundOneColor];
        [self addSubview:self.tempWhiteView];
        
        self.backgroundColor = [UIColor clearColor];
        self.colorView = [[UIView alloc] initWithFrame:CGRectMake(0, 5, 10, 45)];
        [self addSubview:self.colorView];
        
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.colorView.frame) * 2, CGRectGetMinY(self.colorView.frame), CGRectGetWidth(self.frame) - CGRectGetMaxX(self.colorView.frame) - CGRectGetWidth(self.frame) * 0.06, 20)];
        self.numberLabel.textColor = [UIColor normalBlackColor];
        self.numberLabel.font = [UIFont boldSystemFontOfSize:[UIView subHeadSize]];
        [self addSubview:self.numberLabel];
        
        self.ipLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.colorView.frame) * 2, CGRectGetMaxY(self.numberLabel.frame), CGRectGetWidth(self.frame) - CGRectGetWidth(self.frame) * 0.06, 20)];
        self.ipLabel.textColor = [UIColor normalBlackColor];
        self.ipLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        [self addSubview:self.ipLabel];
        
        
        self.districtLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 1, CGRectGetWidth(self.frame), 1)];
        self.districtLineView.backgroundColor = [UIColor osdButtonDefaultColor];
        [self addSubview:self.districtLineView];
        
    }
    return self;
}

@end
