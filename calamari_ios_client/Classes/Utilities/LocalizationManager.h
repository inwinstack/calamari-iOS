//
//  LocalizationManager.h
//  calamari_ios_client
//
//  Created by Francis on 2015/10/1.
//  Copyright © 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalizationManager : NSObject

+ (LocalizationManager*) sharedLocalizationManager;

- (void) setLanguege;
- (NSString*) getTextByKey:(NSString*)key;

@end
