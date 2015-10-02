//
//  SettingData.h
//  calamari_ios_client
//
//  Created by Francis on 2015/9/22.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingData : NSObject

@property (nonatomic, strong) NSArray *settingNameArray;
@property (nonatomic, strong) NSArray *settingMainNameArray;
@property (nonatomic, strong) NSMutableArray *settingDetailArray;
@property (nonatomic, strong) NSArray *languageOptionArray;
@property (nonatomic, strong) NSArray *dateFormatOptionArray;
@property (nonatomic, strong) NSArray *languageImageOptionArray;

+ (SettingData*) shareSettingData;

@end
