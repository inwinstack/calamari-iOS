//
//  NotificationData.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/28.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "NotificationData.h"

@implementation NotificationData

+ (NotificationData*) shareInstance {
    static NotificationData *notificationData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        notificationData = [[NotificationData alloc] init];
    });
    return notificationData;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.notificationArray = [NSMutableArray array];
    }
    return self;
}



@end
