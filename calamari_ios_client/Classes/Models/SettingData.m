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
    }
    return self;
}

@end
