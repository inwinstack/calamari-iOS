//
//  OSDHealthViewCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/19.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "OSDHealthViewCell.h"

@implementation OSDHealthViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.layer.cornerRadius = 10;
        self.numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(height * 5 / 255, height * 5 / 255, CGRectGetWidth(self.frame) - height * 10 / 255, CGRectGetHeight(self.frame) - height * 10 / 255)];
        self.numberLabel.font = [UIFont systemFontOfSize:height * 14 / 255];
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.textColor = [UIColor whiteColor];
        [self addSubview:self.numberLabel];
    }
    return self;
}

@end
