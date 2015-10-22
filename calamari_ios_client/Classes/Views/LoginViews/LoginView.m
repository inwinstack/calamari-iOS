//
//  LoginView.m
//  inWinStack
//
//  Created by Francis on 2014/12/27.
//  Copyright (c) 2014年 Francis. All rights reserved.
//

#import "LoginView.h"
#import "UIColor+Reader.h"
#import "UIView+SizeMaker.h"
#import "LocalizationManager.h"

@interface LoginView ()

@property (nonatomic, strong) UIImageView *inWinLabelImageView;
@property (nonatomic, strong) UIImageView *downTriangleImageView;

@end

@implementation LoginView

- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor oceanBackgroundOneColor];
        float titleWidth = ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? 220.0 : 110.0;
        float titleHeight = ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? 176.0 : 88.0;
        float fieldHeight = ([[UIDevice currentDevice].model isEqualToString:@"iPad"]) ? 50.0 : CGRectGetWidth([UIScreen mainScreen].bounds) * 0.13;
        
        self.titleView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - titleWidth / 2.0, [UIView tbMarginFour], titleWidth, titleHeight)];
        self.titleView.image = [UIImage imageNamed:@"inWinStackIcon"];
        [self addSubview:self.titleView];
        
        self.hostIpField = [[UITextField alloc] initWithFrame:CGRectMake([UIView lrMarginOne], CGRectGetMaxY(self.titleView.frame) + [UIView tbMarginThree], CGRectGetWidth(self.frame) - [UIView lrMarginOne] * 2, fieldHeight)];
        self.hostIpField.placeholder = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_host"];
        self.hostIpField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        
        [self setDefaultField:self.hostIpField];
        
        self.portField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.hostIpField.frame), CGRectGetMaxY(self.hostIpField.frame) + [UIView tbMarginOne], CGRectGetWidth(self.hostIpField.frame), fieldHeight)];
        self.portField.placeholder = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_port"];
        self.portField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
        [self setDefaultField:self.portField];
        
        self.accountField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.hostIpField.frame), CGRectGetMaxY(self.portField.frame) + [UIView tbMarginOne], CGRectGetWidth(self.hostIpField.frame), fieldHeight)];
        self.accountField.placeholder = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_name"];
        self.accountField.keyboardType = UIKeyboardTypeASCIICapable;
        [self setDefaultField:self.accountField];
        
        self.passwordField = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.hostIpField.frame), CGRectGetMaxY(self.accountField.frame) + [UIView tbMarginOne], CGRectGetWidth(self.hostIpField.frame), fieldHeight)];
        self.passwordField.placeholder = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_password"];
        self.passwordField.secureTextEntry = YES;
        self.passwordField.keyboardType = UIKeyboardTypeASCIICapable;
        [self setDefaultField:self.passwordField];
        
        self.languageView = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.passwordField.frame), CGRectGetMaxY(self.passwordField.frame) + [UIView tbMarginOne], CGRectGetWidth(self.passwordField.frame), fieldHeight)];
        self.languageView.backgroundColor = [UIColor oceanBackgroundThreeColor];
        self.languageView.layer.cornerRadius = 5;
        [self addSubview:self.languageView];
        
        self.downTriangleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetWidth(self.languageView.frame) - ([UIView bodySize] + 10), (CGRectGetHeight(self.languageView.frame) / 2.0) - ([UIView bodySize] / 2.0), [UIView bodySize], [UIView bodySize])];
        self.downTriangleImageView.image = [UIImage imageNamed:@"DownTriangleImage"];
        [self.languageView addSubview:self.downTriangleImageView];
        
        self.languageCountryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (CGRectGetHeight(self.languageView.frame) / 2.0) - ([UIView bodySize] / 2.0), [UIView bodySize], [UIView bodySize])];
        [self.languageView addSubview:self.languageCountryImageView];
        
        self.languageContentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.languageCountryImageView.frame) + 5, 0, CGRectGetWidth(self.frame) - (CGRectGetMaxX(self.languageCountryImageView.frame) + ([UIView bodySize] + 10)), CGRectGetHeight(self.languageView.frame))];
        self.languageContentLabel.font = [UIFont systemFontOfSize:[UIView bodySize]];
        self.languageContentLabel.textColor = [UIColor languageContentColor];
        [self.languageView addSubview:self.languageContentLabel];
        
        self.languageSettingButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.passwordField.frame), CGRectGetMaxY(self.passwordField.frame) + [UIView tbMarginOne], CGRectGetWidth(self.passwordField.frame), fieldHeight)];
        self.languageSettingButton.backgroundColor = [UIColor clearColor];
        self.languageSettingButton.layer.cornerRadius = 5;
        [self addSubview:self.languageSettingButton];
        
        
        self.loginButton = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.languageView.frame), CGRectGetMaxY(self.languageView.frame) + [UIView tbMarginOne], CGRectGetWidth(self.languageView.frame), fieldHeight)];
        self.loginButton.backgroundColor = [UIColor oceanNavigationBarColor];
        self.loginButton.layer.cornerRadius = 5;
        [self.loginButton.titleLabel setFont:[UIFont boldSystemFontOfSize:16]];
        [self.loginButton setTitle:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_sign_in"] forState:UIControlStateNormal];
        [self.loginButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self addSubview:self.loginButton];
        
        self.versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.frame) - 50, CGRectGetWidth(self.frame), 20)];
        self.versionLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_version"];
        self.versionLabel.textAlignment = NSTextAlignmentCenter;
        [self setDefaultLabel:self.versionLabel];
        
        [self setBottomInfo];
    }
    return self;
}

- (void) setBottomInfo {
    [self.fromLabel removeFromSuperview];
    [self.designLabel removeFromSuperview];
    [self.inWinLabelImageView removeFromSuperview];
    if ([[[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_developer"] isEqualToString:@"Developed by"]) {
        self.inWinLabelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 30, CGRectGetMaxY(self.versionLabel.frame), 144, 20)];
        self.inWinLabelImageView.image = [UIImage imageNamed:@"inWinLabelImage"];
        [self addSubview:self.inWinLabelImageView];
        
        self.fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.inWinLabelImageView.frame) - 18, CGRectGetMidY(self.inWinLabelImageView.frame) - 7.5, 0, 0)];
        self.fromLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_developer"];
        self.fromLabel.textAlignment = NSTextAlignmentRight;
        [self.fromLabel sizeToFit];
        
        float tempFromLabelWidth = CGRectGetWidth(self.fromLabel.frame);
        self.fromLabel.frame = CGRectMake(CGRectGetMinX(self.inWinLabelImageView.frame) - tempFromLabelWidth - 5, self.fromLabel.frame.origin.y, self.fromLabel.frame.size.width, self.fromLabel.frame.size.height);
        [self setDefaultLabel:self.fromLabel];
        
        self.designLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.inWinLabelImageView.frame) + 3, CGRectGetMidY(self.inWinLabelImageView.frame) - 7.5, 0, 0)];
        self.designLabel.text = @"";
        [self.designLabel sizeToFit];
        self.designLabel.textAlignment = NSTextAlignmentLeft;
        [self setDefaultLabel:self.designLabel];
    } else {
        self.inWinLabelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMidX(self.frame) - 100, CGRectGetMaxY(self.versionLabel.frame), 144, 20)];
        self.inWinLabelImageView.image = [UIImage imageNamed:@"inWinLabelImage"];
        [self addSubview:self.inWinLabelImageView];
        
        self.fromLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(self.inWinLabelImageView.frame) - 18, CGRectGetMidY(self.inWinLabelImageView.frame) - 7.5, 0, 0)];
        self.fromLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_from"];
        self.fromLabel.textAlignment = NSTextAlignmentRight;
        [self.fromLabel sizeToFit];
        float tempFromLabelWidth = CGRectGetWidth(self.fromLabel.frame);
        self.fromLabel.frame = CGRectMake(CGRectGetMinX(self.inWinLabelImageView.frame) - tempFromLabelWidth - 5, self.fromLabel.frame.origin.y, self.fromLabel.frame.size.width, self.fromLabel.frame.size.height);
        [self setDefaultLabel:self.fromLabel];
        
        self.designLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.inWinLabelImageView.frame) + 3, CGRectGetMidY(self.inWinLabelImageView.frame) - 7.5, 0, 0)];
        self.designLabel.text = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"login_developer"];
        [self.designLabel sizeToFit];
        self.designLabel.textAlignment = NSTextAlignmentLeft;
        [self setDefaultLabel:self.designLabel];
    }
}

- (void) setDefaultField:(UITextField*)field {
    field.layer.borderWidth = 1;
    field.layer.borderColor = [UIColor oceanBackgroundTwoColor].CGColor;
    field.layer.cornerRadius = 4;
    field.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
    field.leftViewMode = UITextFieldViewModeAlways;
    field.backgroundColor = [UIColor oceanBackgroundThreeColor];
    field.font = [UIFont systemFontOfSize:[UIView bodySize]];
    field.tag = 0;
    field.textColor = [UIColor normalBlackColor];
    [self addSubview:field];
    
}

- (void) setDefaultLabel:(UILabel*)label {
    label.font = [UIFont systemFontOfSize:[UIView noteSize]];
    label.textColor = [UIColor unitTextDefalutGrayColor];
    [self addSubview:label];
}

- (void) setDefaultField {
    [self.passwordField resignFirstResponder];
}

- (void) setRedField:(UITextField*)field {
    self.hostIpField.layer.borderColor = [UIColor oceanBackgroundTwoColor].CGColor;
    self.portField.layer.borderColor = [UIColor oceanBackgroundTwoColor].CGColor;
    self.accountField.layer.borderColor = [UIColor oceanBackgroundTwoColor].CGColor;
    self.passwordField.layer.borderColor = [UIColor oceanBackgroundTwoColor].CGColor;
    if (field) {
        field.layer.borderColor = [UIColor errorColor].CGColor;
    }
}

@end
