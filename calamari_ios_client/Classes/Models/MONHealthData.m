//
//  MONHealthData.m
//  inWinStackCeph
//
//  Created by Francis on 2015/5/25.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import "MONHealthData.h"
#import "ClusterData.h"

@implementation MONHealthData

+ (MONHealthData*) shareInstance {
    static MONHealthData *monHealthData = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monHealthData = [[MONHealthData alloc] init];
    });
    return monHealthData;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        self.monArray = [NSMutableArray array];
    }
    return self;
}

- (void) startSort {
    NSMutableArray *tempArray = [NSMutableArray array];
    for (id monDic in self.monArray) {
        for (id object in [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"report"][@"health"][@"health_services"][0][@"mons"]) {
            if ([monDic[@"name"] isEqualToString:[NSString stringWithFormat:@"%@", object[@"name"]]]) {
                if ([[NSString stringWithFormat:@"%@", object[@"health"]] isEqualToString:@"HEALTH_ERROR"]) {
                    [tempArray addObject:monDic];
                }
            }
        }
    }
    
    for (id monDic in self.monArray) {
        for (id object in [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"report"][@"health"][@"health_services"][0][@"mons"]) {
            if ([monDic[@"name"] isEqualToString:[NSString stringWithFormat:@"%@", object[@"name"]]]) {
                if ([[NSString stringWithFormat:@"%@", object[@"health"]] isEqualToString:@"HEALTH_WARN"]) {
                    [tempArray addObject:monDic];
                }
            }
        }
    }
    
    for (id monDic in self.monArray) {
        for (id object in [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"report"][@"health"][@"health_services"][0][@"mons"]) {
            if ([monDic[@"name"] isEqualToString:[NSString stringWithFormat:@"%@", object[@"name"]]]) {
                if ([[NSString stringWithFormat:@"%@", object[@"health"]] isEqualToString:@"HEALTH_OK"]) {
                    [tempArray addObject:monDic];
                }
            }
        }
    }
    
    self.monArray = tempArray;
}

- (NSString*) checkMonWithNodeName:(NSString*)nodeName {
    NSString *statusString;
    for (id object in [ClusterData shareInstance].clusterDetailData[[NSString stringWithFormat:@"%@_health", [ClusterData shareInstance].clusterArray[0][@"id"]]][@"report"][@"health"][@"health_services"][0][@"mons"]) {
        if ([nodeName isEqualToString:[NSString stringWithFormat:@"%@", object[@"name"]]]) {
            statusString = [NSString stringWithFormat:@"%@", object[@"health"]];
        }
    }
    return statusString;
}

@end
