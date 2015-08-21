//
//  HostHealthViewCell.m
//  inWinStackCeph
//
//  Created by Francis on 2015/6/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "HostHealthViewCell.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"

@interface HostHealthViewCell ()

@property (nonatomic, strong) UILabel *unitLabel;

@end

@implementation HostHealthViewCell

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        self.backgroundColor = [UIColor oceanBackgroundThreeColor];
        self.layer.borderColor = [UIColor osdButtonHighlightColor].CGColor;
        self.layer.borderWidth = 1;
        self.layer.cornerRadius = 10;
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.67, 14, CGRectGetWidth(self.frame) * 0.3, 16)];
        self.countLabel.textColor = [UIColor normalBlackColor];
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        self.countLabel.font = [UIFont boldSystemFontOfSize:[UIView bodySize]];
        [self addSubview:self.countLabel];
        
        self.unitLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.67, CGRectGetMaxY(self.countLabel.frame), CGRectGetWidth(self.frame) * 0.3, 16)];
        self.unitLabel.text = @"OSD";
        self.unitLabel.textColor = [UIColor normalBlackColor];
        self.unitLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.unitLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.unitLabel];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds) * 0.03, 0, CGRectGetWidth([UIScreen mainScreen].bounds) * 0.61, CGRectGetHeight(self.frame))];
        self.nameLabel.font = [UIFont boldSystemFontOfSize:[UIView subHeadSize]];
        self.nameLabel.textColor = [UIColor normalBlackColor];
        self.nameLabel.numberOfLines = 0;
        [self addSubview:self.nameLabel];
    }
    return self;
}

@end
