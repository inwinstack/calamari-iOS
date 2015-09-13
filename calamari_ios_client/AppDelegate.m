//
//  AppDelegate.m
//  inWinStackCeph
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "AppDelegate.h"
#import "LoginController.h"
#import "Cookies.h"
#import "NotificationController.h"
#import "CustomNavigationController.h"
#import "NotificationData.h"
#import "ErrorView.h"

@interface AppDelegate ()

@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) ErrorView *alertView;
@property (nonatomic) BOOL isBackground;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.loginController = [[LoginController alloc] init];
    self.customNavigationController = [[CustomNavigationController alloc] initWithRootViewController:self.loginController];
    self.window.rootViewController = self.customNavigationController;
    [[Cookies shareInstance] clearCookies];
    [self.window makeKeyAndVisible];
    self.isBackground = NO;
    
    self.alertView = [[ErrorView alloc] initWithFrame:self.window.frame title:@"儲存系統警告" message:@"您有新的警告通知！"];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)  categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mute" ofType:@"mp3"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    NSError *error;
    self.audioPlayer = [[AVAudioPlayer alloc] initWithData:fileData fileTypeHint:AVFileTypeMPEGLayer3 error:&error];
    [self.audioPlayer setNumberOfLoops:-1];
    if (self.audioPlayer != nil) {
        if ([self.audioPlayer prepareToPlay]) {
            [self.audioPlayer play];
        }
    }
    return YES;
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    [[NotificationData shareInstance] resetRecord];
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
    self.isBackground = YES;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"] isEqualToString:@"did"]) {
        self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            
        }];
    }
}

- (void) applicationWillTerminate:(UIApplication *)application {
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

- (void) application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    if (self.isBackground) {
        self.isBackground = NO;
        if (!self.notificationController) {
            self.notificationController = [[NotificationController alloc] init];
            [self.customNavigationController pushViewController:self.notificationController animated:YES];
        }
    } else {
        if ([self.window.subviews indexOfObject:self.alertView] > self.window.subviews.count) {
            [self.window addSubview:self.alertView];
        }
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceive:%@", userInfo);
}

@end
