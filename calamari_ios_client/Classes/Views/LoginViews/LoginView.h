//
//  LoginView.h
//  inWinStack
//
//  Created by Francis on 2014/12/27.
//  Copyright (c) 2014年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginView : UIView

@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIImageView *titleView;
@property (nonatomic, strong) UITextField *hostIpField;
@property (nonatomic, strong) UITextField *portField;
@property (nonatomic, strong) UITextField *accountField;
@property (nonatomic, strong) UITextField *passwordField;
@property (nonatomic, strong) UIView *languageView;
@property (nonatomic, strong) UIImageView *languageCountryImageView;
@property (nonatomic, strong) UILabel *languageContentLabel;
@property (nonatomic, strong) UIButton *languageSettingButton;
@property (nonatomic, strong) UILabel *versionLabel;
@property (nonatomic, strong) UILabel *fromLabel;
@property (nonatomic, strong) UILabel *designLabel;
@property (nonatomic, strong) UILabel *titleLabel;

- (void) setDefaultField;
- (void) setRedField:(UITextField*)field;
- (void) setBottomInfo;

@end
