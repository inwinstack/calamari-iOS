//
//  NotificationData.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/28.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationData : NSObject

@property (nonatomic, strong) NSMutableArray *notificationArray;

+ (NotificationData*) shareInstance;

@end
