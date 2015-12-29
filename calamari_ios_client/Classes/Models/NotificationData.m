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
#import "LocalizationManager.h"
#import "SettingData.h"
#import "APIRecord.h"

@interface NotificationData () {
    int timeCount;
    int dashBoardCount;
}

@property (nonatomic, strong) NSArray *keyArray;
@property (nonatomic, strong) NSArray *notificationContentArray;
@property (nonatomic, strong) NSArray *notificationUsageContentArray;
@property (nonatomic, strong) NSArray *notificationContentDetailArray;
@property (nonatomic, strong) NSArray *notificationUsageContentDetailArray;
@property (nonatomic, strong) NSMutableArray *notificationWarnCountArray;
@property (nonatomic, strong) NSMutableArray *notificationErrorCountArray;
@property (nonatomic, strong) NSArray *triggerKeyArray;
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
        self.isBackground = NO;
        self.notificationArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_NotificationAlerts", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]]];
        self.warnSec = @"30";
        self.warnCodeDic = @{@"OSD" : @"01", @"Monitor" : @"02", @"PG" : @"03", @"Usage" : @"04", @"Info" : @"4", @"Warning" : @"3", @"Error" : @"2", @"Critical" : @"1"};
        self.triggerKeyArray = @[@"OSD", @"MON", @"PG", @"Usage"];
        self.keyArray = @[@"osd", @"mon", @"pg", @"space"];
        self.notificationContentArray = @[@[@"OSD is in abnormal status!", @"OSD comes new abnormal status!", @"OSD comes new abnormal status!", @"OSD has been repaired!", @"OSD is in severe status!", @"OSD comes new severe status!", @"OSD comes new severe status!", @"OSD has been repaired!"], @[@"Monitor is in abnormal status!", @"Monitor comes new abnormal status!", @"Monitor comes new abnormal status!", @"Monitor has been repaired!", @"Monitor is in severe status!", @"Monitor comes new severe status!", @"Monitor comes new severe status!", @"Monitor has been repaired!"], @[@"Some PGs are being modified by Ceph!", @"Some other PGs are being modified by Ceph!", @"Some other PGs are being modified by Ceph!", @"PGs have been repaired!", @"Some PGs stuck in abnormal states!", @"Some other PGs stuck in abnormal states!", @"Some other PGs stuck in abnormal states!", @"PGs have been repaired!"]];
        self.notificationUsageContentArray = @[@"Disk usage exceeds 70%!Please expand the storage capacity!", @"Not enough free space! Please expand the storage capacity immediately!", @"Storage capacity has been expanded!"];
        self.notificationContentDetailArray = @[@[@"OSD is in abnormal status!", @"OSD comes new abnormal status!", @"OSD comes new abnormal status!", @"OSD has been repaired!"], @[@"Monitor is in abnormal status!", @"Monitor comes new abnormal status!", @"Monitor comes new abnormal status!", @"Monitor has been repaired!"], @[@"Some PGs are being modified by Ceph!", @"Some other PGs are being modified by Ceph!", @"Some other PGs are being modified by Ceph!", @"PGs have been repaired!"]];
        self.notificationUsageContentDetailArray = @[@"Disk usage exceeds 70%! Please expand the storage capacity!", @"Disk usage exceeds 85%! Please expand the storage capacity!", @"Storage capacity has been expanded!"];
        timeCount = 0;
        dashBoardCount = 0;
    }
    return self;
}

- (void) setRecordWithHostIp:(NSString*)hostIp {
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_didResetRecordArray", hostIp]]) {

        [[NSUserDefaults standardUserDefaults] setObject:@[@"0", @"0", @"0", @"0"] forKey:[NSString stringWithFormat:@"%@_WarnPreviousRecord", hostIp]];
        [[NSUserDefaults standardUserDefaults] setObject:@[@"0", @"0", @"0", @"0"] forKey:[NSString stringWithFormat:@"%@_WarnOriginalRecord", hostIp]];
        [[NSUserDefaults standardUserDefaults] setObject:@[@"0", @"0", @"0", @"0"] forKey:[NSString stringWithFormat:@"%@_ErrorPreviousRecord", hostIp]];
        [[NSUserDefaults standardUserDefaults] setObject:@[@"0", @"0", @"0", @"0"] forKey:[NSString stringWithFormat:@"%@_ErrorOriginalRecord", hostIp]];
        [[NSUserDefaults standardUserDefaults] setObject:@[@"0", @"0", @"0", @"0"] forKey:[NSString stringWithFormat:@"%@_WarnCountRecord", hostIp]];
        [[NSUserDefaults standardUserDefaults] setObject:@[@"0", @"0", @"0", @"0"] forKey:[NSString stringWithFormat:@"%@_ErrorCountRecord", hostIp]];
        [[NSUserDefaults standardUserDefaults] setObject:@"did" forKey:[NSString stringWithFormat:@"%@_didResetRecordArray", hostIp]];

    }
}

- (void) resetRecord {
    NSString *currentHostIp = [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"];
    self.warnOriginalArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_WarnPreviousRecord", currentHostIp]]];
    self.warnPreviousArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_WarnOriginalRecord", currentHostIp]]];
    self.notificationErrorCountArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_ErrorCountRecord", currentHostIp]]];
    self.notificationWarnCountArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_WarnCountRecord", currentHostIp]]];
    self.errorOriginalArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_ErrorPreviousRecord", currentHostIp]]];
    self.errorPreviousArray = [NSMutableArray arrayWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_ErrorOriginalRecord", currentHostIp]]];
}

- (void) startTimer {
    self.refreshTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshAction) userInfo:nil repeats:YES];
}

- (void) stopTimer {
    [self.refreshTimer invalidate];
    self.refreshTimer = nil;
    timeCount = 0;
}

- (void) restartTimerWithTimeInterval:(float)timeInterValCount {
    [self stopTimer];
    self.warnSec = [NSString stringWithFormat:@"%.f", timeInterValCount];
    [self startTimer];
}

- (void) refreshAction {
    timeCount++;
    if (timeCount == [self.warnSec intValue]) {
        timeCount = 0;
        [self stopTimer];
        __weak typeof(self) weakSelf = self;
        NSString *hostIp = [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"];
        [[CephAPI shareInstance] startGetClusterDetailAtBackgroundCompletion:^(BOOL finished) {
            if (finished) {
                
                weakSelf.warnSec = [SettingData caculateTimePeriodTotalWithValue:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_normalTimePeriod", hostIp]]];
                [weakSelf startCheck];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didRefreshAction" object:nil];
            }
        } error:^(id error) {
            if (error) {
                NSInteger errorCode = labs([error code]);
                if ((errorCode >= 400 && errorCode < 410) || (errorCode >= 500 && errorCode < 510)) {
                    weakSelf.warnSec = [SettingData caculateTimePeriodTotalWithValue:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_serverAbnormalTimePeriod", hostIp]]];
                }
                [weakSelf  startTimer];
                NSLog(@"%@", error);
            }
        }];

    }
}

- (void) startCheck {
//    NSLog(@"%@\n%@\n%@\n%@",self.warnOriginalArray, self.warnPreviousArray, self.errorOriginalArray, self.errorPreviousArray);
    self.canNotification = YES;
    for (id object in [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"report"][@"summary"]) {
        if ([[NSString stringWithFormat:@"%@", object[@"summary"]] isEqualToString:@"noout flag(s) set"]) {
            self.canNotification = NO;
            break;
        }
    }
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_Auto Delete", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]] isEqualToString:@"YES"]) {
        NSMutableArray *tempDeleteArray = [NSMutableArray array];

        for (id notificationContent in self.notificationArray) {
            (notificationContent[@"ResolveTime"]) ? [tempDeleteArray addObject:notificationContent] : nil;
        }
        for (id deleteObj in tempDeleteArray) {
            [self.notificationArray removeObject:deleteObj];
        }
        [[NSUserDefaults standardUserDefaults] setObject:self.notificationArray forKey:[NSString stringWithFormat:@"%@_NotificationAlerts", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]];
        
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

            float tempUsageErrorTrigger = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_UsageTriggerError", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]] floatValue] / 100.0;
            float tempUsageWarnTrigger = [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_UsageTriggerWarn", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]] floatValue] / 100.0;
            
            if (usagePercent >= tempUsageErrorTrigger) {
                [self makeNotificationStringWithUsageType:UsageErrorType];
                [self addToNotificationArrayWithUsageType:UsageErrorType usagePercent:usagePercentString];
                self.warnPreviousArray[loopCount] = @"0";
                self.errorPreviousArray[loopCount] = @"1";
            } else if (usagePercent >= tempUsageWarnTrigger) {
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

- (void) upDateWarnDataWithType:(NotificationType)type conditionType:(NotificationCoditionType)conditionType Count:(int)warnCount {
    NSString *currentHostIp = [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"];
    int newCount;
    if (conditionType == ConditionNewWarn) {
        newCount = warnCount;
    } else if (conditionType == ConditionWarnDone) {
        newCount = 0;
    } else {
        newCount = [self.notificationWarnCountArray[type] intValue] + (warnCount - [self.warnPreviousArray[type] intValue]);
    }

    self.warnOriginalArray[type] = [NSString stringWithFormat:@"%d", warnCount];
    self.warnPreviousArray[type] = [NSString stringWithFormat:@"%d", warnCount];
    
    self.notificationWarnCountArray[type] = [NSString stringWithFormat:@"%d", newCount];

    [[NSUserDefaults standardUserDefaults] setObject:self.warnPreviousArray forKey:[NSString stringWithFormat:@"%@_WarnPreviousRecord", currentHostIp]];
    [[NSUserDefaults standardUserDefaults] setObject:self.warnOriginalArray forKey:[NSString stringWithFormat:@"%@_WarnOriginalRecord", currentHostIp]];
    [[NSUserDefaults standardUserDefaults] setObject:self.notificationWarnCountArray forKey:[NSString stringWithFormat:@"%@_WarnCountRecord", currentHostIp]];
}

- (void) upDateErrorDataWithType:(NotificationType)type conditionType:(NotificationCoditionType)conditionType Count:(int)errorCount {
    NSString *currentHostIp = [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"];
    int newCount;
    if (conditionType == ConditionNewError) {
        newCount = errorCount;
    } else if (conditionType == ConditionErrorDone) {
        newCount = 0;
    } else {
        newCount = [self.notificationErrorCountArray[type] intValue] + (errorCount - [self.errorPreviousArray[type] intValue]);
    }
    self.errorOriginalArray[type] = [NSString stringWithFormat:@"%d", errorCount];
    self.errorPreviousArray[type] = [NSString stringWithFormat:@"%d", errorCount];
    self.notificationErrorCountArray[type] = [NSString stringWithFormat:@"%d", newCount];

    [[NSUserDefaults standardUserDefaults] setObject:self.errorPreviousArray forKey:[NSString stringWithFormat:@"%@_ErrorPreviousRecord", currentHostIp]];
    [[NSUserDefaults standardUserDefaults] setObject:self.errorOriginalArray forKey:[NSString stringWithFormat:@"%@_ErrorOriginalRecord", currentHostIp]];
    [[NSUserDefaults standardUserDefaults] setObject:self.notificationErrorCountArray forKey:[NSString stringWithFormat:@"%@_ErrorCountRecord", currentHostIp]];

}

- (void) findPgWithTotal:(int)total original:(int)original previous:(int)previous count:(int)count isWarn:(BOOL)isWarn notificationType:(NotificationType)notificationType {
    float totalFloat = (float)total;
    float countFloat = (float)count;
    float calculatePercent = (!isWarn) ? [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_PGTriggerError", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]] floatValue] / 100.0 : [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_PGTriggerWarn", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]] floatValue] / 100.0;
    float totalPercent = totalFloat * calculatePercent;
    float pgPercent = countFloat / totalFloat * 100.0;
    NSString *pgWarnCountString = [NSString stringWithFormat:@"%.f%% ( %d / %d )", pgPercent, count, total];
    if ((totalPercent > count) && (original > count) && (previous > count)) {
        if (isWarn) {
            [self upDateWarnDataWithType:notificationType conditionType:ConditionWarnDone Count:0];
            [self makeNotificationStringWithConditionType:ConditionWarnDone notificationType:notificationType];
            [self addToNotificationArrayWithType:notificationType conditionType:ConditionWarnDone total:previous pgCountString:pgWarnCountString];
        } else {
            [self upDateErrorDataWithType:notificationType conditionType:ConditionErrorDone Count:0];
            [self makeNotificationStringWithConditionType:ConditionErrorDone notificationType:notificationType];
            [self addToNotificationArrayWithType:notificationType conditionType:ConditionErrorDone total:previous pgCountString:pgWarnCountString];
        }
    } else if (totalPercent < count) {
        [self findWrongOfServerActionWithOriginal:original previous:previous count:count isWarn:isWarn notificationType:notificationType pgCountString:pgWarnCountString];
    }
}

- (void) findWrongOfServerActionWithOriginal:(int)original previous:(int)previous count:(int)count isWarn:(BOOL)isWarn notificationType:(NotificationType)notificationType pgCountString:(NSString*)pgCountString {
    NSString *currentHostIp = [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"];
    NSString *triggerValue = (isWarn) ? [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@TriggerWarn",currentHostIp, self.triggerKeyArray[notificationType]]] : [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_%@TriggerError",currentHostIp, self.triggerKeyArray[notificationType]]];
    
    int triggerMinValue = (notificationType == PGNotificationType) ? 0 : [triggerValue intValue];
    
    if (count > 0) {
        if ((count < original) && (count > previous)) {
            if (isWarn) {
                [self upDateWarnDataWithType:notificationType conditionType:ConditionErrorDoneThenError Count:count];
            } else {
                
                [self upDateErrorDataWithType:notificationType conditionType:ConditionErrorDoneThenError Count:count];

            }
        }
    }
    
    if (count >= triggerMinValue) {
        
        self.warnSec = [SettingData caculateTimePeriodTotalWithValue:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_abnormalTimePeriod", currentHostIp]]];
        if ((original < triggerMinValue) && (count > original) && (count > previous)) {
            if (isWarn) {
                NSLog(@"didEnterFuck");
                [self upDateWarnDataWithType:notificationType conditionType:ConditionNewWarn Count:count];
                [self makeNotificationStringWithConditionType:ConditionNewWarn notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionNewWarn total:count pgCountString:pgCountString];
            } else {
                [self upDateErrorDataWithType:notificationType conditionType:ConditionNewError Count:count];
                [self makeNotificationStringWithConditionType:ConditionNewError notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionNewError total:count pgCountString:pgCountString];
            }
        } else if ((original >= triggerMinValue) && (count > original) && (count > previous)) {
            if (isWarn) {
                NSLog(@"didEnterRight");
                [self upDateWarnDataWithType:notificationType conditionType:ConditionWarnMoreThanOriginal Count:count];
                [self makeNotificationStringWithConditionType:ConditionWarnMoreThanOriginal notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionWarnMoreThanOriginal total:count pgCountString:pgCountString];
            } else {
                [self upDateErrorDataWithType:notificationType conditionType:ConditionErrorMoreThanOriginal Count:count];
                [self makeNotificationStringWithConditionType:ConditionErrorMoreThanOriginal notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionErrorMoreThanOriginal total:count pgCountString:pgCountString];
            }
        } else if ((count < original) && (count < previous)) {
            if (isWarn) {
                self.warnPreviousArray[notificationType] = [NSString stringWithFormat:@"%d", count];
                [[NSUserDefaults standardUserDefaults] setObject:self.warnPreviousArray forKey:[NSString stringWithFormat:@"%@_WarnPreviousRecord", currentHostIp]];
            } else {
                self.errorPreviousArray[notificationType] = [NSString stringWithFormat:@"%d", count];
                [[NSUserDefaults standardUserDefaults] setObject:self.errorPreviousArray forKey:[NSString stringWithFormat:@"%@_ErrorPreviousRecord", currentHostIp]];

            }
        } else if ((count < original) && (count > previous)) {
            if (isWarn) {
                self.warnPreviousArray[notificationType] = [NSString stringWithFormat:@"%d", count];
                [[NSUserDefaults standardUserDefaults] setObject:self.warnPreviousArray forKey:[NSString stringWithFormat:@"%@_WarnPreviousRecord", currentHostIp]];

                [self makeNotificationStringWithConditionType:ConditionWarnDoneThenWarn notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionWarnDoneThenWarn total:count pgCountString:pgCountString];
            } else {
                self.errorPreviousArray[notificationType] = [NSString stringWithFormat:@"%d", count];
                [[NSUserDefaults standardUserDefaults] setObject:self.errorPreviousArray forKey:[NSString stringWithFormat:@"%@_ErrorPreviousRecord", currentHostIp]];

                [self makeNotificationStringWithConditionType:ConditionErrorDoneThenError notificationType:notificationType];
                [self addToNotificationArrayWithType:notificationType conditionType:ConditionErrorDoneThenError total:count pgCountString:pgCountString];
            }
        }
    } else if (count <= triggerMinValue) {
        if ((count < original) && (count < previous)) {
            if (isWarn) {
                if (notificationType == PGNotificationType) {
                    [self upDateWarnDataWithType:notificationType conditionType:ConditionWarnDone Count:count];
                    [self makeNotificationStringWithConditionType:ConditionWarnDone notificationType:notificationType];
                    [self addToNotificationArrayWithType:notificationType conditionType:ConditionWarnDone total:previous pgCountString:pgCountString];
                } else {
                    if (count == 0) {
                        [self upDateWarnDataWithType:notificationType conditionType:ConditionWarnDone Count:count];
                        [self makeNotificationStringWithConditionType:ConditionWarnDone notificationType:notificationType];
                        [self addToNotificationArrayWithType:notificationType conditionType:ConditionWarnDone total:previous pgCountString:pgCountString];
                    } else {
                        self.warnSec = [SettingData caculateTimePeriodTotalWithValue:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_abnormalTimePeriod", currentHostIp]]];
                    }
                }
            } else {
                if (notificationType == PGNotificationType) {
                    [self upDateErrorDataWithType:notificationType conditionType:ConditionErrorDone Count:count];
                    [self makeNotificationStringWithConditionType:ConditionErrorDone notificationType:notificationType];
                    [self addToNotificationArrayWithType:notificationType conditionType:ConditionErrorDone total:previous pgCountString:pgCountString];
                } else {
                    if (count == 0) {
                        [self upDateErrorDataWithType:notificationType conditionType:ConditionErrorDone Count:count];
                        [self makeNotificationStringWithConditionType:ConditionErrorDone notificationType:notificationType];
                        [self addToNotificationArrayWithType:notificationType conditionType:ConditionErrorDone total:previous pgCountString:pgCountString];
                    } else {
                        self.warnSec = [SettingData caculateTimePeriodTotalWithValue:[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_abnormalTimePeriod", currentHostIp]]];
                    }
                }
                
            }
        }
    }
    
}

- (void) addToNotificationArrayWithUsageType:(NotificationUsageType)notificationUsageType usagePercent:(NSString*)usagePercent {
    NSString *notificationConetentString = self.notificationUsageContentDetailArray[notificationUsageType];
    NSString *notificationTimeString = [NSString stringWithFormat:@"%f", [[DateMaker shareDateMaker] getTodayTimestamp]];
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
    NSString *notificationConetentString = self.notificationContentArray[notificationType][conditionType];
    NSString *notificationTimeString = [NSString stringWithFormat:@"%f", [[DateMaker shareDateMaker] getTodayTimestamp]];
    NSString *notificationStatusString = ((conditionType == ConditionWarnDone) || (conditionType == ConditionErrorDone)) ? @"Resolved" :  @"Pending";
    
    NSString *notificationTypeString = (conditionType > 3) ? @"Error" : @"Warning";
    NSString *notificationTitleString;
    NSString *totalErrorString = (conditionType > 3) ? [NSString stringWithFormat:@"%@", self.notificationErrorCountArray[notificationType]] : [NSString stringWithFormat:@"%@", self.notificationWarnCountArray[notificationType]];
    
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

    NSMutableArray *tempGlobalDicArray = [NSMutableArray array];
    NSMutableArray *tempRemoveDicArray = [NSMutableArray array];
    NSDictionary *notificationContentDictionary;
    if (conditionType == ConditionWarnDone) {
        NSString *resolveTimeString = notificationTimeString;
        NSString *resolveContentString = notificationConetentString;
        for (int i = 0; i < self.notificationArray.count; i++) {
            NSDictionary *tempDic = self.notificationArray[i];
            
            if ([tempDic[@"Type"] isEqualToString:@"Warning"] && [tempDic[@"TypeCode"] isEqualToString:self.keyArray[notificationType]]) {
                [tempRemoveDicArray addObject:tempDic];
                resolveContentString = tempDic[@"Content"];
                totalErrorString = tempDic[@"ErrorCount"];
                notificationTimeString = tempDic[@"Time"];
                notificationContentDictionary = @{@"Content" : resolveContentString, @"Status" : notificationStatusString, @"Time" : notificationTimeString, @"Type" : notificationTypeString, @"ErrorCount" : totalErrorString, @"ErrorTitle" : notificationTitleString, @"ResolveTime" : resolveTimeString, @"ResolveContent" : resolveContentString};
                [tempGlobalDicArray addObject:notificationContentDictionary];
            }
        }

    } else if (conditionType == ConditionErrorDone) {
        NSString *resolveTimeString = notificationTimeString;
        NSString *resolveContentString = notificationConetentString;
        
        for (int i = 0; i < self.notificationArray.count; i++) {
            NSDictionary *tempDic = self.notificationArray[i];
            if ([tempDic[@"Type"] isEqualToString:@"Error"] && [tempDic[@"TypeCode"] isEqualToString:self.keyArray[notificationType]] ) {
                [tempRemoveDicArray addObject:tempDic];
                resolveContentString = tempDic[@"Content"];
                totalErrorString = tempDic[@"ErrorCount"];
                notificationTimeString = tempDic[@"Time"];
                notificationContentDictionary = @{@"Content" : resolveContentString, @"Status" : notificationStatusString, @"Time" : notificationTimeString, @"Type" : notificationTypeString, @"ErrorCount" : totalErrorString, @"ErrorTitle" : notificationTitleString, @"ResolveTime" : resolveTimeString, @"ResolveContent" : resolveContentString};
                [tempGlobalDicArray addObject:notificationContentDictionary];
            }
        }

    } else {
        
        notificationContentDictionary = @{@"Content" : notificationConetentString, @"Status" : notificationStatusString, @"Time" : notificationTimeString, @"Type" : notificationTypeString, @"ErrorCount" : totalErrorString, @"ErrorTitle" : notificationTitleString, @"TypeCode" : [NSString stringWithFormat:@"%@", self.keyArray[notificationType]]};
        for (int i = 0; i < self.notificationArray.count; i++) {
            NSDictionary *tempDic = self.notificationArray[i];
            if ([tempDic[@"Type"] isEqualToString:notificationTypeString] && [tempDic[@"TypeCode"] isEqualToString:self.keyArray[notificationType]] ) {
                [tempRemoveDicArray addObject:tempDic];
                
                [tempGlobalDicArray addObject:notificationContentDictionary];
            }
        }
    }
    if (tempGlobalDicArray.count > 0) {
        for (id removeObj in tempRemoveDicArray) {
            [self.notificationArray removeObject:removeObj];
        }
        for (int i = 0; i < tempGlobalDicArray.count; i++) {
            [self.notificationArray insertObject:tempGlobalDicArray[tempGlobalDicArray.count - 1 - i] atIndex:0];
        }
    } else {
        if (self.notificationArray.count > 0) {
            [self.notificationArray insertObject:notificationContentDictionary atIndex:0];
        } else {
            [self.notificationArray addObject:notificationContentDictionary];
        }
    }
    NSMutableArray *tempPendingArray = [NSMutableArray array];
    NSMutableArray *tempResolveArray = [NSMutableArray array];
    for (id notificationContent in self.notificationArray) {
        (notificationContent[@"ResolveTime"]) ? [tempResolveArray addObject:notificationContent] : [tempPendingArray addObject:notificationContent] ;
    }
    [self sortArray:tempPendingArray];
    [self sortArray:tempResolveArray];
    
    self.notificationArray = [NSMutableArray array];
    for (id tempObject in tempPendingArray) {
        [self.notificationArray addObject:tempObject];
    }
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_Auto Delete", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]] isEqualToString:@"YES"]) {
        for (id tempObject in tempResolveArray) {
            [self.notificationArray addObject:tempObject];
        }
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:self.notificationArray forKey:[NSString stringWithFormat:@"%@_NotificationAlerts", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]];
}

- (void) sortArray:(NSMutableArray*)sortArray {
    for (int i = 0; i < sortArray.count; i++) {
        for (int j = i; j < sortArray.count; j++) {
            double originTimeInterval = [sortArray[i][@"Time"] doubleValue];
            double changeTimeInterval = [sortArray[j][@"Time"] doubleValue];
            if (originTimeInterval < changeTimeInterval) {
                id tempObject = sortArray[i];
                sortArray[i] = sortArray[j];
                sortArray[j] = tempObject;
            }
        }
    }
}

- (void) makeNotificationStringWithConditionType:(NotificationCoditionType)conditionType notificationType:(NotificationType)notificationType {
    NSString *notificationContentString = [[LocalizationManager sharedLocalizationManager] getTextByKey:self.notificationContentArray[notificationType][conditionType]];
    NSString *notificationTitleString;
    if ((conditionType == ConditionErrorDone) || (conditionType == ConditionWarnDone)) {
        notificationTitleString = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"NotificationTitleInfo"];
    } else if (conditionType > 3) {
        notificationTitleString = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"NotificationTitleError"];
    } else {
        notificationTitleString = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"NotificationTitleWarning"];
    }
    [self startNotificationWithNotificationString:notificationContentString notificationTitle:notificationTitleString];

}

- (void) makeNotificationStringWithUsageType:(NotificationUsageType)usageType {
    NSString *usageContentString = [[LocalizationManager sharedLocalizationManager] getTextByKey:self.notificationUsageContentArray[usageType]];
    NSString *usageTitleString;
    if (usageType == UsageErrorType) {
        usageTitleString = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"NotificationTitleError"];
    } else if (usageType == UsageWarnType) {
        usageTitleString = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"NotificationTitleWarning"];
    } else {
        usageTitleString = [[LocalizationManager sharedLocalizationManager] getTextByKey:@"NotificationTitleInfo"];
    }
    [self startNotificationWithNotificationString:usageContentString notificationTitle:usageTitleString];
}

- (void) startNotificationWithNotificationString:(NSString*)notificationString notificationTitle:(NSString*)notificationTitle {
    
    if (self.canNotification && [[[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"%@_Notifications", [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"]]] isEqualToString:@"YES"]) {
        UILocalNotification* notifyWarn = [[UILocalNotification alloc] init];
        notifyWarn.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
        notifyWarn.timeZone = [NSTimeZone defaultTimeZone];
        notifyWarn.repeatInterval = 0;
        notifyWarn.soundName = UILocalNotificationDefaultSoundName;
        notifyWarn.applicationIconBadgeNumber = self.notificationArray.count;
        notifyWarn.alertBody = notificationString;
        notifyWarn.alertTitle = notificationTitle;
        [[UIApplication sharedApplication] scheduleLocalNotification:notifyWarn];
    }
}

- (void) refreshDashBoardAction {
    dashBoardCount++;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"timeAddAction" object:[NSString stringWithFormat:@"%d", dashBoardCount]];
    if (dashBoardCount == 10) {
        dashBoardCount = 0;
        [self stopDashBoardTimer];
        __weak typeof(self) weakSelf = self;
        NSString *hostIp = [[NSUserDefaults standardUserDefaults] objectForKey:@"HostIP"];
        [[CephAPI shareInstance] startGetClusterDataWithIP:hostIp Port:[[NSUserDefaults standardUserDefaults] objectForKey:@"Port"] Version:[APIRecord shareInstance].APIDictionary[@"Health"][0] ClusterID:[[NSUserDefaults standardUserDefaults] objectForKey:@"ClusterID"] Kind:[APIRecord shareInstance].APIDictionary[@"Health"][1] completion:^(BOOL finished) {
            if (finished) {
                [weakSelf  startDashBoardTimer];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"didRefreshDashBoardAction" object:nil];
            }
        } error:^(id error) {
            [weakSelf  startDashBoardTimer];
            NSLog(@"%@", error);
        }];

    }
}

- (void) startDashBoardTimer {
    [self stopDashBoardTimer];
    self.dashboardTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(refreshDashBoardAction) userInfo:nil repeats:YES];
}

- (void) stopDashBoardTimer {
    dashBoardCount = 0;
    [self.dashboardTimer invalidate];
    self.dashboardTimer = nil;
}

@end
