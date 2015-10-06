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

@end

@implementation OSDHeaderView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        float height = (CGRectGetWidth([UIScreen mainScreen].bounds) - CGRectGetWidth([UIScreen mainScreen].bounds) / 16) * 0.85;
        float imageHeight = ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? 50 : 30;
        self.allButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 15, (CGRectGetWidth(self.frame) - 20) / 3, height * 50 / 255)];
        self.allButton.backgroundColor = [UIColor osdButtonDefaultColor];
        self.allButton.layer.borderWidth = 1;
        self.allButton.layer.borderColor = [UIColor normalBolderColor].CGColor;
        [self.allButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"osd_health_all"] forState:UIControlStateNormal];
        [self.allButton.titleLabel setFont:[UIFont systemFontOfSize:height * 14 / 255]];
        [self.allButton setTitleColor:[UIColor normalBlackColor] forState:UIControlStateNormal];
        self.allButton.tag = 0;
        [self.allButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.allButton];
        
        self.warnButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.allButton.frame), 15, (CGRectGetWidth(self.frame) - 20) / 3, height * 50 / 255)];
        self.warnButton.layer.borderWidth = 1;
        self.warnButton.tag = 1;
        self.warnButton.layer.borderColor = [UIColor normalBolderColor].CGColor;
        self.warnButton.backgroundColor = [UIColor osdButtonDefaultColor];
        [self.warnButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.warnButton];
        
        self.warnImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.warnButton.frame) / 2 - imageHeight / 2, CGRectGetHeight(self.warnButton.frame) / 2 - imageHeight / 2, imageHeight, imageHeight)];
        self.warnImageView.image = [UIImage imageNamed:@"OSDWarnImage"];
        [self.warnButton addSubview:self.warnImageView];
        
        self.errorButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.warnButton.frame), 15, (CGRectGetWidth(self.frame) - 20) / 3, height * 50 / 255)];
        self.errorButton.layer.borderWidth = 1;
        self.errorButton.layer.borderColor = [UIColor normalBolderColor].CGColor;
        self.errorButton.backgroundColor = [UIColor osdButtonDefaultColor];
        self.errorButton.tag = 2;
        [self.errorButton addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.errorButton];
        
        self.errorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.errorButton.frame) / 2 - imageHeight / 2, CGRectGetHeight(self.errorButton.frame) / 2 - imageHeight / 2, imageHeight, imageHeight)];
        self.errorImageView.image = [UIImage imageNamed:@"OSDErrorImage"];
        [self.errorButton addSubview:self.errorImageView];
    }
    return self;
}

- (void) didSelectButton:(UIButton*)button {
    self.allButton.backgroundColor = [UIColor osdButtonDefaultColor];
    self.warnButton.backgroundColor = [UIColor osdButtonDefaultColor];
    self.errorButton.backgroundColor = [UIColor osdButtonDefaultColor];
    
    button.backgroundColor = [UIColor osdButtonHighlightColor];
    [self.delegate didReceviButton:button];
}

- (void) setCurrentButton:(NSInteger)buttonTag {
    switch (buttonTag) {
        case 0: {
            self.allButton.backgroundColor = [UIColor osdButtonHighlightColor];
            break;
        } case 1: {
            self.warnButton.backgroundColor = [UIColor osdButtonHighlightColor];
            break;
        } case 2: {
            self.errorButton.backgroundColor = [UIColor osdButtonHighlightColor];
            break;
        }
    }
}

@end
