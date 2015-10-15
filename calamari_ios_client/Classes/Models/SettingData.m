//
//  SettingData.m
//  calamari_ios_client
//
//  Created by Francis on 2015/9/22.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "SettingData.h"

@implementation SettingData

+ (SettingData*) shareSettingData {
    static SettingData *settingData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        settingData = [[SettingData alloc] init];
    });
    return settingData;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.settingNameArray = @[@"settings_profile", @"settings_alert", @"settings_about"];
        self.settingMainNameArray = @[@"settings_profile_language", @"settings_profile_formats"];
        self.dateFormatOptionArray = @[@"2015/12/31", @"12/31/2015", @"31/12/2015"];
        self.languageOptionArray = @[@"English", @"繁體中文", @"日本語"];
        self.languageImageOptionArray = @[@"USAImage", @"TaiwanImage", @"JapaneseImage"];
        self.settingDetailArray = [NSMutableArray arrayWithArray:@[@"English", @"2015/12/31"]];
        self.alertTitleArray = @[@"Notifications", @"Email Notifications", @"Auto Delete", @"Time Period", @"Alert Triggers"];
        self.alertBodyArray = @[@"Trigger alarts when storage system comes new warnings", @"Notification will be sent to nutc.imac@gmail.com", @"Delete alerts automatically when alerts were resolved", @"Set a time frame to monitor and receive alerts", @"Setup different alert mechanisms based on various scenarios"];
        self.checkBoxArray = @[@"Notifications", @"Email Notifications", @"Auto Delete", @"", @""];
        [self setTriggerArray];
    }
    return self;
}

- (void) setTriggerArray {
    NSString *currentIp = [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"];
    NSString *osdWarn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_OSDTriggerWarn", currentIp]];
    NSString *osdError = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_OSDTriggerError", currentIp]];
    NSString *monWarn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_MONTriggerWarn", currentIp]];
    NSString *monError = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_MONTriggerError", currentIp]];
    NSString *pgWarn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_PGTriggerWarn", currentIp]];
    NSString *pgError = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_PGTriggerError", currentIp]];
    NSString *usageWarn = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_UsageTriggerWarn", currentIp]];
    NSString *usageError = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_UsageTriggerError", currentIp]];
    
    NSString *osdWarnString = [NSString stringWithFormat:@"%@ OSD is in abnormal status", osdWarn];
    NSString *monWarnString = [NSString stringWithFormat:@"%@ monitor is in abnormal status", monWarn];
    NSString *pgWarnString = [NSString stringWithFormat:@"%@%% PGs are modified by Ceph", pgWarn];
    NSString *usageWarnString = [NSString stringWithFormat:@"Trigger alert when usage exceeds %@%%", usageWarn];
    
    NSString *osdErrorString = [NSString stringWithFormat:@"%@ OSD is in severely status", osdError];
    NSString *monErrorString = [NSString stringWithFormat:@"%@ monitor is in severely status", monError];
    NSString *pgErrorString = [NSString stringWithFormat:@"%@%% PGs stuck in abnormal status", pgError];
    NSString *usageErrorString = [NSString stringWithFormat:@"Trigger alert when usage exceeds %@%%", usageError];
    
    self.triggerWarnDetailArray = @[osdWarnString, monWarnString, pgWarnString, usageWarnString];
    self.triggerErrorDetailArray = @[osdErrorString, monErrorString, pgErrorString, usageErrorString];
}

@end
