//
//  DateMaker.h
//  inWinStackCeph
//
//  Created by Francis on 2015/6/3.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateMaker : NSObject

+ (DateMaker*) shareDateMaker;
- (NSString*) getTodayWithNotificationFormat;
- (NSString*) getTimeWithTimeStamp:(NSString*)timeStamp;
- (NSString*) getDateWithDate:(NSString*)dateString;
- (NSString*) getTimeWithDate:(NSString*)dateString;

@end
