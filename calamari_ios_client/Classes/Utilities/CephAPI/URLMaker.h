//
//  URLMaker.h
//  CephAPITest
//
//  Created by Francis on 2015/4/8.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLMaker : NSObject

+ (NSString*) getLoginURLWithIP:(NSString*)ip Port:(NSString*)port;
+ (NSString*) getUserInfoWithIP:(NSString*)ip Port:(NSString*)port;
+ (NSString*) getClusterListURLWithIP:(NSString*)ip Port:(NSString*)port;
+ (NSString*) getClusterDetailWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID;
+ (NSString*) getClusterDataWithIP:(NSString*)ip Port:(NSString*)port Version:(NSString*)version ClusterID:(NSString*)clusterID Kind:(NSString*)kind;
+ (NSString*) getOSDDataWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID OSDID:(NSString*)osdID;
+ (NSString*) getIOPSDataWithIp:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID;
+ (NSString*) getLogoutURLWithIP:(NSString*)ip Port:(NSString*)port;
+ (NSString*) getIOPSIDWithIp:(NSString*)ip port:(NSString*)port ClusterID:(NSString*)clusterID;
+ (NSString*) getUsageStatusDataWithIp:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID;
+ (NSString*) getPoolIOPSWithIp:(NSString*)ip Port:(NSString*)port PoolID:(NSString*)poolID;
+ (NSString*) getPoolListWithIp:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID;
+ (NSString*) getAllDataWithIP:(NSString*)ip Port:(NSString*)port nodeID:(NSString*)nodeID whichAll:(NSString*)whichType;
+ (NSString*) getAllCPUsWithIP:(NSString *)ip Port:(NSString *)port cpuID:(NSString*)cpuID;
+ (NSString*) getCPUPercentWithIP:(NSString*)ip Port:(NSString*)port nodeID:(NSString*)nodeID;
+ (NSString*) getCPULoadAverageWithIP:(NSString*)ip Port:(NSString*)port nodeID:(NSString*)nodeID;
+ (NSString*) getCPUByteWithIP:(NSString*)ip Port:(NSString*)port nodeID:(NSString*)nodeID;
+ (NSString*) getCPUIOPSWithIP:(NSString*)ip Port:(NSString*)port iopsID:(NSString*)iopsID;

+ (NSString*) getAlertRuleStringWithHostIp:(NSString*)hostIp port:(NSString*)port;
+ (NSString*) getSetAlertTriggerStringWithHostIp:(NSString*)hostIp port:(NSString*)port kind:(NSString *)kind warnError:(NSString *)warnError;
+ (NSString*) getSetTimePeriodStringWithHostIp:(NSString*)hostIp port:(NSString*)port kind:(NSString*)kind;
+ (NSString*) getSetEmailEnableUrlStringWithHostIp:(NSString*)hostIp port:(NSString*)port;

@end
