//
//  LocalizationManager.m
//  calamari_ios_client
//
//  Created by Francis on 2015/10/1.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import "LocalizationManager.h"

@interface LocalizationManager ()

@property (nonatomic, strong) NSDictionary *languageDic;
@property (nonatomic, strong) NSDictionary *localizationData;

@end

@implementation LocalizationManager

+ (LocalizationManager*) sharedLocalizationManager {
    static LocalizationManager *localizationManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        localizationManager = [[LocalizationManager alloc] init];
    });
    return localizationManager;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.languageDic = @{@"English" : @"English", @"繁體中文" : @"TranditionalChinese", @"日本語" : @"Japanese"};
        [self setLanguege];
    }
    return self;
}

- (void) setLanguege {
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:self.languageDic[[[NSUserDefaults standardUserDefaults] objectForKey:@"CurrentLanguage"]] ofType:@"plist"];
    self.localizationData = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
}

- (NSString*) getTextByKey:(NSString*)key {
    return self.localizationData[key];
}

@end
