//
//  AppDelegate.h
//  inWinStackCeph
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NotificationType) {
    HealthNotificationType = 0,
    SpaceNotificationType,
    OSDNotificationType,
    MONNotificationType,
    PGNotificationType,
};

@class LoginController;
@class NotificationController;
@class CustomNavigationController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginController *loginController;
@property (strong, nonatomic) NotificationController *notificationController;
@property (strong, nonatomic) CustomNavigationController *customNavigationController;

@end

