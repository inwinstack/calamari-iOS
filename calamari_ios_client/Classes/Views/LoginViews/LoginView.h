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

- (void) setDefaultField;
- (void) setRedField:(UITextField*)field;

@end
