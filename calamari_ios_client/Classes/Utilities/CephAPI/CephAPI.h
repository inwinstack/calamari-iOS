//
//  CephAPI.h
//  CephAPITest
//
//  Created by Francis on 2015/4/8.
//  Copyright (c) 2015年 Francis. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CephAPI : NSObject

+ (CephAPI*) shareInstance;

- (void) startGetSessionWithIP:(NSString*)ip Port:(NSString*)port Account:(NSString*)account Password:(NSString*)password completion:(void (^)(BOOL finished))completion error:(void (^)(id error))error;
- (void) startGetClusterListWithIP:(NSString*)ip Port:(NSString*)port completion:(void (^)(BOOL finished))completion error:(void (^)(id error))error;
- (void) startGetClusterDetailWithIP:(NSString *)ip Port:(NSString *)port ClusterID:(NSString*)clusterID completion:(void (^)(BOOL finished))completion error:(void (^)(id error))error;
- (void) startGetClusterDataWithIP:(NSString *)ip Port:(NSString *)port Version:(NSString*)version ClusterID:(NSString*)clusterID Kind:(NSString*)kind completion:(void (^)(BOOL finished))completion error:(void (^)(id error))error;
- (void) startGetOSDDataWithIP:(NSString *)ip Port:(NSString *)port ClusterID:(NSString*)clusterID OSDID:(NSString*)osdID completion:(void (^)(BOOL finished))completion error:(void (^)(id error))error;
- (void) startGetClusterDetailAtBackgroundCompletion:(void (^)(BOOL finished))completion error:(void (^)(id error))backgroundError;
- (void) startGetIOPSDataWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError;
- (void) startGetIOPSIDWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError;
- (void) startGetPoolIOPSWithIP:(NSString*)ip Port:(NSString*)port PoolID:(NSString*)poolID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError;
- (void) startGetPoolListWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError;
- (void) startGetUsageStatusWithIP:(NSString*)ip Port:(NSString*)port ClusterID:(NSString*)clusterID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError;
- (void) startGetAllDataWithIP:(NSString*)ip Port:(NSString*)port nodeID:(NSString*)nodeID whichType:(NSString*)whichType Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError;
- (void) startGetAllCPUDataWithIP:(NSString*)ip Port:(NSString*)port cpuArray:(NSArray*)cpuArray Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError;
- (void) startGetCPUSummaryDataWithIP:(NSString *)ip Port:(NSString *)port nodeID:(NSString *)nodeID Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError;
- (void) startGetCPUIOPSDataWithIP:(NSString *)ip Port:(NSString *)port iopsArray:(NSArray*)iopsArray Completion:(void (^)(BOOL finished))completion error:(void (^)(id error))getError;

- (void) startGetAlertTriggerApiWithIp:(NSString*)hostIp port:(NSString*)port Completion:(void (^)(BOOL finished))completion error:(void (^)(id getError))getError;
- (void) startPostAlertTriggerApiWithHostIp:(NSString*)hostIp port:(NSString*)port kind:(NSString*)kind warnError:(NSString*)warnError fieldName:(NSString*)fieldName value:(NSString*)value completion:(void (^)(BOOL finished))completion error:(void (^)(id postError))postError;
- (void) startPostTimePeroidApiWithHostIp:(NSString*)hostIp port:(NSString*)port kind:(NSString*)kind fieldName:(NSString*)fieldName value:(NSString*)value completion:(void (^)(BOOL finished))completion error:(void (^)(id postError))postError;
- (void) startPostEmailEnableWithIp:(NSString*)hosIp port:(NSString*)port value:(NSString*)value Completion:(void (^)(BOOL finshed))completion error:(void (^)(id postError))postError;
- (void) startGetEmailNumberWithIp:(NSString*)hostIp port:(NSString*)port Completion:(void (^)(BOOL finshed))completion error:(void (^)(id postError))postError;

@end
