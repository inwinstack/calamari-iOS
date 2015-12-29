//
//  AppDelegate.m
//  calamari_ios_client
//
//  Created by Francis on 2015/9/13.
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
#import "ClusterHealthController.h"
#import "SettingData.h"

@interface AppDelegate () <ErrorDelegate>

@property (nonatomic, strong) ClusterHealthController *clusterHealthController;
@property (nonatomic) UIBackgroundTaskIdentifier backgroundTask;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;
@property (nonatomic, strong) ErrorView *alertView;
@property (nonatomic) BOOL isBackground;

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[Cookies shareInstance] clearCookies];
    self.loginController = [[LoginController alloc] init];
    self.customNavigationController = [[CustomNavigationController alloc] initWithRootViewController:self.loginController];
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"] isEqualToString:@"did"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isFirstController"];
        [[NotificationData shareInstance] resetRecord];
        self.clusterHealthController = [[ClusterHealthController alloc] init];
        [self.customNavigationController pushViewController:self.clusterHealthController animated:NO];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"isFirstController"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"English" forKey:@"CurrentLanguage"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentDateFormat"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"2015/12/31" forKey:@"CurrentDateFormat"];
    }
    if (![[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguageImage"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"USAImage" forKey:@"CurrentLanguageImage"];
    }
    
    self.window.rootViewController = self.customNavigationController;
    [self.window makeKeyAndVisible];

    self.isBackground = NO;
    
    self.alertView = [[ErrorView alloc] initWithFrame:self.window.frame title:@"儲存系統警告" message:@"您有新的警告通知！"];
    self.alertView.delegate = self;
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge)  categories:nil]];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    [self playMuteSound];
    
    
    return YES;
}

- (void) applicationWillEnterForeground:(UIApplication *)application {
    [NotificationData shareInstance].isBackground = NO;
    self.isBackground = NO;
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"] isEqualToString:@"did"]) {
        [[NotificationData shareInstance] startDashBoardTimer];
        [[NotificationData shareInstance] restartTimerWithTimeInterval:[[SettingData caculateTimePeriodTotalWithValue:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_normalTimePeriod", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]]] integerValue]];
    }
}

- (void) applicationDidEnterBackground:(UIApplication *)application {
    self.isBackground = YES;
    [NotificationData shareInstance].isBackground = YES;
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"] isEqualToString:@"did"]) {
        [[NotificationData shareInstance] restartTimerWithTimeInterval:[[SettingData caculateTimePeriodTotalWithValue:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_normalTimePeriod", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]]] integerValue]];
    }
    self.backgroundTask = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
        
    }];
}

- (void) applicationWillTerminate:(UIApplication *)application {
    [[Cookies shareInstance] clearCookies];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    [[NSUserDefaults standardUserDefaults] setObject:@"didlogout" forKey:@"refresh"];
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
        self.notificationController = [[NotificationController alloc] init];
        [self.customNavigationController pushViewController:self.notificationController animated:YES];
    } else {
        if ([self.window.subviews indexOfObject:self.alertView] > self.window.subviews.count) {
            if (![notification.alertTitle isEqualToString:[[LocalizationManager sharedLocalizationManager] getTextByKey:@"NotificationTitleInfo"]]) {
                [self.window addSubview:self.alertView];
            }
        }
    }
}

- (void) didConfirm {
    [self.alertView removeFromSuperview];
    for (id object in self.window.subviews) {
        if ([self.window.subviews indexOfObject:object] > 0) {
            [object removeFromSuperview];
        }
    }
    self.notificationController = [[NotificationController alloc] init];
    [self.customNavigationController pushViewController:self.notificationController animated:YES];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"didReceive:%@", userInfo);
}

- (void) playMuteSound {
    AVAudioSession *session = [AVAudioSession sharedInstance];
    if ([session setCategory:AVAudioSessionCategoryPlayback error:nil]) {
        NSLog(@"Background Music Ok");
    } else {
        NSLog(@"Background error");
    }
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
}


@end
