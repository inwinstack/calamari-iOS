//
//  NotificationData.h
//  inWinStackCeph
//
//  Created by Francis on 2015/5/28.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, NotificationCoditionType) {
    ConditionNewWarn = 0,
    ConditionWarnMoreThanOriginal,
    ConditionWarnDoneThenWarn,
    ConditionWarnDone,
    ConditionNewError,
    ConditionErrorMoreThanOriginal,
    ConditionErrorDoneThenError,
    ConditionErrorDone,
};

typedef NS_ENUM(NSUInteger, NotificationType) {
    OSDNotificationType = 0,
    MONNotificationType,
    PGNotificationType,
};

typedef  NS_ENUM(NSUInteger, NotificationUsageType) {
    UsageWarnType = 0,
    UsageErrorType,
    UsageDoneType,
};

@interface NotificationData : NSObject

@property (nonatomic, strong) NSMutableArray *notificationArray;
@property (nonatomic, strong) NSDictionary *warnCodeDic;
@property (nonatomic, strong) NSString *warnSec;
@property (nonatomic, strong) NSTimer *refreshTimer;
@property (nonatomic, strong) NSMutableArray *warnOriginalArray;
@property (nonatomic, strong) NSMutableArray *warnPreviousArray;
@property (nonatomic, strong) NSMutableArray *errorOriginalArray;
@property (nonatomic, strong) NSMutableArray *errorPreviousArray;

+ (NotificationData*) shareInstance;

- (void) startTimer;
- (void) restartTimerWithTimeInterval:(float)timeInterValCount;
- (void) stopTimer;
- (void) resetRecord;

@end
