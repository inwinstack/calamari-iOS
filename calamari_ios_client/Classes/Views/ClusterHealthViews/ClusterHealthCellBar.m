//
//  ClusterHealthCellBar.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/15.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ClusterHealthCellBar.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"

@interface ClusterHealthCellBar ()

@property (nonatomic, strong) UIView *topLineView;
@property (nonatomic, strong) UIView *districtView;

@end

@implementation ClusterHealthCellBar

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor oceanBackgroundTwoColor];
        float height;
        if ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
            height = ((CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85) / 2;
        } else {
            height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        }
        self.topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), 1)];
        self.topLineView.backgroundColor = [UIColor osdButtonHighlightColor];
        [self addSubview:self.topLineView];
        
        self.warningLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) / 4) - 45, CGRectGetHeight(self.frame) / 8, 90, 18)];
        self.warningLabel.textAlignment = NSTextAlignmentCenter;
        self.warningLabel.font = [UIFont boldSystemFontOfSize:[UIView bodySize]];
        [self addSubview:self.warningLabel];
        
        self.warningTextLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) / 4) - 60, CGRectGetMaxY(self.warningLabel.frame), 120, 16)];
        self.warningTextLabel.text = @"Warnings";
        self.warningTextLabel.font = [UIFont systemFontOfSize:[UIView noteSize]];
        self.warningTextLabel.textAlignment = NSTextAlignmentCenter;
        self.warningTextLabel.textColor = [UIColor defaultGrayColor];
        [self addSubview:self.warningTextLabel];
        
        self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) * 3 / 4) - 40 , CGRectGetHeight(self.frame) / 8, 80,  18)];
        self.errorLabel.textAlignment = NSTextAlignmentCenter;
        self.errorLabel.font = [UIFont boldSystemFontOfSize:[UIView bodySize]];
        [self addSubview:self.errorLabel];
        
        self.errorTextLabel = [[UILabel alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.frame) * 3 / 4) - 60, CGRectGetMaxY(self.errorLabel.frame), 120, 16)];
        self.errorTextLabel.text = @"Errors";
        self.errorTextLabel.font = [UIFont systemFontOfSize:[UIView noteSize]];
        self.errorTextLabel.textColor = [UIColor defaultGrayColor];
        self.errorTextLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.errorTextLabel];
        
        self.districtView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.frame) / 2 - 0.5, 10, 1, 40)];
        self.districtView.backgroundColor = [UIColor colorWithRed:(204.0 / 255.0) green:(204.0 / 255.0) blue:(204.0 / 255.0) alpha:1];
        [self addSubview:self.districtView];
    }
    return self;
}

- (void) setWarningValue:(NSString*)value {
    self.warningLabel.textColor = ([value isEqualToString:@"0"]) ? [UIColor defaultGrayColor] : [UIColor warningColor];
    self.warningLabel.text = value;
}

- (void) setErrorValue:(NSString*)value {
    self.errorLabel.textColor = ([value isEqualToString:@"0"]) ? [UIColor defaultGrayColor] : [UIColor errorColor];
    self.errorLabel.text = value;
}

@end
