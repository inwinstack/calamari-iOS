//
//  NotificationData.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/28.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "NotificationData.h"
#import "CephAPI.h"
#import "ClusterData.h"
#import "DateMaker.h"

@interface NotificationData () {
    int timeCount;
}

@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSArray *notificationContentArray;
@property (nonatomic, strong) NSArray *notificationUsageContentArray;
@property (nonatomic, strong) NSArray *notificationContentDetailArray;
@property (nonatomic, strong) NSArray *notificationUsageContentDetailArray;
@property (nonatomic) BOOL canNotification;

@end

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
        self.canNotification = YES;
        self.notificationArray = [NSMutableArray array];
        [self resetRecord];
        self.warnSec = @"30";
        self.warnCodeDic = @{@"OSD" : @"01", @"Monitor" : @"02", @"PG" : @"03", @"Usage" : @"04", @"Info" : @"4", @"Warning" : @"3", @"Error" : @"2", @"Critical" : @"1"};
        
        self.keyArray = @[@"osd", @"mon", @"pg", @"space"];
        self.notificationContentArray = @[@[@"發生 OSD 異常！", @"OSD 異常數增加！", @"OSD 異常數增加！", @"OSD 修復完成！", @"發生 OSD 損毀！", @"OSD 損毀數增加！", @"OSD 損毀數增加！", @"OSD 修復完成！"], @[@"發生 Monitor 異常！", @"Monitor 異常數增加！", @"Monitor 異常數增加！", @"Monitor 修復完成！", @"發生 Monitor 損毀！", @"Monitor 損毀數增加！", @"Monitor 損毀數增加！", @"Monitor 修復完成！"], @[@"PG 狀態更新中！PG 嘗試修復系統中", @"PG 狀態更新中！", @"PG 狀態更新中！", @"PG 修復完成！", @"PG 狀態異常！", @"PG 異常數增加！", @"PG 異常數增加！", @"PG 修復完成！"]];
        self.notificationUsageContentArray = @[@"使用量已超過 70%！建議擴充儲存空間！", @"使用量已達上限！請立即擴充儲存空間！", @"系統修復完成"];
        self.notificationContentDetailArray = @[@[@"OSD is in abnormal status!", @"OSD comes new abnormal status!", @"OSD comes new abnormal status!", @"OSD has been repaired!"], @[@"Monitor is in abnormal status!", @"Monitor comes new abnormal status!", @"Monitor comes new abnormal status!", @"Monitor has been repaired!"], @[@"Some PGs are being modified by Ceph!", @"Some other PGs are being modified by Ceph!", @"Some other PGs are being modified by Ceph!", @"PGs have been repaired!"]];
        self.notificationUsageContentDetailArray = @[@"Disk usage exceeds 70%! Please expand the storage capacity!", @"Disk usage exceeds 85%! Please expand the storage capacity!", @"Storage capacity has been expanded!"];
        timeCount = 0;
    }
    return self;
}

- (void) resetRecord {
    self.warnOriginalArray = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0", @"0"]];
    self.warnPreviousArray = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0", @"0"]];
    self.errorOriginalArray = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0", @"0"]];
    self.errorPreviousArray = [NSMutableArray arrayWithArray:@[@"0", @"0", @"0", @"0"]];
}

- (void) startTimer {
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshAction) userInfo:nil repeats:YES];
}

- (void) stopTimer {
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
}

- (void) restartTimerWithTimeInterval:(float)timeInterValCount {
    
}

- (void) refreshAction {
    timeCount++;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timeAddAction" object:[NSString stringWithFormat:@"%d", timeCount]];
    if (timeCount == [self.warnSec intValue]) {
        timeCount = 0;
        [self stopTimer];
        __weak typeof(self) weakSelf = self;
        [[CephAPI shareInstance] startGetClusterDetailAtBackgroundCompletion:^(BOOL finished) {
            if (finished) {
                weakSelf.warnSec = @"30";
                [weakSelf startCheck];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didRefreshAction" object:nil];
            }
        } error:^(id error) {
            if (error) {
                NSInteger errorCode = labs([error code]);
                if ((errorCode >= 400 && errorCode < 410) || (errorCode >= 500 && errorCode < 510)) {
                    weakSelf.warnSec = @"3600";
                }
                [weakSelf  startTimer];
                NSLog(@"%@", error);
            }
        }];

    }
}

- (void) startCheck {
    self.canNotification = YES;
    for (id object in [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"report"][@"summary"]) {
        if ([[NSString stringWithFormat:@"%@", object[@"summary"]] isEqualToString:@"noout flag(s) set"]) {
            self.canNotification = NO;
            break;
        }
    }
    int loopCount = 0;
    NSString *clusterID = [ClusterData shareInstance].clusterArray[0][@"id"];
    for (NSString *key in self.keyArray) {
        NSDictionary *dataDic;
        if (loopCount == self.keyArray.count - 1) {
            NSString *getKey = [NSString stringWithFormat:@"%@_%@", clusterID, key];
            dataDic = [ClusterData shareInstance].clusterDetailData[getKey];
            double usagePercent = [dataDic[@"space"][@"used_bytes"] doubleValue] / [dataDic[@"space"][@"capacity_bytes"] doubleValue];
            NSString *usagePercentString = [NSString stringWithFormat:@"%.f", usagePercent * 100.0];
            if (usagePercent >= 0.85) {
                [self makeNotificationStringWithUsageType:UsageErrorType];
                [self addToNotificationArrayWithUsageType:UsageErrorType usagePercent:usagePercentString];
                self.warnPreviousArray[loopCount] = @"0";
                self.errorPreviousArray[loopCount] = @"1";
            } else if (usagePercent >= 0.7) {
                [self makeNotificationStringWithUsageType:UsageWarnType];
                [self addToNotificationArrayWithUsageType:UsageWarnType usagePercent:usagePercentString];
                self.warnPreviousArray[loopCount] = @"1";
                self.errorPreviousArray[loopCount] = @"0";
            } else {
                if ([self.warnPreviousArray[loopCount] intValue] > 0 || [self.errorPreviousArray[loopCount] intValue] > 0) {
                    self.warnPreviousArray[loopCount] = @"0";
                    self.errorPreviousArray[loopCount] = @"0";
                    [self makeNotificationStringWithUsageType:UsageDoneType];
                    [self addToNotificationArrayWithUsageType:UsageDoneType usagePercent:usagePercentString];
                }
            }
        } else {
            NSString *getFirstKey = [NSString stringWithFormat:@"%@_health_counters", clusterID];
            dataDic = [ClusterData shareInstance].clusterDetailData[getFirstKey][key];
            int warnCount = [dataDic[@"warn"][@"count"] intValue];
            int warnOriginalCount = [self.warnOriginalArray[loopCount] intValue];
            int warnPreviousCount = [self.warnPreviousArray[loopCount] intValue];
            
            int errorCount = [dataDic[@"critical"][@"count"] intValue];
            int errorOriginalCount = [self.errorOriginalArray[loopCount] intValue];
            int errorPreviousCount = [self.errorPreviousArray[loopCount] intValue];
            
            if ([key isEqualToString:@"pg"]) {
                int totalCount = [dataDic[@"ok"][@"count"] intValue] + errorCount + warnCount;
                [self findPgWithTotal:totalCount original:warnOriginalCount previous:warnPreviousCount count:warnCount isWarn:true notificationType:loopCount];
                [self findPgWithTotal:totalCount original:errorOriginalCount previous:errorPreviousCount count:errorCount isWarn:false notificationType:loopCount];
            } else {
                [self findWrongOfServerActionWithOriginal:warnOriginalCount previous:warnPreviousCount count:warnCount isWarn:true notificationType:loopCount pgCountString:@""];
                [self findWrongOfServerActionWithOriginal:errorOriginalCount previous:errorPreviousCount count:errorCount isWarn:false notificationType:loopCount pgCountString:@""];
            }
        }
        loopCount++;
    }
    [self  startTimer];
}

- (void) upDateWarnDataWithType:(NotificationType)type Count:(int)warnCount {
    self.warnOriginalArray[type] = [NSString stringWithFormat:@"%d", warnCount];
    self.warnPreviousArray[type] = [NSString stringWithFormat:@"%d", warnCount];
}

- (void) upDateErrorDataWithType:(NotificationType)type Count:(int)errorCount {
    self.errorOriginalArray[type] = [NSString stringWithFormat:@"%d", errorCount];
    self.errorPreviousArray[type] = [NSString stringWithFormat:@"%d", errorCount];
}

- (void) findPgWithTotal:(int)total original:(int)original previous:(int)previous count:(int)count isWarn:(BOOL)isWarn notificationType:(NotificationType)notificationType {
    float totalFloat = (float)total;
    float countFloat = (float)count;
    float totalPercent = totalFloat * 0.2;
    float pgPercent = countFloat / totalFloat * 100.0;
    NSString *pgWarnCountString = [NSString stringWithFormat:@"%.f%% ( %d / %d )", pgPercent, count, total];
    if ((totalPercent > count) && (original > count) && (previous > count)) {
        if (isWarn) {
            [self upDateWarnDataWithType:notificationType Count:0];
            [self makeNotificationStringWithConditionType:ConditionWarnDone notificationType:notificationType];
            [self addToNotificationArrayWithType:notificationType conditionType:ConditionWarnDone total:previous pgCountString:pgWarnCountString];
        } else {
            [self upDateErrorDataWithType:notificationType Count:0];
            [self makeNotificationStringWithConditionType:ConditionErrorDone notificationType:notificationType];
            [self addToNotificationArrayWithType:notificationType conditionType:ConditionErrorDone total:previous pgCountString:pgWarnCountString];
        }
    } else if (totalPercent < count) {
        [self findWrongOfServerActionWithOriginal:original previous:previous count:count isWarn:isWarn notificationType:notificationType pgCountString:pgWarnCountString];
    }
}

- (void) findWrongOfServerActionWithOriginal:(int)original previous:(int)previous count:(int)count isWarn:(BOOL)isWarn notificationType:(NotificationType)notificationType pgCountString:(NSString*)pgCountString {
    if (count > 0) {
        self.warnSec = @"120";
        if ((original == 0) && (count > original) && (count > previous)) {
            if (isWarn) {
                [self upDateWarnDataWithType:notificationType Count:count];
                [self makeNotificationStringWithConditionType:ConditionNewWarn notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionNewWarn total:count pgCountString:pgCountString];
            } else {
                [self upDateErrorDataWithType:notificationType Count:count];
                [self makeNotificationStringWithConditionType:ConditionNewError notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionNewError total:count pgCountString:pgCountString];
            }
        } else if ((original > 0) && (count > original) && (count > previous)) {
            if (isWarn) {
                [self upDateWarnDataWithType:notificationType Count:count];
                [self makeNotificationStringWithConditionType:ConditionWarnMoreThanOriginal notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionWarnMoreThanOriginal total:count pgCountString:pgCountString];
            } else {
                [self upDateErrorDataWithType:notificationType Count:count];
                [self makeNotificationStringWithConditionType:ConditionErrorMoreThanOriginal notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionErrorMoreThanOriginal total:count pgCountString:pgCountString];
            }
        } else if ((count < original) && (count < previous)) {
            if (isWarn) {
                self.warnPreviousArray[notificationType] = [NSString stringWithFormat:@"%d", count];
            } else {
                self.errorPreviousArray[notificationType] = [NSString stringWithFormat:@"%d", count];
            }
        } else if ((count < original) && (count > previous)) {
            if (isWarn) {
                self.warnPreviousArray[notificationType] = [NSString stringWithFormat:@"%d", count];
                [self makeNotificationStringWithConditionType:ConditionWarnDoneThenWarn notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionWarnDoneThenWarn total:count pgCountString:pgCountString];
            } else {
                self.errorPreviousArray[notificationType] = [NSString stringWithFormat:@"%d", count];
                [self makeNotificationStringWithConditionType:ConditionErrorDoneThenError notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionErrorDoneThenError total:count pgCountString:pgCountString];
            }
        }
    } else if (count == 0) {
        if ((count < original) && (count < previous)) {
            if (isWarn) {
                [self upDateWarnDataWithType:notificationType Count:count];
                [self makeNotificationStringWithConditionType:ConditionWarnDone notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionWarnDone total:previous pgCountString:pgCountString];
            } else {
                [self upDateErrorDataWithType:notificationType Count:count];
                [self makeNotificationStringWithConditionType:ConditionErrorDone notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionErrorDone total:previous pgCountString:pgCountString];
            }
        }
    }
    
}

- (void) addToNotificationArrayWithUsageType:(NotificationUsageType)notificationUsageType usagePercent:(NSString*)usagePercent {
    NSString *notificationConetentString = self.notificationUsageContentDetailArray[notificationUsageType];
    NSString *notificationTimeString = [NSString stringWithFormat:@" - %@", [[DateMaker shareDateMaker] getTodayWithNotificationFormat]];
    NSString *notificationStatusString = (notificationUsageType == UsageDoneType) ? @"Resolved" :  @"Pending";
    NSString *notificationTypeString;
    if (notificationUsageType == UsageErrorType) {
        notificationTypeString = @"Error";
    } else if (notificationUsageType == UsageWarnType) {
        notificationTypeString = @"Warning";
    }
    
    NSDictionary *notificationContentDictionary = @{@"Content" : notificationConetentString, @"Status" : notificationStatusString, @"Time" : notificationTimeString, @"Type" : notificationTypeString, @"ErrorCount" : usagePercent, @"ErrorTitle" : @"Usage"};
    
    if (self.notificationArray.count > 0) {
        [self.notificationArray insertObject:notificationContentDictionary atIndex:0];
    } else {
        [self.notificationArray addObject:notificationContentDictionary];
    }
}

- (void) addToNotificationArrayWithType:(NotificationType)notificationType conditionType:(NotificationCoditionType)conditionType total:(int)total pgCountString:(NSString*)pgCountString {
    NSString *notificationConetentString = self.notificationContentDetailArray[notificationType][conditionType % 4];
    NSString *notificationTimeString = [NSString stringWithFormat:@" - %@", [[DateMaker shareDateMaker] getTodayWithNotificationFormat]];
    NSString *notificationStatusString = ((conditionType == ConditionWarnDone) || (conditionType == ConditionErrorDone)) ? @"Resolved" :  @"Pending";
    
    NSString *notificationTypeString = (conditionType > 3) ? @"Error" : @"Warning";
    NSString *notificationTitleString;
    NSString *totalErrorString = [NSString stringWithFormat:@"%d", total];
    
    if ([notificationTypeString isEqualToString:@"Error"]) {
        if (notificationType == PGNotificationType) {
            notificationTitleString = @"Error ratio";
            totalErrorString = pgCountString;
        } else {
            notificationTitleString = @"Errors";
        }
    } else {
        if (notificationType == PGNotificationType) {
            notificationTitleString = @"Warning ratio";
            totalErrorString = pgCountString;
        } else {
            notificationTitleString = @"Warnings";
        }
    }

    NSDictionary *notificationContentDictionary;
    if (conditionType == ConditionWarnDone) {
        NSString *resolveTimeString = notificationTimeString;
        NSString *resolveContentString = notificationConetentString;
        for (int i = 0; i < self.notificationArray.count; i++) {
            NSDictionary *tempDic = self.notificationArray[i];
            if ([tempDic[@"Type"] isEqualToString:@"Warning"] && [tempDic[@"TypeCode"] isEqualToString:self.keyArray[notificationType]]) {
                resolveContentString = tempDic[@"Content"];
                totalErrorString = tempDic[@"ErrorCount"];
                notificationTimeString = tempDic[@"Time"];
                break;
            }
        }
        notificationContentDictionary = @{@"Content" : notificationConetentString, @"Status" : notificationStatusString, @"Time" : notificationTimeString, @"Type" : notificationTypeString, @"ErrorCount" : totalErrorString, @"ErrorTitle" : notificationTitleString, @"ResolveTime" : resolveTimeString, @"ResolveContent" : resolveContentString};

    } else if (conditionType == ConditionErrorDone) {
        NSString *resolveTimeString = notificationTimeString;
        NSString *resolveContentString = notificationConetentString;
        for (int i = 0; i < self.notificationArray.count; i++) {
            NSDictionary *tempDic = self.notificationArray[i];
            if ([tempDic[@"Type"] isEqualToString:@"Error"] && [tempDic[@"TypeCode"] isEqualToString:self.keyArray[notificationType]]) {
                resolveContentString = tempDic[@"Content"];
                totalErrorString = tempDic[@"ErrorCount"];
                notificationTimeString = tempDic[@"Time"];
                break;
            }
        }
        notificationContentDictionary = @{@"Content" : notificationConetentString, @"Status" : notificationStatusString, @"Time" : notificationTimeString, @"Type" : notificationTypeString, @"ErrorCount" : totalErrorString, @"ErrorTitle" : notificationTitleString, @"ResolveTime" : resolveTimeString, @"ResolveContent" : resolveContentString};

    } else {
        notificationContentDictionary = @{@"Content" : notificationConetentString, @"Status" : notificationStatusString, @"Time" : notificationTimeString, @"Type" : notificationTypeString, @"ErrorCount" : totalErrorString, @"ErrorTitle" : notificationTitleString, @"TypeCode" : [NSString stringWithFormat:@"%@", self.keyArray[notificationType]]};
    }
    if (self.notificationArray.count > 0) {
        [self.notificationArray insertObject:notificationContentDictionary atIndex:0];
    } else {
        [self.notificationArray addObject:notificationContentDictionary];
    }
}

- (void) makeNotificationStringWithConditionType:(NotificationCoditionType)conditionType notificationType:(NotificationType)notificationType {
    NSString *notificationContentString = self.notificationContentArray[notificationType][conditionType];
    [self startNotificationWithNotificationString:notificationContentString];
}

- (void) makeNotificationStringWithUsageType:(NotificationUsageType)usageType {
    NSString *usageContentString = self.notificationUsageContentArray[usageType];
    [self startNotificationWithNotificationString:usageContentString];
}

- (void) startNotificationWithNotificationString:(NSString*)notificationString {
    if (self.canNotification) {
        UILocalNotification* notifyWarn = [[UILocalNotification alloc] init];
        notifyWarn.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        notifyWarn.timeZone = [NSTimeZone defaultTimeZone];
        notifyWarn.repeatInterval = 0;
        notifyWarn.soundName = UILocalNotificationDefaultSoundName;
        notifyWarn.applicationIconBadgeNumber = self.notificationArray.count;
        notifyWarn.alertBody = notificationString;
        [[UIApplication sharedApplication] scheduleLocalNotification:notifyWarn];
    }
}

@end
