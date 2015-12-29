//
//  ErrorView.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/16.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ErrorView.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"
#import "LocalizationManager.h"

@interface ErrorView ()

@property (nonatomic, strong) UIView *cardBackgroundView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic, strong) UIView *errorLineView;
@property (nonatomic, strong) UIView *buttonLineView;

@end

@implementation ErrorView

- (instancetype) initWithFrame:(CGRect)frame title:(NSString*)title message:(NSString*)message {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4];
        
        self.cardBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMidY(self.frame) - 75, CGRectGetWidth(self.frame) - 20, 150)];
        self.cardBackgroundView.layer.borderWidth = 2.0;
        self.cardBackgroundView.layer.borderColor = [UIColor navigationSelectedColor].CGColor;
        self.cardBackgroundView.layer.cornerRadius = 5.0;
        self.cardBackgroundView.backgroundColor = [UIColor oceanBackgroundThreeColor];
        [self addSubview:self.cardBackgroundView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMidY(self.frame) - 75, CGRectGetWidth(self.frame) - 20, 30)];
        self.titleLabel.textColor = [UIColor errorColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.text = title;
        [self addSubview:self.titleLabel];
    
        self.messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame), 90)];
        self.messageLabel.textColor = [UIColor normalBlackColor];
        self.messageLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.messageLabel.text = [NSString stringWithFormat:@"  %@", message];
        [self addSubview:self.messageLabel];
        
        self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.messageLabel.frame), CGRectGetWidth(self.titleLabel.frame), 30)];
        [self.confirmButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_fail_confirm"] forState:UIControlStateNormal];
        [self.confirmButton setTitleColor:[UIColor normalBlackColor] forState:UIControlStateNormal];
        [self.confirmButton addTarget:self action:@selector(didSelect) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.confirmButton];
        self.confirmButton.layer.cornerRadius = 5.0;
        
        self.errorLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame) + 2, CGRectGetMaxY(self.titleLabel.frame), CGRectGetWidth(self.titleLabel.frame) - 4, 1)];
        self.errorLineView.backgroundColor = [UIColor errorColor];
        [self addSubview:self.errorLineView];
        
        self.buttonLineView = [[UIView alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.titleLabel.frame), CGRectGetMaxY(self.messageLabel.frame), CGRectGetWidth(self.titleLabel.frame), 1)];
        self.buttonLineView.backgroundColor = [UIColor oceanHorizonRuleTwoColor];
        [self addSubview:self.buttonLineView];
    }
    return self;
}

- (void) didSelect {
    if (self.delegate) {
        [self.delegate didConfirm];
    } else {
        [self removeFromSuperview];
    }
}

@end
