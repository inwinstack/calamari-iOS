//
//  ClusterData.m
//  CephAPITest
//
//  Created by Francis on 2015/4/9.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "ClusterData.h"
#import "HealthDetailData.h"
#import "OSDHealthData.h"
#import "MONHealthData.h"
#import "HostHealthData.h"
#import "PGData.h"
#import "DateMaker.h"

@interface ClusterData ()

@property (nonatomic, strong) NSDictionary *serviceNameDictionary;

@end

@implementation ClusterData

+ (ClusterData*) shareInstance {
    static ClusterData *clusterData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        clusterData = [[ClusterData alloc] init];
    });
    return clusterData;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.serviceNameArray = @[@"HEALTH", @"OSD", @"MONITOR", @"POOLS", @"HOSTS", @"PG STATUS", @"Usage", @"IOPS"];
        self.unitArray = @[@"sec ago", @"In & Up", @"Quorum", @"Active", @"Reporting", @"Clean", @"Used", @""];
        self.serviceNameDictionary = @{@"HEALTH" : @"health", @"POOLS" : @"pool", @"OSD" : @"osd", @"MONITOR" : @"mon", @"HOSTS" : @"hosts", @"PG STATUS" : @"pg", @"Usage" : @"usage", @"IOPS" : @"iops"};
        self.clusterArray = [NSMutableArray array];
        self.clusterDetailData = [NSMutableDictionary dictionary];
    }
    return self;
}

- (NSString*) getCurrentStatusWithID:(NSString *)clusterID {
    return [NSString stringWithFormat:@"%@", self.clusterDetailData[[NSString stringWithFormat:@"%@_health", clusterID]][@"report"][@"overall_status"]];
}

- (NSString*) getLastUpdateTimeWithID:(NSString*)clusterID {
    NSString *result = self.clusterDetailData[[NSString stringWithFormat:@"%@_health", clusterID]][@"report"][@"health"][@"health_services"][0][@"mons"][0][@"store_stats"][@"last_updated"];
    return [NSString stringWithFormat:@"%d", result.intValue];
}

- (NSString*) getCurrentValueWithStatus:(NSString*)status service:(NSString*)service clusterID:(NSString*)clusterID {
    NSString *serviceName = self.serviceNameDictionary[service];
    int HealthError = 0;
    int HealthWarn = 0;
    NSMutableSet *monSet = [NSMutableSet set];
    NSMutableSet *osdSet = [NSMutableSet set];
    
    NSString *usedCount = [self caculateByte:[[NSString stringWithFormat:@"%@", self.clusterDetailData[[NSString stringWithFormat:@"%@_space", clusterID]][@"space"][@"used_bytes"]] doubleValue]];
    NSString *available = [self caculateByte:[[NSString stringWithFormat:@"%@", self.clusterDetailData[[NSString stringWithFormat:@"%@_space", clusterID]][@"space"][@"free_bytes"]] doubleValue]];
    
    for (id dicObj in self.clusterDetailData[[NSString stringWithFormat:@"%@_health", clusterID]][@"report"][@"summary"]) {
        if ([dicObj[@"severity"] isEqualToString:@"HEALTH_WARN"]) {
            HealthWarn++;
        } else if ([dicObj[@"severity"] isEqualToString:@"HEALTH_ERR"]) {
            HealthError++;
        }
    }
    for (id object in self.clusterDetailData[[NSString stringWithFormat:@"%@_server", clusterID]]) {
        for (id typeObj in object[@"services"]) {
            if ([[NSString stringWithFormat:@"%@", typeObj[@"type"]] isEqualToString:@"osd"]) {
                [osdSet addObject:object];
            } else if ([[NSString stringWithFormat:@"%@", typeObj[@"type"]] isEqualToString:@"mon"]) {
                [monSet addObject:object];
            }
        }
    }
    
    if ([serviceName isEqualToString:@"iops"]) {
        NSMutableArray *dailyIOPSArray = [NSMutableArray array];
        double tempMax = 0.0;
        
        for (id object in [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_iops", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"datapoints"]) {
            if ([[NSString stringWithFormat:@"%@", object[1]] doubleValue] > tempMax) {
                tempMax = [[NSString stringWithFormat:@"%@", object[1]] doubleValue];
            }
        }
        
        tempMax = ceil(tempMax / 20.0) * 20.0;
        tempMax = (tempMax == 0.0) ? 20.0 : tempMax;
        for (int i = 1080; i < [[ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_iops", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"datapoints"] count] ; i++) {
            [dailyIOPSArray addObject:@[[[DateMaker shareDateMaker] getTimeWithTimeStamp:[NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_iops", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"datapoints"][i][0]]], [NSString stringWithFormat:@"%@", [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_iops", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"datapoints"][i][1]]]];
        }
        [self.clusterDetailData setObject:[NSString stringWithFormat:@"%.1f", tempMax] forKey:@"iops_max"];
        [self.clusterDetailData setObject:dailyIOPSArray forKey:@"iops"];
    }
    
    if ([status isEqualToString:@"Error"]) {
        NSString *otherError = [NSString stringWithFormat:@"%@", self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"critical"][@"count"]];
        NSString *OSD = [NSString stringWithFormat:@"%lu", (unsigned long)osdSet.count];
        if ([serviceName isEqualToString:@"hosts"]) {
            return OSD;
        } else if ([serviceName isEqualToString:@"health"]) {
            return [NSString stringWithFormat:@"%d", HealthError];
        } else if ([serviceName isEqualToString:@"usage"]) {
            return available;
        } else {
            return otherError;
        }
    } else if ([status isEqualToString:@"Warn"]) {
        NSString *otherWarn = [NSString stringWithFormat:@"%@", self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"warn"][@"count"]];
        NSString *MON = [NSString stringWithFormat:@"%lu", (unsigned long)monSet.count];
        if ([serviceName isEqualToString:@"hosts"]) {
            return MON;
        } else if ([serviceName isEqualToString:@"health"]) {
            return [NSString stringWithFormat:@"%d", HealthWarn];
        } else if ([serviceName isEqualToString:@"usage"]) {
            return usedCount;
        } {
            return otherWarn;
        }
    } else {
        if ([serviceName isEqualToString:@"pool"]) {
            return [NSString stringWithFormat:@"%ld", [self.clusterDetailData[[NSString stringWithFormat:@"%@_pool", clusterID]] count]];
        } else if ([serviceName isEqualToString:@"osd"]) {
            return [NSString stringWithFormat:@"%@ / %d", self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"ok"][@"count"], (int)[self.clusterDetailData[[NSString stringWithFormat:@"%@_osd", clusterID]][@"osds"] count]];
        } else if ([serviceName isEqualToString:@"mon"]) {
            int monTotal = [self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"ok"][@"count"] intValue] + [self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"critical"][@"count"] intValue] + [self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"warn"][@"count"] intValue];
            return [NSString stringWithFormat:@"%@ / %d", self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"ok"][@"states"][@"in"], monTotal];
        } else if ([serviceName isEqualToString:@"hosts"]) {
            return [NSString stringWithFormat:@"%ld",  [self.clusterDetailData[[NSString stringWithFormat:@"%@_server", clusterID]] count]];
        } else if ([serviceName isEqualToString:@"pg"]) {
            NSString *activeString = [NSString stringWithFormat:@"%d", [self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"ok"][@"count"] intValue] + [self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"warn"][@"count"] intValue] + [self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"critical"][@"count"] intValue]];
            NSString *cleanString = (self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"ok"][@"states"][@"clean"]) ? [NSString stringWithFormat:@"%@", self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][serviceName][@"ok"][@"states"][@"clean"]] : @"0";
            return [NSString stringWithFormat:@"%@ / %@",  cleanString, activeString];
        } else if ([serviceName isEqualToString:@"usage"]) {
            NSString *capacity_bytes = [NSString stringWithFormat:@"%@", self.clusterDetailData[[NSString stringWithFormat:@"%@_space", clusterID]][@"space"][@"capacity_bytes"]];
            NSString *used_bytes = [NSString stringWithFormat:@"%@", self.clusterDetailData[[NSString stringWithFormat:@"%@_space", clusterID]][@"space"][@"used_bytes"]];
            double quotas = [used_bytes doubleValue] / [capacity_bytes doubleValue] * 100;
            return [NSString stringWithFormat:@"%d%%", (int) quotas];
        } else {
            return @"";
        }
    }
}

- (NSString*) caculateByte:(double)value {
    int count = 0;
    while (value > 1024.0) {
        value = value / 1024.0;
        count++;
        if (count == 4) {
            break;
        }
    }
    NSString *unit;
    switch (count) {
        case 0: {
            return @"1 KB";
            break;
        } case 1: {
            unit = @"KB";
            break;
        } case 2: {
            unit = @"MB";
            break;
        } case 3: {
            unit = @"GB";
            break;
        } case 4: {
            unit = @"TB";
            break;
        }
            
    }
    if (value >= 100) {
        return [NSString stringWithFormat:@"%d %@", (int)value, unit];
    } else if (value >= 10) {
        return [NSString stringWithFormat:@"%.1f %@", value, unit];
    } else {
        return [NSString stringWithFormat:@"%.2f %@", value, unit];
    }
}

- (void) setData:(NSString*)clusterID completion:(void (^)(BOOL finished))completion {
    [HealthDetailData shareInstance].detailArray = (NSMutableArray*)self.clusterDetailData[[NSString stringWithFormat:@"%@_health", clusterID]][@"report"][@"summary"];
    [OSDHealthData shareInstance].osdArray = (NSMutableArray*)self.clusterDetailData[[NSString stringWithFormat:@"%@_osd", clusterID]][@"osds"];
    [MONHealthData shareInstance].monArray = (NSMutableArray*)self.clusterDetailData[[NSString stringWithFormat:@"%@_mon", clusterID]];
    [[MONHealthData shareInstance] startSort];
        
    NSMutableSet *hostSet = [NSMutableSet set];
    
    for (id object in self.clusterDetailData[[NSString stringWithFormat:@"%@_server", clusterID]]) {
        for (id typeObj in object[@"services"]) {
            if ([[NSString stringWithFormat:@"%@", typeObj[@"type"]] isEqualToString:@"osd"]) {
                [hostSet addObject:object];
            }
        }
    }
    NSMutableDictionary *tempHostDic = [NSMutableDictionary dictionary];
    NSMutableArray *hostKeyArray = [NSMutableArray array];
    for (id tempObj in hostSet) {
        [hostKeyArray addObject:tempObj[@"name"]];
        [tempHostDic setObject:tempObj forKey:tempObj[@"name"]];
    }
    
    for (int j = 0; j < hostKeyArray.count; j++) {
        for (int k = 0; k < (hostKeyArray.count - 1); k++) {
            NSString *testA = [NSString stringWithFormat:@"%@", hostKeyArray[k]];
            NSString *testB = [NSString stringWithFormat:@"%@", hostKeyArray[k + 1]];
            if ((([testA compare:testB] == 1) && testA.length == testB.length) || testA.length > testB.length) {
                NSString *object = [NSString stringWithFormat:@"%@", hostKeyArray[k]];
                hostKeyArray[k] = hostKeyArray[k + 1];
                hostKeyArray[k + 1] = object;
            }
        }
    }
    
    [HostHealthData shareInstance].hostAllData = tempHostDic;
    [HostHealthData shareInstance].hostArray = hostKeyArray;
    
    
    [PGData shareInstance].criticalCount = [NSString stringWithFormat:@"%@", self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][@"pg"][@"critical"][@"count"]];
    [PGData shareInstance].warnCount = [NSString stringWithFormat:@"%@", self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][@"pg"][@"warn"][@"count"]];
    [PGData shareInstance].okCount = [NSString stringWithFormat:@"%@", self.clusterDetailData[[NSString stringWithFormat:@"%@_health_counters", clusterID]][@"pg"][@"ok"][@"count"]];
    [PGData shareInstance].pgDic = [NSMutableDictionary dictionaryWithDictionary:self.clusterDetailData[[NSString stringWithFormat:@"%@_osd", clusterID]][@"pg_state_counts"]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        completion(true);
    });
}

@end
