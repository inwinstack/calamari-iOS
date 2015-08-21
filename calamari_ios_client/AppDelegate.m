//
//  AppDelegate.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "AppDelegate.h"
#import "LoginController.h"
#import "Cookies.h"
#import "CephAPI.h"
#import "ClusterData.h"
#import "NotificationController.h"
#import "NotificationData.h"
#import "DateMaker.h"
#import "CustomNavigationController.h"

@interface AppDelegate () {
    BOOL firstTime;
    BOOL haveError;
    int lastWarn;
    int lastError;
    int tempWarn;
    int tempError;
    int badgeCount;
    NSTimer *tenTimer;
}

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.loginController = [[LoginController alloc] init];
    self.customNavigationController = [[CustomNavigationController alloc] initWithRootViewController:self.loginController];
    self.window.rootViewController = self.customNavigationController;
    [[Cookies shareInstance] clearCookies];
    [self.window makeKeyAndVisible];
    badgeCount = 0;
    haveError = false;
    firstTime = false;
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)  categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    firstTime = false;
    haveError = false;
    badgeCount = 0;
    [tenTimer invalidate];
    tenTimer = nil;
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"] isEqualToString:@"did"]) {
        tenTimer = [NSTimer scheduledTimerWithTimeInterval:30 target:self selector:@selector(startCheck) userInfo:nil repeats:YES];
        UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init];
        if (notifyAlarm) {
            badgeCount++;
            notifyAlarm.fireDate = [NSDate dateWithTimeIntervalSinceNow:600];
            notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
            notifyAlarm.repeatInterval = 0;
            notifyAlarm.soundName = UILocalNotificationDefaultSoundName;
            notifyAlarm.alertBody = @"本系統即將停止刷新";
            notifyAlarm.applicationIconBadgeNumber = badgeCount;
            [[UIApplication sharedApplication] scheduleLocalNotification:notifyAlarm];
        }
        self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            
        }];
    }
}

- (void) applicationWillTerminate:(UIApplication *)application {
    NSLog(@"did");
    [[Cookies shareInstance] clearCookies];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[NSUserDefaults standardUserDefaults] setObject:@"didLogout" forKey:@"firstTime"];
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    NSLog(@"receive deviceToken: %@", deviceToken);
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Remote notification error:%@", [error localizedDescription]);
}

- (void) startCheck {
    [[CephAPI shareInstance] startGetClusterDetailAtBackgroundCompletion:^(BOOL finished) {
        if (finished) {
            tempError = 0;
            tempWarn = 0;
            double quotas = [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_space", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"space"][@"used_bytes"] doubleValue] / [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_space", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"space"][@"capacity_bytes"] doubleValue];
            for (id object in [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"report"][@"summary"]) {
                if ([object[@"severity"] isEqualToString:@"HEALTH_WARN"]) {
                    tempWarn++;
                } else {
                    tempError++;
                }
            }
            if (!firstTime) {
                if ([[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"report"][@"summary"] count] > 0) {
                    [self startNotification:HealthNotificationType];
                }
                if (quotas >= 0.7) {
                    [self startNotification:SpaceNotificationType];
                }
                if (([[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"osd"][@"critical"][@"count"] integerValue] > 0) || ([[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"osd"][@"warn"][@"count"] integerValue] > 0)) {
                    [self startNotification:OSDNotificationType];
                }
                if (([[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"mon"][@"critical"][@"count"] integerValue] > 0) || ([[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"mon"][@"warn"][@"count"] integerValue] > 0)) {
                    [self startNotification:MONNotificationType];
                }
                if (([[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"pg"][@"critical"][@"count"] integerValue] > 0) || ([[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"pg"][@"warn"][@"count"] integerValue] > 0)) {
                    [self startNotification:PGNotificationType];
                }
                lastError = tempError;
                lastWarn = tempWarn;
                firstTime = true;
            } else if (tempWarn > lastWarn || tempError > lastError) {
                [self startNotification:HealthNotificationType];
                lastError = tempError;
                lastWarn = tempWarn;
            }
        }
    } error:^(id error) {
        UILocalNotification* notifyErrorAlarm = [[UILocalNotification alloc] init];
        if (notifyErrorAlarm) {
            notifyErrorAlarm.fireDate = [NSDate dateWithTimeIntervalSinceNow:0];
            notifyErrorAlarm.timeZone = [NSTimeZone defaultTimeZone];
            notifyErrorAlarm.repeatInterval = 0;
            notifyErrorAlarm.soundName = UILocalNotificationDefaultSoundName;
            notifyErrorAlarm.alertBody = @"刷新錯誤";
            [[UIApplication sharedApplication] scheduleLocalNotification:notifyErrorAlarm];
        }
        NSLog(@"%@", error);
    }];
}

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (!self.notificationController) {
        self.notificationController = [[NotificationController alloc] init];
        [self.customNavigationController pushViewController:self.notificationController animated:YES];
    }
}

- (void) startNotification:(NotificationType)type {
    badgeCount++;
    haveError = true;
    [tenTimer invalidate];
    tenTimer = nil;
    tenTimer = [NSTimer scheduledTimerWithTimeInterval:120 target:self selector:@selector(startCheck) userInfo:nil repeats:YES];
    double quotas = [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_space", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"space"][@"used_bytes"] doubleValue]/ [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_space", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"space"][@"capacity_bytes"] doubleValue];
    UILocalNotification* notifyWarn = [[UILocalNotification alloc] init];
    if (notifyWarn) {
        notifyWarn.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        notifyWarn.timeZone = [NSTimeZone defaultTimeZone];
        notifyWarn.repeatInterval = 0;
        notifyWarn.soundName = UILocalNotificationDefaultSoundName;
        notifyWarn.applicationIconBadgeNumber = badgeCount;
        switch (type) {
            case HealthNotificationType:
                for (id object in [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"report"][@"summary"]) {
                    if ([object[@"severity"] isEqualToString:@"HEALTH_WARN"]) {
                        notifyWarn.alertBody = [NSString stringWithFormat:@"警告！%@", object[@"summary"]];
                    } else {
                        notifyWarn.alertBody = [NSString stringWithFormat:@"錯誤！%@", object[@"summary"]];
                    }
                    [[UIApplication sharedApplication] scheduleLocalNotification:notifyWarn];
                }
                break;
            case SpaceNotificationType:
                if (quotas >= 0.85) {
                    notifyWarn.alertBody = @"錯誤！使用量滿載";
                } else {
                    notifyWarn.alertBody = @"警告！使用量即將滿載";
                }
                [[UIApplication sharedApplication] scheduleLocalNotification:notifyWarn];
                break;
            case MONNotificationType:
                if ([[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"mon"][@"critical"][@"count"] integerValue] > 0) {
                    notifyWarn.alertBody = @"錯誤！Monitor 損毀";
                    [[NotificationData shareInstance].notificationArray addObject:@[@"Error", [NSString stringWithFormat:@"%@ 個 Monitor 損毀！", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"mon"][@"critical"][@"count"]], [NSString stringWithFormat:@"%@", [[DateMaker shareDateMaker] getTodayWithNotificationFormat]]]];
                } else {
                    notifyWarn.alertBody = @"警告！Monitor 異常";
                    [[NotificationData shareInstance].notificationArray addObject:@[@"Warn", [NSString stringWithFormat:@"%@ 個 Monitor 異常！", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"mon"][@"warn"][@"count"]], [NSString stringWithFormat:@"%@", [[DateMaker shareDateMaker] getTodayWithNotificationFormat]]]];
                }
                [[UIApplication sharedApplication] scheduleLocalNotification:notifyWarn];
                break;
            case OSDNotificationType:
                if ([[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"osd"][@"critical"][@"count"] integerValue] > 0) {
                    notifyWarn.alertBody = @"錯誤！OSD 損毀";
                    [[NotificationData shareInstance].notificationArray addObject:@[@"Error", [NSString stringWithFormat:@"%@ 個 OSD 損毀！", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"osd"][@"critical"][@"count"]], [NSString stringWithFormat:@"%@", [[DateMaker shareDateMaker] getTodayWithNotificationFormat]]]];
                } else {
                    [[NotificationData shareInstance].notificationArray addObject:@[@"Warn", [NSString stringWithFormat:@"%@ 個 OSD 異常！", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"osd"][@"warn"][@"count"]], [NSString stringWithFormat:@"%@", [[DateMaker shareDateMaker] getTodayWithNotificationFormat]]]];
                    notifyWarn.alertBody = @"警告！OSD 異常";
                }
                [[UIApplication sharedApplication] scheduleLocalNotification:notifyWarn];
                break;
            case PGNotificationType:
                if ([[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"pg"][@"critical"][@"count"] integerValue] > 0) {
                    [[NotificationData shareInstance].notificationArray addObject:@[@"Error", [NSString stringWithFormat:@"%@ 個 PG 損毀！", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"pg"][@"critical"][@"count"]], [NSString stringWithFormat:@"%@", [[DateMaker shareDateMaker] getTodayWithNotificationFormat]]]];

                    notifyWarn.alertBody = @"錯誤！PG 損毀";
                } else {
                    [[NotificationData shareInstance].notificationArray addObject:@[@"Warn", [NSString stringWithFormat:@"%@ 個 PG 異常！", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"pg"][@"warn"][@"count"]], [NSString stringWithFormat:@"%@", [[DateMaker shareDateMaker] getTodayWithNotificationFormat]]]];
                    notifyWarn.alertBody = @"警告！PG 異常";
                }
                [[UIApplication sharedApplication] scheduleLocalNotification:notifyWarn];
                break;
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceive:%@", userInfo);
}

@end
