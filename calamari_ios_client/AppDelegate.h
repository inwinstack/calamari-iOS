//
//  AppDelegate.h
//  calamari_ios_client
//
//  Created by Francis on 2015/9/13.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LoginController;
@class NotificationController;
@class CustomNavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginController *loginController;
@property (strong, nonatomic) NotificationController *notificationController;
@property (strong, nonatomic) CustomNavigationController *customNavigationController;

@end

