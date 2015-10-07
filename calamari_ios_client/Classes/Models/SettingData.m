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
        self.triggerWarnDetailArray = @[@"1 OSD is in abnormal status", @"1 monitor is in abnormal status", @"20% PGs are modified by Ceph", @"Trigger alert when usage exceeds 70%"];
        self.triggerErrorDetailArray = @[@"1 OSD is in severely status", @"1 monitor is in severely status", @"20% PGs stuck in abnormal status", @"Trigger alert when usage exceeds 85%"];

    }
    return self;
}

@end
