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
        self.alertTitleArray = @[@"settings_alert_notifications", @"settings_alert_email_notifications", @"settings_auto_delete", @"settings_time_period", @"settings_alert_triggers"];
        self.alertBodyArray = @[@"settings_alert_notifications_detail", @"settings_alert_email_notifications_detail", @"settings_auto_delete_detail", @"settings_time_period_detail",  @"settings_alert_triggers_detail"];
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
    
    NSString *osdWarnString = [NSString stringWithFormat:@"%@", osdWarn];
    NSString *monWarnString = [NSString stringWithFormat:@"%@", monWarn];
    NSString *pgWarnString = [NSString stringWithFormat:@"%@%%", pgWarn];
    NSString *usageWarnString = [NSString stringWithFormat:@"%@%%", usageWarn];
    
    NSString *osdErrorString = [NSString stringWithFormat:@"%@", osdError];
    NSString *monErrorString = [NSString stringWithFormat:@"%@", monError];
    NSString *pgErrorString = [NSString stringWithFormat:@"%@%%", pgError];
    NSString *usageErrorString = [NSString stringWithFormat:@"%@%%", usageError];
    
    self.triggerWarnDetailArray = @[osdWarnString, monWarnString, pgWarnString, usageWarnString];
    self.triggerErrorDetailArray = @[osdErrorString, monErrorString, pgErrorString, usageErrorString];
}

+ (NSString*) caculateTimePeriodFormatStringWithValue:(NSString*)value {
    NSString *hourString = ([[value substringToIndex:2] intValue] > 0) ? [NSString stringWithFormat:@"%d hours ", [[value substringToIndex:2] intValue]] : @"";
    
    NSString *minuteString = ([[value substringWithRange:NSMakeRange(2, 2)] intValue] > 0) ? [NSString stringWithFormat:@"%d minutes ", [[value substringWithRange:NSMakeRange(2, 2)] intValue]] : @"";
    
    NSString *secondString = ([[value substringFromIndex:4] intValue] > 0) ? [NSString stringWithFormat:@"%d seconds", [[value substringFromIndex:4] intValue]] : @"";
    return [NSString stringWithFormat:@"%@%@%@", hourString, minuteString, secondString];
}

+ (NSString*) caculateTimePeriodTotalWithValue:(NSString *)value {
    NSInteger hourValue = [[value substringToIndex:2] integerValue];
    
    NSInteger minuteValue = [[value substringWithRange:NSMakeRange(2, 2)] integerValue];
    
    NSInteger secondValue = [[value substringFromIndex:4] integerValue];
    NSInteger totalValue = hourValue * 3600 + minuteValue * 60 + secondValue;
    return [NSString stringWithFormat:@"%ld", (long)totalValue];
}

@end
