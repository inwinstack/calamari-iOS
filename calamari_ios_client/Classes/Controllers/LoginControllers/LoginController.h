//
//  LoginController.h
//  inWinStackCeph
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginView;
@class ClusterHealthController;
@class ErrorView;

@interface LoginController : UIViewController

@property (nonatomic, strong) LoginView *loginView;
@property (nonatomic, strong) ClusterHealthController *clusterHealthController;
@property (nonatomic, strong) ErrorView *errorView;

@end
