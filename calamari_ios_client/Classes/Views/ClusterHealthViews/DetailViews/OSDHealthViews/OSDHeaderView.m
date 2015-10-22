//
//  OSDHeaderView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/19.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "OSDHeaderView.h"
#import "UIColor+Reader.h"
#import "LocalizationManager.h"

@interface OSDHeaderView ()

@property (nonatomic, strong) UIImageView *warnImageView;
@property (nonatomic, strong) UIImageView *errorImageView;
@property (nonatomic, strong) UIView *currentUnderLineView;
@property (nonatomic, strong) UIView *districtOneLineView;
@property (nonatomic, strong) UIView *districtTwoLineView;

@end

@implementation OSDHeaderView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        float imageHeight = ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? 21.0 : 9.0;
        self.layer.borderWidth = 1.0;
        self.layer.borderColor = [UIColor oceanHorizonRuleTwoColor].CGColor;
        
        self.backgroundColor = [UIColor oceanBackgroundTwoColor];
        self.allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame) / 3.0, CGRectGetHeight(self.frame))];
        [self.allButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_health_all"] forState:UIControlStateNormal];
        [self.allButton.titleLabel setFont:[UIFont systemFontOfSize:height * 14 / 255]];
        [self.allButton setTitleColor:[UIColor normalBlackColor] forState:UIControlStateNormal];
        self.allButton.tag = 0;
        [self.allButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.allButton];
        
        self.warnButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.allButton.frame), 0, CGRectGetWidth(self.frame) / 3.0, CGRectGetHeight(self.frame))];
        self.warnButton.tag = 1;
        [self.warnButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.warnButton];
        
        self.warnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.warnButton.frame) / 2 - imageHeight / 2, CGRectGetHeight(self.warnButton.frame) / 2 - imageHeight / 2, imageHeight, imageHeight)];
        self.warnImageView.image = [UIImage imageNamed:@"OSDWarnImage"];
        [self.warnButton addSubview:self.warnImageView];
        
        self.errorButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.warnButton.frame), 0, CGRectGetWidth(self.frame) / 3.0, CGRectGetHeight(self.frame))];
        self.errorButton.tag = 2;
        [self.errorButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.errorButton];
        
        self.errorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.errorButton.frame) / 2 - imageHeight / 2, CGRectGetHeight(self.errorButton.frame) / 2 - imageHeight / 2, imageHeight, imageHeight)];
        self.errorImageView.image = [UIImage imageNamed:@"OSDErrorImage"];
        [self.errorButton addSubview:self.errorImageView];
        
        self.districtOneLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.allButton.frame) - 0.5, CGRectGetHeight(self.warnButton.frame) / 2 - imageHeight / 2, 1, imageHeight)];
        self.districtOneLineView.backgroundColor = [UIColor oceanHorizonRuleTwoColor];
        [self addSubview:self.districtOneLineView];
        
        self.districtTwoLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.warnButton.frame) - 0.5, CGRectGetHeight(self.warnButton.frame) / 2 - imageHeight / 2, 1, imageHeight)];
        self.districtTwoLineView.backgroundColor = [UIColor oceanHorizonRuleTwoColor];
        [self addSubview:self.districtTwoLineView];
        
        self.currentUnderLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.frame) - 3, CGRectGetWidth(self.frame) / 3.0, 3)];
        self.currentUnderLineView.backgroundColor = [UIColor oceanNavigationBarColor];
        [self addSubview:self.currentUnderLineView];
    }
    return self;
}

- (void) didSelectButton:(UIButton*)button {
    [self setCurrentButton:button.tag];
    [self.delegate didReceviButton:button];
}

- (void) setCurrentButton:(NSInteger)buttonTag {
    switch (buttonTag) {
        case 0: {
            [self.allButton setTitleColor:[UIColor oceanNavigationBarColor] forState:UIControlStateNormal];
            self.warnImageView.image = [UIImage imageNamed:@"OSDWarnImage"];
            self.errorImageView.image = [UIImage imageNamed:@"OSDErrorImage"];
            self.currentUnderLineView.frame = CGRectMake(0, CGRectGetHeight(self.frame) - 7, CGRectGetWidth(self.frame) / 3.0, 7);
            break;
        } case 1: {
            [self.allButton setTitleColor:[UIColor unitTextDefalutGrayColor] forState:UIControlStateNormal];
            self.warnImageView.image = [UIImage imageNamed:@"OSDWarnHighlightImage"];
            self.errorImageView.image = [UIImage imageNamed:@"OSDErrorImage"];
            self.currentUnderLineView.frame = CGRectMake(CGRectGetWidth(self.frame) / 3.0, CGRectGetHeight(self.frame) - 7, CGRectGetWidth(self.frame) / 3.0, 7);

            break;
        } case 2: {
            [self.allButton setTitleColor:[UIColor unitTextDefalutGrayColor] forState:UIControlStateNormal];
            self.warnImageView.image = [UIImage imageNamed:@"OSDWarnImage"];
            self.errorImageView.image = [UIImage imageNamed:@"OSDErrorHighlightImage"];
            self.currentUnderLineView.frame = CGRectMake(CGRectGetWidth(self.frame) * 2 / 3.0, CGRectGetHeight(self.frame) - 7, CGRectGetWidth(self.frame) / 3.0, 7);

            break;
        }
    }
}

@end
